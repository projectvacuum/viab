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
Requires: vac,dhcp,tftp,tftp-server,syslinux-tftpboot,squid,ca-policy-lcg,xauth,tigervnc,ntp,yum-cron,apel-ssm,rpm-build,wget

%description
Configuration files and idempotent scripts for Vac-in-a-Box

%prep

%setup -n viab-conf

%build

%install
mkdir -p $RPM_BUILD_ROOT/usr/sbin \
         $RPM_BUILD_ROOT/etc/viab \
         $RPM_BUILD_ROOT/etc/vac.d \
         $RPM_BUILD_ROOT/etc/rc.d/init.d \
         $RPM_BUILD_ROOT/usr/lib/systemd/system \
         $RPM_BUILD_ROOT/root/.ssh \
         $RPM_BUILD_ROOT/etc/squid \
         $RPM_BUILD_ROOT/etc/yum.repos.d \
         $RPM_BUILD_ROOT/var/lib/vac/machinetypes

cp -p viab-conf-postinstall viab-conf-p12 lazyssh dnsmasq-wrapper \
 viab-heartbeat viab-conf-iptables viab-httpd $RPM_BUILD_ROOT/usr/sbin
cp viab-iptables.init $RPM_BUILD_ROOT/etc/rc.d/init.d/viab-iptables
cp vac.d/*.conf $RPM_BUILD_ROOT/etc/vac.d
cp viab/* $RPM_BUILD_ROOT/etc/viab
cp viab-httpd.service $RPM_BUILD_ROOT/usr/lib/systemd/system
cp squid.conf.template $RPM_BUILD_ROOT/etc/squid/squid.conf.template
cp -p authorized_keys $RPM_BUILD_ROOT/root/.ssh
cp -a machinetypes/* $RPM_BUILD_ROOT/var/lib/vac/machinetypes

%pre
rm -f /etc/vac.d/*

%posttrans
/usr/sbin/viab-conf-postinstall

%files
/etc/rc.d/init.d/*
/etc/vac.d/*
/etc/viab/*
/etc/squid/*
/var/lib/vac/machinetypes/*
/usr/sbin/*
/root/.ssh/authorized_keys
/usr/lib/systemd/system/*
