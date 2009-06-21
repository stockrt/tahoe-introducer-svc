#
# Author: Rogério Carvalho Schneider <stockrt@gmail.com>
# URL:    http://stockrt.github.com
#

MODULE=$(shell basename $(PWD))
VERSION=$(shell sed -ne 's/^Version:[ \t]*\(.*\)/\1/p' $(MODULE).spec)
USER=$(shell id -un)
TOPDIR=$(HOME)/rpmbuild
#TOPDIR=/tmp/rpm/$(USER)
SOURCE_DIR=$(TOPDIR)/SOURCES

all: rpm

rpm:
	@echo "Preparing directories for the rpmbuild environment"
	#rpmdev-setuptree
	mkdir -p $(SOURCE_DIR)

	@echo "Preparing needed rpmmacros"
	if [ -f misc/rpmmacros ]; then \
		if [ -f $(HOME)/.rpmmacros ]; then \
			mv -f $(HOME)/.rpmmacros $(HOME)/.rpmmacros.bck.$(MODULE); \
		fi; \
		cat misc/rpmmacros > $(HOME)/.rpmmacros; \
	fi

	@echo "Generating package \"$(SOURCE_DIR)/$(MODULE)-$(VERSION).tar.gz\" \
from \"$(MODULE)\""
	tar cvzf $(SOURCE_DIR)/$(MODULE)-$(VERSION).tar.gz $(MODULE) \
	--exclude CVS \
	--exclude cvs \
	--exclude ".svn" \
	--exclude ".git" \
	--exclude ".bzr" \
	--exclude ".hg" \
	--exclude "_darcs"

	@echo "Generating RPM from package \"$(SOURCE_DIR)/$(MODULE)-$(VERSION).tar.gz\" \
using \"$(MODULE).spec\""
	rpmbuild -bb $(MODULE).spec

	@echo "Rolling back rpmmacros"
	if [ -f misc/rpmmacros ]; then \
		if [ -f $(HOME)/.rpmmacros.bck.$(MODULE) ]; then \
			mv -f $(HOME)/.rpmmacros.bck.$(MODULE) $(HOME)/.rpmmacros; \
		else \
			rm -f $(HOME)/.rpmmacros; \
		fi; \
	fi

clean:
	@echo "Cleaning"
	rpmbuild --clean $(MODULE).spec
