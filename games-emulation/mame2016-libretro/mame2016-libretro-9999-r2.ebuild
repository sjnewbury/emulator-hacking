# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{8,9,10} )

inherit libretro-core python-any-r1

DESCRIPTION="MAME (0.174) for libretro."
HOMEPAGE="https://github.com/libretro/mame2016-libretro"
KEYWORDS=""

LICENSE="MAME-GPL"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

pkg_setup() {
	python-any-r1_pkg_setup
	export PYTHON_EXECUTABLE="${PYTHON}"
}
