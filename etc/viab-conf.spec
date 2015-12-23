Name: viab-conf
Release: ##RPM_RELEASE##
Version: ##RPM_VERSION##
BuildArch: noarch
Summary: Vac-in-a-Box configuration
License: BSD
Group: System Environment
Source: viab-conf.tgz
URL: http://viab.gridpp.ac.uk/
Vendor: GridPP
Packager: Andrew McNab <Andrew.McNab@cern.ch>
Requires: vac,dhcp,tftp,tftp-server,syslinux-tftpboot,squid,ca-policy-lcg,xauth,tigervnc,ntp,yum-autoupdate,apel-ssm,emi-release,epel-release

%description
Configuration files and idempotent scripts for Vac-in-a-Box

%prep

%setup -n viab-conf

%build

%install
mkdir -p $RPM_BUILD_ROOT/usr/sbin \
         $RPM_BUILD_ROOT/etc/viab \
         $RPM_BUILD_ROOT/etc/vac.d \
         $RPM_BUILD_ROOT/etc/cron.d \
         $RPM_BUILD_ROOT/root/.ssh \
         $RPM_BUILD_ROOT/etc/squid \
         $RPM_BUILD_ROOT/var/lib/tftpboot \
         $RPM_BUILD_ROOT/var/lib/vac/machinetypes

cp -p viab-conf-postinstall viab-conf-p12 lazyssh dnsmasq-wrapper \
 $RPM_BUILD_ROOT/usr/sbin
cp vac.d/*.conf $RPM_BUILD_ROOT/etc/vac.d
cp viab/* $RPM_BUILD_ROOT/etc/viab
cp vac-ssmsend-cron $RPM_BUILD_ROOT/etc/cron.d
cp squid.conf.template $RPM_BUILD_ROOT/etc/squid/squid.conf.template
cp vmlinuz initrd.img $RPM_BUILD_ROOT/var/lib/tftpboot
cp -p authorized_keys $RPM_BUILD_ROOT/root/.ssh
cp -a machinetypes/* $RPM_BUILD_ROOT/var/lib/vac/machinetypes

%pre
rm -f /etc/vac.d/*

%post
# Temporary measure until Vac 0.20
rm -Rf /var/lib/vac/vmtypes
ln -sf /var/lib/vac/machinetypes /var/lib/vac/vmtypes

/usr/sbin/viab-conf-postinstall

%files
/etc/vac.d/*
/etc/viab/*
/etc/cron.d/*
/etc/squid/*
/var/lib/vac/machinetypes/*
/var/lib/tftpboot/*
/usr/sbin/viab-conf-postinstall
/usr/sbin/viab-conf-p12
/usr/sbin/dnsmasq-wrapper
/usr/sbin/lazyssh
/root/.ssh/authorized_keys
