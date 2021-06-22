# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit autotools desktop flag-o-matic wxwidgets

DESCRIPTION="A Freeware Acorn Archimedes Emulator for Windows and Linux"
HOMEPAGE="
	http://b-em.bbcmicro.com/arculator/index.html
	https://github.com/sarah-walker-pcem/arculator/
"
if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sarah-walker-pcem/arculator.git"
else
	SRC_URI="http://b-em.bbcmicro.com/arculator/Arculator_V2.0_Linux.tar.gz"
	KEYWORDS="amd64"
fi


LICENSE="GPL-2+"
SLOT="0"
IUSE=""

RDEPEND="
	media-libs/libsdl2
	media-libs/openal
	x11-libs/wxGTK:${WX_GTK_VER}[tiff,X]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "Readme-LINUX.txt" "README" "readme.txt" )

PATCHES=(
	"${FILESDIR}/${P}-respect-cflags.patch"
	"${FILESDIR}/${P}-unused-attribute.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	setup-wxwidgets

	# Does not compile with -fno-common.
	# See https://pcem-emulator.co.uk/phpBB3/viewtopic.php?f=3&t=3443
	append-cflags -fcommon

	local myeconfargs=(
		--enable-release-build
		--with-wx-config="${WX_CONFIG}"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /usr/share/arculator
	doins -r configs roms cmos podules

	newicon src/icons/32x32/motherboard.png arculator.png
	make_desktop_entry "arculator" "ARCulator" arculator "Development;Utility"

	einstalldocs
}

pkg_postinst() {
	elog "In order to use ARCulator, you will need some roms for various emulated systems."
	elog "You can either install globally for all users or locally for yourself."
	elog ""
	elog "To install globally, put your ROM files into '${ROOT}/usr/share/arculator/roms/<system>'."
	elog "To install locally, put your ROM files into '~/.arculator/roms/<system>'."
}
