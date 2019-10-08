# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit java-pkg-2

DESCRIPTION="A small library to allow the use of IPv4 ICMP (raw) packets in Java"
HOMEPAGE="http://www.opennms.org/wiki/jicmp"
SRC_URI="mirror://sourceforge/opennms/JICMP/stable-1.4/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

src_install() {
  emake DESTDIR="$(D)" install || die
}
