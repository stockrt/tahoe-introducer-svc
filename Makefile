MODULE=$(shell basename $(PWD))
VERSION=$(shell sed -ne 's/^Version:[ \t]*\(.*\)/\1/p' $(MODULE).spec)
USER=$(shell id -un)
TOPDIR=$(HOME)/rpmbuild
#TOPDIR=/tmp/rpm/$(USER)
SOURCE_DIR=$(TOPDIR)/SOURCE

all: rpm

rpm:
	@echo "Preparing directories for the rpmbuild environment"
	#rpmdev-setuptree
	mkdir -p $(SOURCE_DIR)

	@echo "Preparing needed rpmmacros"
	if [ -f $(HOME)/.rpmmacros ]; then mv -f $(HOME)/.rpmmacros $(HOME)/.rpmmacros.bck.$(MODULE); fi
	echo "%_topdir $(TOPDIR)" >> ~/.rpmmacros
	echo "%__arch_install_post /usr/lib/rpm/check-rpaths /usr/lib/rpm/check-buildroot" >> ~/.rpmmacros
	echo "%_unpackaged_files_terminate_build 0" >> ~/.rpmmacros

	@echo "Generating package \"$(SOURCE_DIR)/$(MODULE)-$(VERSION).tar.gz\" from \"$(MODULE)\""
	tar cvzf $(SOURCE_DIR)/$(MODULE)-$(VERSION).tar.gz $(MODULE) --exclude CVS --exclude ".#*"

	@echo "Generating RPM from package \"$(SOURCE_DIR)/$(MODULE)-$(VERSION).tar.gz\" using \"$(MODULE).spec\""
	rpmbuild -bb $(MODULE).spec

	@echo "Rolling back rpmmacros"
	if [ -f $(HOME)/.rpmmacros.bck.$(MODULE) ]; then mv -f $(HOME)/.rpmmacros.bck.$(MODULE) $(HOME)/.rpmmacros; else rm -f $(HOME)/.rpmmacros; fi

clean:
	@echo "Cleaning"
	rpmbuild --clean $(MODULE).spec
