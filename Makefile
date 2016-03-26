#
#  Andrew McNab, University of Manchester.
#  Copyright (c) 2013-6. All rights reserved.
#
#  Redistribution and use in source and binary forms, with or
#  without modification, are permitted provided that the following
#  conditions are met:
#
#    o Redistributions of source code must retain the above
#      copyright notice, this list of conditions and the following
#      disclaimer. 
#    o Redistributions in binary form must reproduce the above
#      copyright notice, this list of conditions and the following
#      disclaimer in the documentation and/or other materials
#      provided with the distribution. 
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
#  CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
#  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
#  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
#  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
#  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
#  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
#  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
#  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
#  POSSIBILITY OF SUCH DAMAGE.
#
#  Contacts: Andrew.McNab@cern.ch  http://www.gridpp.ac.uk/vac/
#

include VERSION

MAJOR_VERSION=$(shell sed 's/^.*=\([0-9]*\).*/\1/' VERSION)

INSTALL_FILES=vac-version-logger vac-version-logger.init \
          viab-cgi viab-gocdb viab-gocdb-cron \
          VERSION viab-update-versions-etc \
          viab.httpd.conf viab.httpd.inc

WWW_FILES=www/block.gif www/footer.html www/header.html \
          www/index.html www/vaclogowhite.png
          
DOCS_FILES=docs/adding_machine_types.html docs/dns_and_dhcp.html \
           docs/overview.html docs/basic_site_configuration.html \
           docs/index.html docs/usb_and_pxe_installation.html
           
ETC_FILES=etc/dnsmasq-wrapper etc/isolinux.cfg etc/ks.cfg etc/lazyssh \
          etc/splash.jpg etc/squid.conf.template etc/VAC_MAJOR_MINOR \
          etc/viab-conf-p12 etc/viab-conf-postinstall etc/viab-conf.spec \
          etc/viab-heartbeat etc/viab-publish etc/viab-tftpboot.spec \
          etc/viab.repo

ISOLINUX_FILES=isolinux/vmlinuz isolinux/boot.cat isolinux/vesamenu.c32 \
          isolinux/isolinux.bin isolinux/memtest isolinux/boot.msg \
          isolinux/grub.conf isolinux/isolinux.cfg isolinux/initrd.img

BUILD_FILES=Makefile viab.spec

TGZ_FILES=$(INSTALL_FILES) $(WWW_FILES) $(DOCS_FILES) $(ETC_FILES) \
          $(ISOLINUX_FILES) $(BUILD_FILES)

GNUTAR ?= tar
viab.tgz: $(TGZ_FILES)
	mkdir -p TEMPDIR/viab/docs TEMPDIR/viab/www TEMPDIR/viab/etc TEMPDIR/viab/isolinux
	cp $(INSTALL_FILES) $(BUILD_FILES) TEMPDIR/viab
	cp $(WWW_FILES) TEMPDIR/viab/www
	cp $(DOCS_FILES) TEMPDIR/viab/docs
	cp $(ETC_FILES) TEMPDIR/viab/etc
	cp $(ISOLINUX_FILES) TEMPDIR/viab/isolinux
	cd TEMPDIR ; $(GNUTAR) zcvf ../viab.tgz --owner=root --group=root viab
	rm -R TEMPDIR

install: $(TGZ_FILES)
	mkdir -p $(RPM_BUILD_ROOT)/var/lib/viab/bin \
                 $(RPM_BUILD_ROOT)/var/lib/viab/isolinux/$(MAJOR_VERSION) \
                 $(RPM_BUILD_ROOT)/var/lib/viab/www/docs/$(VERSION) \
                 $(RPM_BUILD_ROOT)/var/lib/viab/www/docs/iso/ \
                 $(RPM_BUILD_ROOT)/var/lib/viab/www/docs/ks/ \
                 $(RPM_BUILD_ROOT)/var/lib/viab/www/docs/repo/ \
                 $(RPM_BUILD_ROOT)/var/lib/viab/etc/$(VERSION) \
		 $(RPM_BUILD_ROOT)/etc/cron.daily \
		 $(RPM_BUILD_ROOT)/etc/rc.d/init.d \
		 $(RPM_BUILD_ROOT)/etc/httpd/conf \
		 $(RPM_BUILD_ROOT)/etc/httpd/includes
	cp VERSION \
           $(RPM_BUILD_ROOT)/var/lib/viab
	cp vac-version-logger viab-cgi viab-gocdb viab-update-versions-etc \
           $(RPM_BUILD_ROOT)/var/lib/viab/bin
	cp viab.httpd.inc \
           $(RPM_BUILD_ROOT)/etc/httpd/includes
	cp viab-gocdb-cron \
	   $(RPM_BUILD_ROOT)/etc/cron.daily
	cp vac-version-logger.init \
	   $(RPM_BUILD_ROOT)/etc/rc.d/init.d/vac-version-logger
	cp $(WWW_FILES) \
	   $(RPM_BUILD_ROOT)/var/lib/viab/www
	cp $(DOCS_FILES) \
	   $(RPM_BUILD_ROOT)/var/lib/viab/www/docs/$(VERSION)
	cp $(ETC_FILES) \
	   $(RPM_BUILD_ROOT)/var/lib/viab/etc/$(VERSION)
	cp $(ISOLINUX_FILES) \
	   $(RPM_BUILD_ROOT)/var/lib/viab/isolinux/$(MAJOR_VERSION)

rpm: viab.tgz
	rm -Rf RPMTMP
	mkdir -p RPMTMP/SOURCES RPMTMP/SPECS RPMTMP/BUILD \
         RPMTMP/SRPMS RPMTMP/RPMS/noarch RPMTMP/BUILDROOT
	cp -f viab.tgz RPMTMP/SOURCES
	export VIAB_VERSION=$(VERSION) MAJOR_VERSION=$(MAJOR_VERSION); rpmbuild -ba \
	  --define "_topdir $(shell pwd)/RPMTMP" \
	  --buildroot $(shell pwd)/RPMTMP/BUILDROOT viab.spec
