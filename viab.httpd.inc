#
#  Apache httpd.conf include file for Vac-in-a-Box (ViaB)
#
#  Andrew McNab, University of Manchester.
#  Copyright (c) 2013-5. All rights reserved.
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
#  Apache httpd.conf include file for Vac-in-a-Box (ViaB)
#
#  This file should be copied to /etc/httpd/includes/viab.httpd.inc
#  where it will be loaded by the common Vac Project httpd.conf
#
#  Place viab.cert.pem and viab.key.pem in /etc/grid-security
#  and install the CA files in /etc/grid-security/certificates
#
#  If necessary, you can do this with:
#
#  cat >/etc/yum.repos.d/eugridpma.repo <<EOF
#  [eugridpma]
#  name=EUGridPMA
#  baseurl=http://dist.eugridpma.info/distribution/igtf/current/
#  gpgcheck=1
#  gpgkey=https://dist.eugridpma.info/distribution/igtf/current/GPG-KEY-EUGridPMA-RPM-3
#  EOF
#  yum -y install ca_policy_eugridpma
#
#  Things to check if you get no successful requests:
#  - iptables is disabled or allows incoming TCP on ports 80 and 443
#  - SE linux is diabled (echo 0 >/selinux/enforce) or configured to allow
#    httpd to access the paths in this file

<VirtualHost *:80>
ServerName viab.gridpp.ac.uk
DocumentRoot /var/lib/viab/www
CustomLog "|/usr/sbin/rotatelogs /var/log/httpd/http--viab.gridpp.ac.uk-%Y%m%d 86400" combined
RedirectMatch ^/$ https://viab.gridpp.ac.uk/
Redirect /dashboard/ https://viab.gridpp.ac.uk/dashboard/
Redirect /iso/ https://viab.gridpp.ac.uk/iso/
Redirect /docs/ https://viab.gridpp.ac.uk/docs/
Redirect /repo/ https://viab.gridpp.ac.uk/repo/

AccessFileName .htaccess
</VirtualHost>

<VirtualHost viab.gridpp.ac.uk:443>
ServerName viab.gridpp.ac.uk
CustomLog "|/usr/sbin/rotatelogs /var/log/httpd/https-viab.gridpp.ac.uk-%Y%m%d 86400" combined
DocumentRoot /var/lib/viab/www

SSLEngine               on
SSLCertificateFile      /etc/grid-security/viab.cert.pem
SSLCertificateChainFile /etc/grid-security/viab.chain.pem
SSLCertificateKeyFile   /etc/grid-security/viab.key.pem
SSLCACertificatePath    /etc/grid-security/certificates
#SSLCARevocationPath    YOUR CRL DIRECTORY WOULD GO HERE
SSLVerifyClient         optional
SSLVerifyDepth          10
SSLOptions              +ExportCertData +StdEnvVars

AccessFileName .htaccess

<Directory /var/lib/viab/www>
AllowOverride AuthConfig
</Directory>

<Location /repo/>
ExpiresActive on
ExpiresDefault A0
</Location>

ScriptAliasMatch ^/dashboard/.* /var/lib/viab/bin/viab-cgi
ScriptAliasMatch ^/docs/.*      /var/lib/viab/bin/viab-cgi
ScriptAliasMatch ^/$            /var/lib/viab/bin/viab-cgi
</VirtualHost>
