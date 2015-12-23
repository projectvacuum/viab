#!/bin/sh
#
#  viab-publish - Vac-in-a-Box RPM and ISO publisher
#
#  Andrew McNab, University of Manchester.
#  Copyright (c) 2015. All rights reserved.
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
#  Contacts: Andrew.McNab@cern.ch  https://www.gridpp.ac.uk/vac/
#

echo -n '#### Starting viab-publish ' ; date

export DOCUMENT_ROOT=/var/lib/viab/www

# Get values given by viab-cgi

export TEMPDIR="$1"
cd $TEMPDIR
# VIAB_VERSION here and on factory is PROD_VERSION in viab-cgi!
export VIAB_VERSION="$2"
export MAJOR_VERSION=`echo $VIAB_VERSION | cut -f1 -d.`
export VIAB_SITENAME="$3"
export VIAB_SPACENAME="$4"

/var/lib/viab/etc/$VIAB_VERSION/viab-publish.py

#export VIAB_VERSION=`cat viab-conf/viab/version`
#export MAJOR_VERSION=`echo $VIAB_VERSION | cut -f1 -d.`
#export VIAB_SITENAME=`cat viab-conf/viab/sitename`
#export VIAB_SPACENAME=`cat viab-conf/viab/spacename`
export VIAB_PASSWORD_HASH='sjsdkfjskdFJKSDJFKSAJDKFJ293JF2N3F23NI28394239FJ239FH2'

# Ensure web directories exist

mkdir -p $DOCUMENT_ROOT/repo/$VIAB_SITENAME/$VIAB_SPACENAME/$MAJOR_VERSION  \
         $DOCUMENT_ROOT/ks/$VIAB_SITENAME/$VIAB_SPACENAME \
         $DOCUMENT_ROOT/iso/$VIAB_SITENAME/$VIAB_SPACENAME

# Update HTTPS access control
echo -n '#### Make access control ' ; date

(
echo 'SSLRequire \'

cat $TEMPDIR/viab-conf/viab/factories-network | (
  while read mac host ip
  do
    echo " %{REMOTE_ADDR} == \"$ip\" or \\"
  done
)

cat $TEMPDIR/viab-conf/viab/admins-list | (
  while read dn
  do
    echo " %{SSL_CLIENT_S_DN} == \"$dn\" or \\"
  done
)

echo ' 1==2'
) > $DOCUMENT_ROOT/repo/$VIAB_SITENAME/.https.htaccess

cp -f $DOCUMENT_ROOT/repo/$VIAB_SITENAME/.https.htaccess \
      $DOCUMENT_ROOT/ks/$VIAB_SITENAME/.https.htaccess


# Update HTTP access control
cat $TEMPDIR/viab-conf/viab/factories-network | (

  iplist=''
  while read mac host ip
  do
    iplist="$iplist $ip"
  done
  
  echo 'Order Deny,Allow'
  echo 'Deny from all'
  echo "Allow from $iplist"

) > $DOCUMENT_ROOT/repo/$VIAB_SITENAME/.http.htaccess

cp -f $DOCUMENT_ROOT/repo/$VIAB_SITENAME/.http.htaccess \
      $DOCUMENT_ROOT/ks/$VIAB_SITENAME/.http.htaccess
      

# Make RPM in $TEMPDIR
echo -n '#### Make RPMs and repo ' ; date

mkdir -p SOURCES SPECS BUILD RPMS/noarch BUILDROOT
cp -p /var/lib/viab/etc/$VIAB_VERSION/viab-conf-postinstall \
      /var/lib/viab/etc/$VIAB_VERSION/viab-conf-p12 \
      /var/lib/viab/etc/$VIAB_VERSION/lazyssh \
      /var/lib/viab/etc/$VIAB_VERSION/dnsmasq-wrapper \
      /var/lib/viab/etc/$VIAB_VERSION/squid.conf.template \
      /var/lib/viab/etc/$VIAB_VERSION/vac-ssmsend-cron \
      viab-conf
