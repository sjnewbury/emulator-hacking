# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit libretro-core

LIBRETRO_CORE_NAME=${LIBRETRO_CORE_NAME/-/_}

DESCRIPTION="MAME2003+ (0.78 with new features and extra ROM support) for libretro."
HOMEPAGE="https://github.com/libretro/mame2003-plus-libretro"
KEYWORDS=""

LICENSE="MAME-GPL"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"
