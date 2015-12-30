Name: viab-conf
Release: ##RPM_RELEASE##
Version: ##RPM_VERSION##
BuildArch: noarch
Summary: Vac-in-a-Box configuration
License: BSD
Group: System Environment
Source: viab-conf.tgz
URL: https://viab.gridpp.ac.uk/
Vendor: GridPP
Packager: Andrew McNab <Andrew.McNab@cern.ch>
Requires: viab-tftpboot,vac,dhcp,tftp,tftp-server,syslinux-tftpboot,squid,ca-policy-lcg,xauth,tigervnc,ntp,yum-autoupdate,apel-ssm,emi-release,epel-release

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
         $RPM_BUILD_ROOT/etc/squid \
         $RPM_BUILD_ROOT/etc/yum.repos.d \
         $RPM_BUILD_ROOT/var/lib/vac/machinetypes

cp -p viab-conf-postinstall viab-conf-p12 lazyssh dnsmasq-wrapper \
 viab-heartbeat $RPM_BUILD_ROOT/usr/sbin
cp vac.d/*.conf $RPM_BUILD_ROOT/etc/vac.d
cp viab/* $RPM_BUILD_ROOT/etc/viab
cp squid.conf.template $RPM_BUILD_ROOT/etc/squid/squid.conf.template
cp viab.repo $RPM_BUILD_ROOT/etc/yum.repos.d/viab.repo
cp -p authorized_keys $RPM_BUILD_ROOT/root/.ssh
cp -a machinetypes/* $RPM_BUILD_ROOT/var/lib/vac/machinetypes

%pre
rm -f /etc/vac.d/*

%post
# Temporary measure until Vac 0.20
rm -Rf /var/lib/vac/vmtypes
ln -sf /var/lib/vac/machinetypes /var/lib/vac/vmtypes

# Main postinstall functions
/usr/sbin/viab-conf-postinstall

%files
/etc/vac.d/*
/etc/viab/*
/etc/squid/*
/etc/yum.repos.d/*
/var/lib/vac/machinetypes/*
/usr/sbin/*
/root/.ssh/authorized_keys
