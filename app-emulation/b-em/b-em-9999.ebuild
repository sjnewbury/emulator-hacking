# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 autotools flag-o-matic

DESCRIPTION="B-em is an attempt to emulate a BBC Micro, made by Acorn Computers in the 80s."
HOMEPAGE=http://b-em.bbcmicro.com/
LICENSE=GPL-2

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI=https://github.com/stardot/b-em.git
	KEYWORDS=
else
	SRC_URI=http://b-em.bbcmicro.com/B-emv"${PV}"Linux.tar.gz
	KEYWORDS="amd64 x86"
fi

SLOT=0

DEPEND=">=media-libs/allegro-5.1:5
	media-libs/openal
	media-libs/freealut
	sys-libs/zlib"

src_prepare() {
	default

	# allegro-config test fails otherwise
	append-flags -Wno-error=unused-result

	# multi if conditionals per line confuses gcc
	append-flags -Wno-error=misleading-indentation

	# oldpc is defined as 32bit for x86 and 16bit for 6502
	filter-flags -flto*

	sed -i \
		-e '/^bin_PROGRAMS/s/ jstest//'	\
		-e '/^jstest/d' \
		src/Makefile.am || die "sed failed"

	AT_M4DIR=. eautoreconf

}
