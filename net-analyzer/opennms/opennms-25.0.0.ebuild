# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

JAVA_PKG_DEBUG=true
inherit java-pkg-2

SRC_PN=opennms-source
# RN is 1 usually
RN=1
DESCRIPTION="Enterprise-grade Network Management Platform"
HOMEPAGE="http://www.opennms.org/"
SRC_URI="mirror://sourceforge/${PN}/OpenNMS-Source/stable-${PV}/${SRC_PN}-${PV}-${RN}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="unprivileged"

DEPEND="dev-db/postgresql
	virtual/jdk
  unprivileged? ( =dev-java/icedtea-3.13.0 )"
RDEPEND="${DEPEND}
	net-analyzer/iplike
	dev-java/jicmp
	dev-java/jrrd
	net-analyzer/rrdtool
  unprivileged? ( dev-util/patchelf sys-libs/libcap )"

S="${WORKDIR}/${P}-${RN}"

pkg_setup() {
	if use unprivileged ; then
		ebegin "Creating opennms user and group"
		enewgroup ${PN}
		enewuser ${PN} -1 -1 -1 ${PN}
		eend ${?}
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
#	epatch "${FILESDIR}/25.0.0-1-opennms-gentoo.patch"
}

src_compile() {
	MAVEN_OPTS="-Dopennms.home=/opt/opennms
				-Dinstall.share.dir=/var/lib/opennms
				-Dinstall.logs.dir=/var/log/opennms
				-Dinstall.pid.file=/var/run/opennms/opennms.pid
				-Ddist.name=opennms"
	cd ${S}
	# see http://issues.opennms.org/ for issues with IcedTea
	${JAVA_HOME}/bin/java -version
	./compile.pl $MAVEN_OPTS  || die compile.pl failed
	./assemble.pl $MAVEN_OPTS -Dbuild.profile=dir || die assemble.pl failed
	# rpm spec has this, but nothing builds..
	#cd opennms-tools
	#../compile.pl -N $MAVEN_OPTS install
}

src_install() {
	newinitd ${FILESDIR}/${PN}.init ${PN}
	newenvd ${FILESDIR}/${PN}.env 21${PN}

	cd ${S}/target/opennms
	dodir /opt/opennms/{bin,contrib,etc,jetty-webapps,lib,remote-poller}
	insinto /opt/opennms/remote-poller
	doins bin/remote-poller.jar
	exeinto /opt/opennms/remote-poller
	doexe bin/remote-poller.sh
	rm -f bin/remote-poller.*
	exeinto /opt/opennms/bin
	doexe bin/*
	insinto /opt/opennms
	doins -r contrib etc jetty-webapps lib
	insinto /var/lib/opennms
	doins -r share/*

	# create data and logs directories
	# /var/run/opennms is kept for easy priveleged-unprivileged switch
	DATADIRS="/var/lib/opennms
		/var/run/opennms
		/var/log/opennms/controller
		/var/log/opennms/daemon
		/var/log/opennms/webapp"
	keepdir ${DATADIRS}

	if use unprivileged ; then
		fowners -R opennms:opennms ${DATADIRS}

		# opennms wants to write own configuration
		fowners -R opennms:opennms /opt/opennms/etc

		# change user if we are not going to run as root
		sed -i 's!^RUNAS=".*"!RUNAS="root"!' ${D}/opt/opennms/bin/opennms
		sed -i 's!^UNPRIVILEGED=".*"!UNPRIVILEGED="yes"!' ${D}/etc/init.d/opennms
	fi

}

pkg_postinst() {
	if use unprivileged ; then
		elog "Java executable must be modified to be able to run not as root"
		elog "and send ICMP packets. Please run following commands each time"
		elog "as java binary is updated:"
		elog "patchelf --set-rpath /usr/lib64/icedtea7/jre/lib/amd64/jli /usr/lib64/icedtea7/bin/java"
		elog "setcap 'cap_net_raw+eip' /usr/lib64/icedtea7/bin/java"
		elog
		elog "If you will use trapd, you could setup firewall rule to redirect"
		elog "snmp traps like that:"
		elog "iptables -t nat -A PREROUTING -m udp -p udp --dport 162 -j REDIRECT --to-ports 1162"
		elog
		elog "or add cap_net_bind_service capability:"
		elog "setcap 'cap_net_bind_service+eip' /usr/lib64/icedtea7/bin/java"
		elog
		elog "Problem with rpath is described here:"
		elog "http://sources.redhat.com/bugzilla/show_bug.cgi?id=11570"
	fi
}
