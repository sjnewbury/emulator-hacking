# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 autotools

DESCRIPTION="BBC Micro and Master 128 emulator."
HOMEPAGE=http://www.mkw.me.uk/beebem/
LICENSE=GPL-2

EGIT_REPO_URI=https://github.com/sjnewbury/beebem.git

SLOT=0

DEPEND="media-libs/libsdl
	x11-libs/gtk+:2
	sys-libs/zlib"

src_prepare() {
	eapply "${FILESDIR}/0001-Use-DESTDIR-when-installing-into-pkgdatadir.patch"
	default
	eautoreconf
}
