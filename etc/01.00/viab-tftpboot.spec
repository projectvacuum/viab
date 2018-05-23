Name: viab-tftpboot
Version: 01
Release: 1
BuildArch: noarch
Summary: Vac-in-a-Box tftpboot files
License: GPL
Group: System Environment
Source: viab-tftpboot.tgz
URL: https://viab.gridpp.ac.uk/
Vendor: GridPP
Packager: Andrew McNab <Andrew.McNab@cern.ch>

%description
Vac-in-a-Box tftpboot files

%prep

%setup -n viab-tftpboot

%build

%install
mkdir -p $RPM_BUILD_ROOT/var/lib/tftpboot

cp vmlinuz initrd.img $RPM_BUILD_ROOT/var/lib/tftpboot

%files
/var/lib/tftpboot/*
