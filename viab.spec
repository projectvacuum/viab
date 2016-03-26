Name: viab
Version: %(echo ${VIAB_VERSION:-0.0})
Release: 1
BuildArch: noarch
Summary: Vac-in-a-Box
License: BSD
Group: System Environment/Daemons
Source: viab.tgz
URL: https://viab.gridpp.ac.uk/
Vendor: GridPP
Packager: Andrew McNab <Andrew.McNab@cern.ch>
Requires: MySQL-python,mysql-server

%description
Vac-in-a-Box webserver files

%package -n viab-etc-%(echo ${VIAB_VERSION:-0.0})
Group: Applications/Internet
Summary: Vac-in-a-Box files for one ViaB version

%description -n viab-etc-%(echo ${VIAB_VERSION:-0.0})
For one version

%package -n viab-isolinux-%(echo ${MAJOR_VERSION:-0.0})
Group: Applications/Internet
Summary: Vac-in-a-Box files for one ViaB version

%description -n viab-isolinux-%(echo ${MAJOR_VERSION:-0.0})
For one version

%prep

%setup -n viab

%build

%install
make install

%files
/var/lib/viab/bin/*
/var/lib/viab/www/*.html
/var/lib/viab/www/*.png
/var/lib/viab/www/*.gif
/var/lib/viab/www/iso/*
/var/lib/viab/www/ks/*
/var/lib/viab/www/repo/*
/var/lib/viab/VERSION
/etc/rc.d/init.d/*
/etc/cron.daily/*
/etc/httpd/includes/*

%files -n viab-etc-%(echo ${VIAB_VERSION:-0.0})
/var/lib/viab/etc/*
/var/lib/viab/www/docs/*

%files -n viab-isolinux-%(echo ${MAJOR_VERSION:-0.0})
/var/lib/viab/isolinux/*
