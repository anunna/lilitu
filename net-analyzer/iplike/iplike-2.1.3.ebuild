# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="C implementation of the OpenNMS iplike stored procedure"
HOMEPAGE="http://www.opennms.org/wiki/IPLIKE"
SRC_URI="mirror://sourceforge/opennms/IPLIKE/stable-2.1/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="dev-db/postgresql"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die
}

