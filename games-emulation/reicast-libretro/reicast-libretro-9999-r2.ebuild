# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LIBRETRO_REPO_NAME="libretro/flycast"

inherit libretro-core flag-o-matic

DESCRIPTION="libretro implementation of Reicast. (Sega Dreamcast )"
HOMEPAGE="https://github.com/libretro/reicast-emulator"
KEYWORDS=""

LICENSE="GPL-2"
SLOT="0"
IUSE="debug vulkan oit"
#opengl

DEPEND=""
RDEPEND="${DEPEND}
		games-emulation/libretro-info
"

#PATCHES=( "${FILESDIR}"/optional-opengl.patch )

src_unpack() {
	# We need to add the different core names to the array
	# in order to let the eclass handle the install
	LIBRETRO_CORE_NAME=( "flycast" )
	libretro-core_src_unpack
}

src_prepare() {
	libretro-core_src_prepare
	#fixing ARCH detection and CFLAGS
	use custom-cflags || strip-flags
	append-flags -fno-strict-aliasing

	sed -i Makefile \
		-e 's:$(ARCH):$(REAL_ARCH):' \
		-e 's:ARCH = $(shell uname -m):REAL_ARCH = $(shell uname -m):' \
		-e "/\t\tOPTFLAGS.*:= -O3/s:-O3:${CFLAGS}:" \
		-e "s:-funroll-loops::g" \
		|| die '"sed" failed'
}

src_compile() {
	local mychost=$(get_abi_CHOST)
	myemakeargs=(
		THREADED_RENDERING_DEFAULT=1
		WITH_GENERIC_JIT=0
		WITH_DYNAREC=${mychost%%-*}
		#$(usex opengl "HAVE_GL=1" "HAVE_GL=0")
		$(usex oit "HAVE_OIT=1" "HAVE_OIT=0")
		$(usex vulkan "HAVE_VULKAN=1" "HAVE_VULKAN=0")
		$(usex debug "DEBUG=1" "DEBUG=0")
	)
	libretro-core_src_compile
}
