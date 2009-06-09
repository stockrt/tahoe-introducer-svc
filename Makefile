MODULE=$(shell basename $(PWD))
VERSION=$(shell sed -ne 's/^Version:[ \t]*\(.*\)/\1/p' $(MODULE).spec)
USER=$(shell id -un)
SOURCE_DIR=${HOME}/rpmbuild/SOURCES
#SOURCE_DIR=/tmp/rpm/$(USER)/SOURCES

all: rpm

rpm:
	@echo "Preparing directories for the rpmbuild environment"
	#rpmdev-setuptree
	mkdir -p ${SOURCE_DIR}
	@echo "Generating package \"$(SOURCE_DIR)/$(MODULE)-$(VERSION).tar.gz\" from \"$(MODULE)\""
	tar cvzf $(SOURCE_DIR)/$(MODULE)-$(VERSION).tar.gz $(MODULE) --exclude CVS --exclude '.#*'
	@echo "Generating RPM from package \"$(SOURCE_DIR)/$(MODULE)-$(VERSION).tar.gz\" using \"$(MODULE).spec\""
	rpmbuild -bb $(MODULE).spec

clean:
	@echo "Cleaning"
	rpmbuild --clean $(MODULE).spec
