# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME=libretro/libretro-o2em

inherit libretro-core

DESCRIPTION="libretro implementation of O2EM (Odyssey2 / Videopac+)"
HOMEPAGE="https://github.com/libretro/libretro-o2em"
KEYWORDS=""

LICENSE="Artistic"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info"

pkg_preinst() {
	if ! has_version "=${CATEGORY}/${PN}-${PVR}"; then
		first_install="1"
	fi
}

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		elog ""
		elog "You should put the following required files in your 'system_directory' folder:"
		elog "o2rom.bin (Odyssey2 BIOS - G7000 model)"
		elog "fdc52.bin (Videopac+ French BIOS - G7000 model)"
		elog "g7400.bin (Videopac+ European BIOS - G7400 model)"
		elog "jopac.bin (Videopac+ French BIOS - G7400 model)"
		elog ""
		ewarn ""
	fi
}
