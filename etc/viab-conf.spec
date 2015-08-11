Name: viab-conf
Version: %( date +'%%Y%%m%%d%%H%%M%%S' )
Release: 1
BuildArch: noarch
Summary: Vac-in-a-Box configuration
License: BSD
Group: System Environment
Source: viab-conf.tgz
URL: http://www.gridpp.ac.uk/vac/
Vendor: GridPP
Packager: Andrew McNab <Andrew.McNab@cern.ch>
Requires: vac,dhcp,tftp,tftp-server,syslinux-tftpboot,squid,ca-policy-lcg,xauth,tigervnc,ntp,yum-autoupdate

%description
Configuration files and idempotent scripts for Vac-in-a-Box

%prep

%setup -n viab-conf

%build

%install
mkdir -p $RPM_BUILD_ROOT/usr/sbin \
         $RPM_BUILD_ROOT/etc/viab \
         $RPM_BUILD_ROOT/etc/vac.d \
         $RPM_BUILD_ROOT/root/.ssh \
         $RPM_BUILD_ROOT/etc/squid \
         $RPM_BUILD_ROOT/var/lib/tftpboot \
         $RPM_BUILD_ROOT/var/lib/vac/vmtypes

cp -p viab-conf-postinstall viab-conf-p12 lazyssh dnsmasq-wrapper \
 $RPM_BUILD_ROOT/usr/sbin
cp vac.d/*.conf $RPM_BUILD_ROOT/etc/vac.d
cp viab/* $RPM_BUILD_ROOT/etc/viab
cp squid.conf.template $RPM_BUILD_ROOT/etc/squid/squid.conf.template
cp vmlinuz initrd.img $RPM_BUILD_ROOT/var/lib/tftpboot
cp -a vmtypes/* $RPM_BUILD_ROOT/var/lib/vac/vmtypes
cp -p authorized_keys $RPM_BUILD_ROOT/root/.ssh

%post
/usr/sbin/viab-conf-postinstall

%files
/etc/vac.d/*
/etc/viab/*
/etc/squid/*
/var/lib/vac/vmtypes/*
/var/lib/tftpboot/*
/usr/sbin/viab-conf-postinstall
/usr/sbin/viab-conf-p12
/usr/sbin/dnsmasq-wrapper
/usr/sbin/lazyssh
/root/.ssh/authorized_keys
