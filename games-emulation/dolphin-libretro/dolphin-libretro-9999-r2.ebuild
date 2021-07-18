# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LIBRETRO_REPO_NAME="libretro/${PN//-libretro}"

inherit cmake-utils libretro-core

DESCRIPTION="libretro implementation of Dolphin. (Nintendo GC/Wii)"
HOMEPAGE="https://github.com/libretro/dolphin"
KEYWORDS=""

LICENSE="GPL-2"
SLOT="0"
IUSE="opengl vulkan"

PATCHES=(
	"${FILESDIR}"/constant-array-index.patch
	"${FILESDIR}"/missing-include.patch
)

DEPEND="opengl? ( virtual/opengl )
	vulkan? ( media-libs/vulkan-loader:0= )"
RDEPEND="${DEPEND}
		games-emulation/libretro-info"


src_configure() {
	local mycmakeargs=(
		-DLIBRETRO=ON
		-DENABLE_QT=OFF
	)
	cmake-utils_src_configure
}

src_compile() {
	cd "${BUILD_DIR}"
	emake -C Source/Core/DolphinLibretro
}

src_install() {
	LIBRETRO_CORE_LIB_FILE="${BUILD_DIR}/${LIBRETRO_CORE_NAME}_libretro.so" \
		libretro-core_src_install
}
