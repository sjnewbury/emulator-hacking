# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit desktop flag-o-matic wxwidgets meson

DESCRIPTION="A PC emulator that specializes in running old operating systems and software"
HOMEPAGE="
	https://pcem-emulator.co.uk/
	https://github.com/sarah-walker-pcem/pcem/
"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarah-walker-pcem/pcem.git"
	inherit git-r3
else
	SRC_URI="https://pcem-emulator.co.uk/files/PCemV${PV}Linux.tar.gz"
	KEYWORDS="amd64"
	S="${WORKDIR}"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="alsa networking"


RDEPEND="
	alsa? ( media-libs/alsa-lib )
	media-libs/libsdl2
	media-libs/openal
	x11-libs/wxGTK:${WX_GTK_VER}[tiff]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "README.md" "TESTED.md" )

src_configure() {
	setup-wxwidgets

	# Does not compile with -fno-common.
	# See https://pcem-emulator.co.uk/phpBB3/viewtopic.php?f=3&t=3443
	append-cflags -fcommon
	append-cppflags -DRELEASE_BUILD

	local mymesonargs=(
		-Duse-alsa=$(usex alsa true false)
		-Duse-networking=$(usex networking true false)
		-Dallow-experimental-code=true
	)

	meson_src_configure "${mymesonargs[@]}"
}

src_install() {
	meson_src_install

	make_desktop_entry "pcem" "PCem" pcem "Development;Utility"

	einstalldocs
}

pkg_postinst() {
	elog "In order to use PCem, you will need some roms for various emulated systems."
	elog "You can either install globally for all users or locally for yourself."
	elog ""
	elog "To install globally, put your ROM files into '${ROOT}/usr/share/pcem/roms/<system>'."
	elog "To install locally, put your ROM files into '~/.pcem/roms/<system>'."
}
