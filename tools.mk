include init.mk

# ============================================================================
# == install_tools
# ============================================================================

default: install_tools

# ----------------------------------------------------------------------------
install_tools: eix local-overlay layman \
	ruby vim tmux
	# -- keychain:
	emerge -uDN keychain
	# -- portage-utils: eix
	emerge -uDN app-portage/portage-utils
	emerge -uDN app-portage/gentoolkit
	emerge -uDN app-portage/gentoolkit-dev
	emerge -uDN autounmask
	# -- zsh
	emerge -uDN zsh
	# -- tmux
	emerge -uDN tmux
	# -- htop
	emerge -uDN zsh
	# -- htop
	emerge -uDN ncdu

eix:
	emerge -uDN eix
	eix-update
ifeq ($(shell test -f ${EPREFIX}/etc/eix-sync.conf && grep "^-e" ${EPREFIX}/etc/eix-sync.conf), )
	echo -e '\055e' >> ${EPREFIX}/etc/eix-sync.conf
endif
	eix-sync

local-overlay: eix
	mkdir -p ${EPREFIX}/usr/local/portage/profiles
	# XXX: One could use a ifeq here
	#echo "PORTDIR_OVERLAY=\"\$${PORTDIR_OVERLAY} ${EPREFIX}/usr/local/portage/\"" >> ${EPREFIX}/etc/make.conf
	echo "PORTDIR_OVERLAY=\"${EPREFIX}/usr/local/portage/\"" >> ${EPREFIX}/etc/make.conf
	echo "local_overlay" > ${EPREFIX}/usr/local/portage/profiles/repo_name
	eix-sync

layman: eix
	emerge -uDN layman
	layman -S
	-layman -a sekyfsr
	# XXX: One could use a ifeq here
	echo "source ${EPREFIX}/var/lib/layman/make.conf" >> ${EPREFIX}/etc/make.conf
	eix-sync

vim: eix ruby
	echo "app-editors/vim bash-completion vim-pager python ruby perl" >> ${EPREFIX}/etc/portage/package.use/vim
	# tinfo/ncurses workaround
	mkdir -p ${EPREFIX}/etc/portage/env/app-editors
	echo "export LDFLAGS=-lncurses" >> ${EPREFIX}/etc/portage/env/app-editors/vim
	emerge -uDN vim vim-core
	-eselect bashcomp enable --global vim

ruby: eix
	echo 'dev-lang/ruby -ssl' >> ${EPREFIX}/etc/portage/package.use/ruby
	emerge -uDN ruby

tmux: eix
	# tinfo/ncurses workaround
	mkdir -p ${EPREFIX}/etc/portage/env/app-misc
	echo "export LDFLAGS=-L${EPREFIX}/usr/lib" >> ${EPREFIX}/etc/portage/env/app-misc/tmux
	emerge -uDN tmux