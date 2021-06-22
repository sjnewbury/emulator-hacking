# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils flag-o-matic eutils git-r3

DESCRIPTION="Hercules System/370, ESA/390 and zArchitecture Mainframe Emulator"
HOMEPAGE="http://www.hercules-390.eu/"
#SRC_URI="http://downloads.hercules-390.eu/${P}.tar.gz"
EGIT_REPO_URI=https://github.com/hercules-390/hyperion.git
LICENSE="QPL-1.0"
SLOT="0"
KEYWORDS=""
IUSE="bzip2 custom-cflags suid +caps"

RDEPEND="bzip2? ( app-arch/bzip2 )
	sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-libs/s3fh"

REQUIRED_USE="
	suid? ( !caps )
"

PATCHES=( "${FILESDIR}/${PN}-gentoo-conftype.patch" )

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	use custom-cflags || strip-flags

	local mycmakeargs=(
		-DS3FH_DIR="/usr"
		-DCCKD-BZIP2="$(usex bzip2)"
		-DHET-BZIP2="$(usex bzip2)"
		-DCAPABILITIES="$(usex caps)"
		-DSETUID-HERCIFC="$(usex suid)"
		-DCUSTOM="Gentoo ${PF}.ebuild"
		-DOPTIMIZATION="${CFLAGS}"
	)
	cmake-utils_src_configure
}

src_install() {
	default
	cmake-utils_src_install
	# clean up install breakage
	rm -rf "${D}"/var

	insinto /usr/share/hercules
	cd "${S}"
	doins hercules.cnf
	dodoc README.* RELEASE.NOTES
	dohtml -r html
}
