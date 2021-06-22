# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit toolchain-funcs systemd

DESCRIPTION="Kernel Samepage Merging (KSM) initscripts and ksmtuned daemon from Debian"
HOMEPAGE="https://github.com/Anthony25/ksmtuned"

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI=https://github.com/Anthony25/ksmtuned.git
	SRC_URI=
	KEYWORDS=
else
	SRC_URI=https://github.com/Anthony25/ksmtuned/archive/debian/"${PV}"
	KEYWORDS="x86 amd64"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	einfo Gentooizing ...
	#sed -i -e 's:sysconfig:conf.d:g' $(find -name '*.service')
	sed -i \
		-e ':sysconfig:d' \
		ksmtuned.service
	sed -i \
		-e 's/\/usr\/sbin\//\/lib\/systemd\//' \
		ksm.service

	einfo Building ksmctl ...
	$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} ksmctl.c -o ksmctl || die failed to build ksmctl!
}

src_install() {
	# Install ksm init script and conf.d file
	#newinitd ksm.init ksm
	#newconfd ksm.sysconfig ksm
	systemd_dounit ksm.service || die
	systemd_dounit ksmtuned.service || die
	# Install ksmtuned daemon, config file, and initscript
	dosbin ksmtuned
	insinto /etc
	doins ksmtuned.conf
	exeinto /lib/systemd
	doexe ksmctl
	#newinitd ksmtuned.init ksmtuned
}
