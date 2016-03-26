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

%description
Vac-in-a-Box webserver files

%package -n viab-etc
Group: Applications/Internet
Summary: Vac-in-a-Box files for one ViaB version

%description -n viab-etc
For one version

%package -n viab-isolinux
Group: Applications/Internet
Summary: Vac-in-a-Box files for one ViaB version

%description -n viab-isolinux
For one version

%prep

%setup -n viab

%build

%install
make install

%files
/var/lib/viab/bin/*
/var/lib/viab/www/*
/var/lib/viab/VERSION
/etc/rc.d/init.d/*
/etc/cron.daily/*

%files -n viab-etc
/var/lib/viab/etc/*
/var/lib/viab/docs/*

%files -n viab-isolinux
/var/lib/viab/isolinux/*