cp /var/lib/viab/isolinux/vmlinuz /var/lib/viab/isolinux/initrd.img viab-conf
tar zcvf SOURCES/viab-conf.tgz --owner=root --group=root --exclude-backups viab-conf
cp /var/lib/viab/etc/$VIAB_VERSION/viab-conf.spec .
rpmbuild -ba --define "_topdir $TEMPDIR" --buildroot $TEMPDIR/BUILDROOT viab-conf.spec

cp RPMS/noarch/viab-conf-*-*.noarch.rpm $DOCUMENT_ROOT/repo/$VIAB_SITENAME/$VIAB_SPACENAME/$MAJOR_VERSION
find $DOCUMENT_ROOT/repo/$VIAB_SITENAME/$VIAB_SPACENAME/$MAJOR_VERSION -name '*.rpm' -ctime +1 -exec rm -f {} \;
createrepo $DOCUMENT_ROOT/repo/$VIAB_SITENAME/$VIAB_SPACENAME/$MAJOR_VERSION

# Make proxy-less ks-usb.cfg for USB-based installation
echo -n '#### Make ks-*.cfg ' ; date

sed -e "s/##VIAB_SITENAME##/$VIAB_SITENAME/g"		\
    -e "s/##VIAB_SPACENAME##/$VIAB_SPACENAME/g"		\
    -e "s/##VIAB_VERSION##/$VIAB_VERSION/g"     	\
    -e "s/##VIAB_PASSWORD_HASH##/$VIAB_PASSWORD_HASH/g"	\
    /var/lib/viab/etc/$VIAB_VERSION/ks.cfg       	  	\
    > $DOCUMENT_ROOT/ks/$VIAB_SITENAME/$VIAB_SPACENAME/ks-usb.cfg

cat $TEMPDIR/viab-conf/viab/factories-network | (

while read mac host ip
do
  sed -e "s/##VIAB_SITENAME##/$VIAB_SITENAME/g"			\
      -e "s/##VIAB_SPACENAME##/$VIAB_SPACENAME/g"		\
      -e "s/##VIAB_VERSION##/$VIAB_VERSION/g"     		\
      -e "s/##VIAB_PASSWORD_HASH##/$VIAB_PASSWORD_HASH/g"	\
      -e "s/^url.*/& --proxy=http:\/\/$ip:3128\//"		\
      /var/lib/viab/etc/$VIAB_VERSION/ks.cfg         				\
      > $DOCUMENT_ROOT/ks/$VIAB_SITENAME/$VIAB_SPACENAME/ks-$host.cfg
done

)

if [ "$1" = "" ] ; then
 # Only delete directories if we created them
 rm -Rf $TEMPDIR
fi

# Make viab-usb.iso for USB-based installation
echo -n '#### Make viab-usb.iso ' ; date

ISOTEMPDIR=`mktemp -d`

cp /var/lib/viab/isolinux/* $ISOTEMPDIR
cp /var/lib/viab/etc/$VIAB_VERSION/splash.jpg \
   /var/lib/viab/etc/$VIAB_VERSION/isolinux.cfg $ISOTEMPDIR
sed -i "s/##VIAB_SITENAME##/$VIAB_SITENAME/g" $ISOTEMPDIR/isolinux.cfg
sed -i "s/##VIAB_SPACENAME##/$VIAB_SPACENAME/g" $ISOTEMPDIR/isolinux.cfg

/usr/bin/genisoimage \
 -o $DOCUMENT_ROOT/iso/$VIAB_SITENAME/$VIAB_SPACENAME/viab-usb.iso \
 -b isolinux.bin \
 -c boot.cat \
 -no-emul-boot \
 -boot-load-size 4 \
 -boot-info-table \
 -input-charset default \
 -V 'Vac-in-a-Box' \
 -volset 'Vac-in-a-Box' \
 -R -J -v -T $ISOTEMPDIR

/usr/bin/isohybrid $DOCUMENT_ROOT/iso/$VIAB_SITENAME/$VIAB_SPACENAME/viab-usb.iso

rm -Rf $ISOTEMPDIR/*
rmdir $ISOTEMPDIR

echo -n '#### End of viab-publish ' ; date

exit 0
