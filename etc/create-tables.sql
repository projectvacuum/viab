
--
-- Table structure for table `hosts`
--

DROP TABLE IF EXISTS `hosts`;
CREATE TABLE `hosts` (
  `hostid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `spaceid` mediumint(8) unsigned NOT NULL,
  `hostname` varchar(255) NOT NULL,
  `ip` varchar(255) NOT NULL,
  `mac` varchar(255) NOT NULL,
  `siteid` mediumint(8) unsigned NOT NULL,
  `mb_per_machine` smallint(5) unsigned NOT NULL,
  `udp_timeout_seconds` float NOT NULL,
  `total_machines` tinyint(3) unsigned NOT NULL,
  `cpu_total` tinyint(3) unsigned NOT NULL,
  `cpu_per_machine` tinyint(3) unsigned NOT NULL,
  `hs06_per_cpu` float NOT NULL,
  `updated` datetime NOT NULL,
  PRIMARY KEY (`hostid`),
  UNIQUE KEY `siteid` (`siteid`,`hostname`),
  UNIQUE KEY `mac` (`mac`,`siteid`),
  UNIQUE KEY `ip` (`ip`,`siteid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `siteadmins`
--

DROP TABLE IF EXISTS `siteadmins`;
CREATE TABLE `siteadmins` (
  `siteid` mediumint(8) unsigned NOT NULL,
  `dn` varchar(255) NOT NULL,
  `added` datetime NOT NULL,
  UNIQUE KEY `siteid` (`siteid`,`dn`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
CREATE TABLE `sites` (
  `siteid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `sitename` varchar(255) NOT NULL,
  PRIMARY KEY (`siteid`),
  UNIQUE KEY `sitename` (`sitename`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `spaces`
--

DROP TABLE IF EXISTS `spaces`;
CREATE TABLE `spaces` (
  `spaceid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `siteid` mediumint(8) unsigned NOT NULL,
  `spacename` varchar(255) NOT NULL,
  `published` datetime NOT NULL,
  `publishlog` text NOT NULL,
  PRIMARY KEY (`spaceid`),
  UNIQUE KEY `spacename` (`spacename`,`siteid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `sshkeys`
--

DROP TABLE IF EXISTS `sshkeys`;
CREATE TABLE `sshkeys` (
  `keyid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `siteid` mediumint(8) unsigned NOT NULL,
  `keyvalue` text NOT NULL,
  `comment` text NOT NULL,
  `added` datetime NOT NULL,
  PRIMARY KEY (`keyid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `subnets`
--

DROP TABLE IF EXISTS `subnets`;
CREATE TABLE `subnets` (
  `subnetid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `spaceid` mediumint(8) unsigned NOT NULL,
  `subnet` varchar(255) NOT NULL,
  `netmask` varchar(255) NOT NULL,
  `router` varchar(255) NOT NULL,
  `nameservers` varchar(255) NOT NULL,
  PRIMARY KEY (`subnetid`),
  UNIQUE KEY `spaceid` (`spaceid`,`subnet`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `vmtypeopts`
--

DROP TABLE IF EXISTS `vmtypeopts`;
CREATE TABLE `vmtypeopts` (
  `vmtypeoptid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `vmtypeid` mediumint(8) unsigned NOT NULL,
  `optname` varchar(255) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`vmtypeoptid`),
  UNIQUE KEY `vmtypeid` (`vmtypeid`,`optname`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Table structure for table `vmtypes`
--

DROP TABLE IF EXISTS `vmtypes`;
CREATE TABLE `vmtypes` (
  `vmtypeid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `spaceid` mediumint(8) unsigned NOT NULL,
  `vmtypename` varchar(255) NOT NULL,
  `p12` blob NOT NULL,
  `p12updated` datetime NOT NULL,
  PRIMARY KEY (`vmtypeid`),
  UNIQUE KEY `spaceid` (`spaceid`,`vmtypename`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


