# ============================================================================
# Bootstrap a Scientific Gentoo Prefix
# ============================================================================
# see README.txt

default: system tools scientific

include init.mk
include helpers.mk
include system.mk
include tools.mk
include scientific.mk

