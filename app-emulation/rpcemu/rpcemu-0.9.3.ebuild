# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils desktop

if [[ ${PV} == 9999* ]]; then
	inherit mercurial
	EHG_REPO_URI=http://www.home.marutan.net/hg/rpcemu
	SRC_URI=
	KEYWORDS=
else
	SRC_URI="http://www.home.marutan.net/hg/rpcemu/archive/release_${PV}.tar.bz2"
	KEYWORDS="amd64"
fi

DESCRIPTION="An Acorn RiscPC emulator"
HOMEPAGE="http://www.marutan.net/rpcemu/index.php"

LICENSE="GPL-2+"
SLOT="0"

PATCHES=("${FILESDIR}/${P}-xdg-dirs.patch")

DEPENDS="
	dev-qt/qtcore:5
	dev-qt/qtmultmedia:5
	dev-libs/libxdg-basedir
"

S=${WORKDIR}/"${PN}"-release_"${PV}"

src_prepare() {
	default
	append-cflags -fcommon
	cd src/qt5
	sed -i -e '/^CONFIG +=/s/$/ dynarec/' rpcemu.pro || die
	eqmake5
}

src_compile() {
	cd src/qt5
	emake
}

src_install() {
	exeinto /usr/bin
	doexe rpcemu-recompiler
	insinto /usr/share/"${PN}"
	doins -r netroms roms
	# riscos-progs
	doins cmos.ram rpc.cfg
	insinto /usr/share/doc/"${P}"
	doins COPYING readme.txt
	doicon src/qt5/rpcemu_icon.png

	dodir /usr/share/"${PN}"/poduleroms
	insinto /usr/share/"${PN}"/poduleroms
	doins riscos-progs/HostFS/hostfs,ffa
	doins riscos-progs/HostFS/hostfsfiler,ffa
	doins riscos-progs/SyncClock/SyncClock,ffa

	make_desktop_entry rpcemu-recompiler RPCEmu rpcemu_icon "System;Emulator"
}
