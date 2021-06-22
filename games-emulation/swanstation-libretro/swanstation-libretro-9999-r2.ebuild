# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libretro-core cmake

DESCRIPTION="DuckStation is a totally new PlayStation 1 emulator for libretro. (PlayStation, swanstation version)"
HOMEPAGE="https://github.com/libretro/swanstation.git"
KEYWORDS=""

EGIT_REPO_URI=https://github.com/libretro/swanstation.git

LICENSE="GPL-2"
SLOT="0"

DEPEND="dev-libs/xxhash[dispatch]
	sys-libs/zlib
	dev-libs/rapidjson"

RDEPEND="${DEPEND}
		games-emulation/libretro-info"

LIBRETRO_CORE_NAME=()

src_unpack() {
	# We need to add the different core names to the array
	# in order to let the eclass handle the install
	LIBRETRO_CORE_NAME+=( swanstation )
	libretro-core_src_unpack
}

src_prepare() {
	default
	eapply "${FILESDIR}"/libretro-deps.patch
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DBUILD_LIBRETRO_CORE=ON
	)
	cmake_src_configure
}

src_install() {
	LIBRETRO_CORE_LIB_FILE=${WORKDIR}/${P}_build/${LIBRETRO_CORE_NAME}_libretro.so
	libretro-core_src_install
}


pkg_preinst() {
	if ! has_version "=${CATEGORY}/${PN}-${PVR}"; then
		first_install="1"
	fi
}

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		ewarn ""
		ewarn "You need to have the following files in your 'system_directory' folder:"
		ewarn "scph5500.bin md5sum = 8dd7d5296a650fac7319bce665a6a53c"
		ewarn "scph5501.bin md5sum = 490f666e1afb15b7362b406ed1cea246"
		ewarn "scph5502.bin md5sum = 32736f17079d0b2b7024407c39bd3050"
		ewarn ""
		ewarn ""
	fi
}
