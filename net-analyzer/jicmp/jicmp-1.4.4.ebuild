# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="A Java based fault and performance management system"
HOMEPAGE="http://www.opennms.org/wiki/jicmp"
SRC_URI="mirror://sourceforge/opennms/JICMP/stable-1.4/${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND="virtual/jdk"
RDEPEND="${DEPEND}"

src_install() {
  emake DESTDIR="$(D)" install || die
}
