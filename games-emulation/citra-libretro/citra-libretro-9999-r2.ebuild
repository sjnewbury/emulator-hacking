# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LIBRETRO_REPO_NAME="libretro/${PN//-libretro}"
# These are used by citra and externals/dynarmic which seems to break with git-r3.eclass
inherit libretro-core cmake-utils
#EGIT_SUBMODULES=("*" "-fmt" "-boost" "-cryptopp" "-libressl" "-libusb" "-zstd")
EGIT_REPO_URI=https://github.com/sjnewbury/citra
EGIT_BRANCH=rebase-20210915

DESCRIPTION="libretro implementation of Citra. (Nintendo 3DS)"
HOMEPAGE="https://github.com/libretro/citra"
KEYWORDS=""

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

RDEPEND="virtual/opengl
	media-libs/libpng:=
	sys-libs/zlib
	media-libs/libsdl2
	dev-libs/xbyak
	dev-libs/libfmt
	"
DEPEND="${DEPEND}"

src_prepare() {
	default
	#eapply "${FILESDIR}"/0001-Unbundle-libraries.patch
	#eapply "${FILESDIR}"/lodepng.patch
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_LIBRETRO="ON"
		-DENABLE_QT="OFF"
		-DENABLE_SDL2="OFF"
		-DUSE_SYSTEM_XBYAK="OFF"
		-DUSE_SYSTEM_FMT="OFF"
		-DUSE_SYSTEM_CRYPTOPP="OFF"
		-DUSE_SYSTEM_BOOST="OFF"
		-DUSE_SYSTEM_SSL="OFF"
		-DUSE_SYSTEM_ZSTD="OFF"
		-DUSE_SYSTEM_SOUNDTOUCH="OFF"
		-DUSE_SYSTEM_ENET="OFF"
	)
	cmake-utils_src_configure
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${WORKDIR}/${P}_build/src/${LIBRETRO_CORE_NAME}_libretro/${LIBRETRO_CORE_NAME}_libretro.so"
	libretro-core_src_install
}
