# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LIBRETRO_REPO_NAME="libretro/${PN//-libretro}"
inherit libretro-core

DESCRIPTION="Port of Final Burn Neo to Libretro"
HOMEPAGE="https://github.com/libretro/fbneo"
KEYWORDS=""

LICENSE="FBA"
SLOT="0"

RDEPEND="games-emulation/libretro-info"
DEPEND="${RDEPEND}
	games-util/datutil"

S="${WORKDIR}/${P}/src/burner/libretro"
   
src_compile() {
	libretro-core_src_compile

	einfo Converting DAT files
	for DATFILE in "${WORKDIR}"/"${P}"/dats/*.dat; do
		CONVDAT=$(basename "${DATFILE}" | sed -e 's/.*,\(.*\)\ only)/FBNeo\ -\1/')
		datutil "${DATFILE}" -f listinfo -o ${T}/"${CONVDAT}"
	done
}

src_install() {
	libretro-core_src_install
	insinto /usr/share/libretro/data
	doins "${T}"/*.dat
}
