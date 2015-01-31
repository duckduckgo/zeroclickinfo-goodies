package DDG::Goodie::RouterPasswords;
# ABSTRACT: Return default passwords forvarious routers.

use DDG::Goodie;

primary_example_queries 'belkin f5d6130 default password';
secondary_example_queries 'alcatel office 4200';
description 'default router passwords';
name 'RouterPasswords';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/RouterPasswords.pm';
topics 'sysadmin';
category 'computing_tools';
attribution github => ['nospampleasemam', 'Dylan Lloyd'],
            web => ['http://dylansserver.com/', 'Dylan Lloyd'];

my %routers = (
    "2wire homeportal rev. sbc yahoo! dsl" => {
        "username" => "2Wire",
        "password" => "password"
    },
    "2wire all wifi routers" => {
        "username" => "(none)",
        "password" => "password"
    },
    "3com corebuilder rev. 7000/6000/3500/2500" => {
        "username" => "debug",
        "password" => "password"
    },
    "3com corebuilder rev. 7000/6000/3500/2500" => {
        "username" => "tech",
        "password" => "password"
    },
    "3com hiperarc rev. v4.1.x" => {
        "username" => "adm",
        "password" => "password"
    },
    "3com lanplex rev. 2500" => {
        "username" => "debug",
        "password" => "password"
    },
    "3com lanplex rev. 2500" => {
        "username" => "tech",
        "password" => "password"
    },
    "3com linkswitch rev. 2000/2700" => {
        "username" => "tech",
        "password" => "password"
    },
    "3com netbuilder" => {
        "username" => "",
        "password" => "password"
    },
    "3com netbuilder" => {
        "username" => "",
        "password" => "password"
    },
    "3com netbuilder" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com office connect isdn routers rev. 5x0" => {
        "username" => "n/a",
        "password" => "password"
    },
    "3com superstack ii switch rev. 2200" => {
        "username" => "debug",
        "password" => "password"
    },
    "3com superstack ii switch rev. 2700" => {
        "username" => "tech",
        "password" => "password"
    },
    "3com officeconnect 812 adsl" => {
        "username" => "adminttd",
        "password" => "password"
    },
    "3com wireless ap rev. any" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "tech",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com hiperarc rev. v4.1.x" => {
        "username" => "adm",
        "password" => "password"
    },
    "3com lanplex rev. 2500" => {
        "username" => "tech",
        "password" => "password"
    },
    "3com cellplex" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com superstack ii switch rev. 2700" => {
        "username" => "tech",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "root",
        "password" => "password"
    },
    "3com hiperact rev. v4.1.x" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "tech",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com superstack 3 rev. 4xxx" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com superstack 3 rev. 4xxx" => {
        "username" => "monitor",
        "password" => "password"
    },
    "3com superstack 3 rev. 4400-49xx" => {
        "username" => "manager",
        "password" => "password"
    },
    "3com netbuilder" => {
        "username" => "Root",
        "password" => "password"
    },
    "3com 3c16450" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com 3c16406" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com office connect isdn routers rev. 5x0" => {
        "username" => "n/a",
        "password" => "password"
    },
    "3com corebuilder rev. 7000/6000/3500/2500" => {
        "username" => "n/a",
        "password" => "password"
    },
    "3com corebuilder rev. 7000/6000/3500/2500" => {
        "username" => "n/a",
        "password" => "password"
    },
    "3com officeconnect adsl wireless 11g firewall router rev. 3crwdr100-72" => {
        "username" => "(none)",
        "password" => "password"
    },
    "3com internet firewall rev. 3c16770" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com shark fin rev. comcast-supplied" => {
        "username" => "User",
        "password" => "password"
    },
    "3com 812" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "operator",
        "password" => "password"
    },
    "3com 3com superstack 3 switch 3300xm" => {
        "username" => "security",
        "password" => "password"
    },
    "3com superstack ii rev. 1100/3300" => {
        "username" => "3comcso",
        "password" => "password"
    },
    "3com netbuilder" => {
        "username" => "(none)",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "tech",
        "password" => "password"
    },
    "3com super" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "root",
        "password" => "password"
    },
    "3com netbuilder" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "operator",
        "password" => "password"
    },
    "3com officeconnect 812 adsl rev. 01.50-01" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com cellplex" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com hiperact rev. v4.1.x" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com 3c16405" => {
        "username" => "n/a",
        "password" => "password"
    },
    "3com 3c16405" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "3com switch rev. 3300xm" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com ss iii switch rev. 4xxx (4900 - sure)" => {
        "username" => "recovery",
        "password" => "password"
    },
    "3com officeconnect wireless 11g cable/dsl gateway" => {
        "username" => "(none)",
        "password" => "password"
    },
    "3com 3c16405" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com officeconnect 812 adsl rev. 01.50-01" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com cellplex" => {
        "username" => "n/a",
        "password" => "password"
    },
    "3com cellplex" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com hiperact rev. v4.1.x" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com 3c16405" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "3com cellplex rev. 7000" => {
        "username" => "tech",
        "password" => "password"
    },
    "3com switch rev. 3300xm" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com ss iii switch rev. 4xxx (4900 - sure)" => {
        "username" => "recovery",
        "password" => "password"
    },
    "3com officeconnect wireless 11g cable/dsl gateway" => {
        "username" => "(none)",
        "password" => "password"
    },
    "3com 3cradsl72 rev. 1.2" => {
        "username" => "(none)",
        "password" => "password"
    },
    "3com cb9000 / 4007 rev. 3" => {
        "username" => "Type User: FORCE",
        "password" => "password"
    },
    "3com officeconnect" => {
        "username" => "n/a",
        "password" => "password"
    },
    "3com superstack ii netbuilder rev. 11.1" => {
        "username" => "n/a",
        "password" => "password"
    },
    "3com officeconnect" => {
        "username" => "admin",
        "password" => "password"
    },
    "3com office connect rev. 11g" => {
        "username" => "admin",
        "password" => "password"
    },
    "3m vol-0215 etc." => {
        "username" => "volition",
        "password" => "password"
    },
    "3ware 3dm" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "accelerated networks dsl cpe and dslam" => {
        "username" => "sysadm",
        "password" => "password"
    },
    "acconet router" => {
        "username" => "Admin",
        "password" => "password"
    },
    "accton wirelessrouter rev. t-online" => {
        "username" => "none",
        "password" => "password"
    },
    "accton t-online accton" => {
        "username" => "(none)",
        "password" => "password"
    },
    "accton t-online accton" => {
        "username" => "(none)",
        "password" => "password"
    },
    "aceex modem adsl router" => {
        "username" => "admin",
        "password" => "password"
    },
    "aceex modem adsl router" => {
        "username" => "admin",
        "password" => "password"
    },
    "actiontec ge344000-01" => {
        "username" => "(none)",
        "password" => "password"
    },
    "actiontec w1424wr" => {
        "username" => "admin",
        "password" => "password"
    },
    "actiontec r1520su" => {
        "username" => "admin",
        "password" => "password"
    },
    "actiontec gt704-wg" => {
        "username" => "admin",
        "password" => "password"
    },
    "adc kentrox pacesetter router" => {
        "username" => "n/a",
        "password" => "password"
    },
    "adic scalar 100/1000" => {
        "username" => "admin",
        "password" => "password"
    },
    "adic scalar i2000" => {
        "username" => "admin",
        "password" => "password"
    },
    "adtran mx2800" => {
        "username" => "n/a",
        "password" => "password"
    },
    "adtran smart 16/16e" => {
        "username" => "n/a",
        "password" => "password"
    },
    "adtran atlas 800/800plus/810plus/550" => {
        "username" => "n/a",
        "password" => "password"
    },
    "adtran smart 16/16e" => {
        "username" => "n/a",
        "password" => "password"
    },
    "adtran nxiq" => {
        "username" => "n/a",
        "password" => "password"
    },
    "adtran tsu iq/dsu iq" => {
        "username" => "n/a",
        "password" => "password"
    },
    "adtran express 5110/5200/5210" => {
        "username" => "n/a",
        "password" => "password"
    },
    "adtran agent card" => {
        "username" => "n/a",
        "password" => "password"
    },
    "adtran tsu router module/l128/l768/1.5" => {
        "username" => "n/a",
        "password" => "password"
    },
    "adtran t3su 300" => {
        "username" => "n/a",
        "password" => "password"
    },
    "advantek networks wireless lan 802.11 g/b" => {
        "username" => "admin",
        "password" => "password"
    },
    "aethra starbridge eu" => {
        "username" => "admin",
        "password" => "password"
    },
    "airties all" => {
        "username" => "(blank)",
        "password" => "password"
    },
    "alaxala ax7800r" => {
        "username" => "operator",
        "password" => "password"
    },
    "alcatel 4400" => {
        "username" => "mtcl",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "kermit",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "dhs3mt",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "at4400",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "mtch",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "mtcl",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "root",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "dhs3pms",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "adfexc",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "client",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "install",
        "password" => "password"
    },
    "alcatel pbx rev. 4400" => {
        "username" => "halt",
        "password" => "password"
    },
    "alcatel office 4200" => {
        "username" => "n/a",
        "password" => "password"
    },
    "alcatel omnistack 6024" => {
        "username" => "admin",
        "password" => "password"
    },
    "alcatel omnistack/omniswitch" => {
        "username" => "diag",
        "password" => "password"
    },
    "alcatel omnistack/omniswitch" => {
        "username" => "diag",
        "password" => "password"
    },
    "alcatel timestep vpn 1520 rev. 3.00.026" => {
        "username" => "root",
        "password" => "password"
    },
    "alcatel oxo rev. 1.3" => {
        "username" => "(none)",
        "password" => "password"
    },
    "alcatel omnipcx office rev. 4.1" => {
        "username" => "ftp_inst",
        "password" => "password"
    },
    "alcatel omnipcx office rev. 4.1" => {
        "username" => "ftp_admi",
        "password" => "password"
    },
    "alcatel omnipcx office rev. 4.1" => {
        "username" => "ftp_oper",
        "password" => "password"
    },
    "alcatel omnipcx office rev. 4.1" => {
        "username" => "ftp_nmc",
        "password" => "password"
    },
    "allied telesyn" => {
        "username" => "manager",
        "password" => "password"
    },
    "allied telesyn at-8024(gb)" => {
        "username" => "n/a",
        "password" => "password"
    },
    "allied telesyn at-8024(gb)" => {
        "username" => "manager",
        "password" => "password"
    },
    "allied telesyn at router" => {
        "username" => "root",
        "password" => "password"
    },
    "allied telesyn alat8326gb" => {
        "username" => "manager",
        "password" => "password"
    },
    "allied telesyn at8016f" => {
        "username" => "manager",
        "password" => "password"
    },
    "allied telesyn at-ar130 (u) -10" => {
        "username" => "Manager",
        "password" => "password"
    },
    "allnet t-dsl modem rev. software version: v1.51" => {
        "username" => "admin",
        "password" => "password"
    },
    "allnet all0275 802.11g ap rev. 1.0.6" => {
        "username" => "none",
        "password" => "password"
    },
    "alteon acedirector3" => {
        "username" => "admin",
        "password" => "password"
    },
    "alteon aceswitch rev. 180e" => {
        "username" => "admin",
        "password" => "password"
    },
    "alteon aceswitch rev. 180e" => {
        "username" => "admin",
        "password" => "password"
    },
    "alteon aceswitch rev. 180e" => {
        "username" => "admin",
        "password" => "password"
    },
    "alteon ad4 rev. 9" => {
        "username" => "admin",
        "password" => "password"
    },
    "ambit adsl" => {
        "username" => "root",
        "password" => "password"
    },
    "ambit cable modem 60678eu rev. 1.12" => {
        "username" => "root",
        "password" => "password"
    },
    "ambit cable modem" => {
        "username" => "root",
        "password" => "password"
    },
    "ambit ntl:home 200 rev. 2.67.1011" => {
        "username" => "root",
        "password" => "password"
    },
    "ambit u10c019" => {
        "username" => "user",
        "password" => "password"
    },
    "amitech wireless router and access point 802.11g 802.11b rev. any" => {
        "username" => "admin",
        "password" => "password"
    },
    "andover controls infinity rev. any" => {
        "username" => "acc",
        "password" => "password"
    },
    "aoc zenworks 4.0" => {
        "username" => "n/a",
        "password" => "password"
    },
    "apc 9606 smart slot" => {
        "username" => "n/a",
        "password" => "password"
    },
    "apc usv network management card" => {
        "username" => "n/a",
        "password" => "password"
    },
    "apc upses (web/snmp mgmt card)" => {
        "username" => "device",
        "password" => "password"
    },
    "apc smart ups" => {
        "username" => "apc",
        "password" => "password"
    },
    "apc smartups 3000" => {
        "username" => "apc",
        "password" => "password"
    },
    "apple airport base station (graphite) rev. 2" => {
        "username" => "(none)",
        "password" => "password"
    },
    "apple airport base station (dual ethernet) rev. 2" => {
        "username" => "n/a",
        "password" => "password"
    },
    "apple airport extreme base station rev. 2" => {
        "username" => "n/a",
        "password" => "password"
    },
    "apple airport5 rev. 1.0.09" => {
        "username" => "root",
        "password" => "password"
    },
    "apple iphone ios4.x rev. all" => {
        "username" => "root",
        "password" => "password"
    },
    "areca raid controllers" => {
        "username" => "admin",
        "password" => "password"
    },
    "arescom modem/router rev. 10xx" => {
        "username" => "n/a",
        "password" => "password"
    },
    "arescom router rev. any" => {
        "username" => "",
        "password" => "password"
    },
    "artem compoint - cpd-xt-b rev. cpd-xt-b" => {
        "username" => "(none)",
        "password" => "password"
    },
    "asante intraswitch" => {
        "username" => "IntraSwitch",
        "password" => "password"
    },
    "asante intrastack" => {
        "username" => "IntraStack",
        "password" => "password"
    },
    "asante fm2008" => {
        "username" => "superuser",
        "password" => "password"
    },
    "asante fm2008" => {
        "username" => "admin",
        "password" => "password"
    },
    "ascend yurie" => {
        "username" => "readonly",
        "password" => "password"
    },
    "ascend router" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ascend sahara" => {
        "username" => "root",
        "password" => "password"
    },
    "ascom ascotel pbx rev. all" => {
        "username" => "(none)",
        "password" => "password"
    },
    "asmack router rev. ar804u" => {
        "username" => "admin",
        "password" => "password"
    },
    "asmax ar701u / asmax ar6024" => {
        "username" => "admin",
        "password" => "password"
    },
    "asmax ar800c2" => {
        "username" => "admin",
        "password" => "password"
    },
    "asmax ar800c2" => {
        "username" => "admin",
        "password" => "password"
    },
    "asmax ar-804u" => {
        "username" => "admin",
        "password" => "password"
    },
    "aspect acd rev. 6" => {
        "username" => "customer",
        "password" => "password"
    },
    "aspect acd rev. 6" => {
        "username" => "DTA",
        "password" => "password"
    },
    "aspect acd rev. 7" => {
        "username" => "DTA",
        "password" => "password"
    },
    "aspect acd rev. 8" => {
        "username" => "DTA",
        "password" => "password"
    },
    "asus wl-500g rev. 1.7.5.6" => {
        "username" => "admin",
        "password" => "password"
    },
    "asus wl503g rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "asus wl500 rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "asus wl300 rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "asus wl500g deluxe" => {
        "username" => "admin",
        "password" => "password"
    },
    "asus p5p800" => {
        "username" => "n/a",
        "password" => "password"
    },
    "asus wl500g" => {
        "username" => "admin",
        "password" => "password"
    },
    "atlantis a02-ra141" => {
        "username" => "admin",
        "password" => "password"
    },
    "atlantis i-storm lan router adsl" => {
        "username" => "admin",
        "password" => "password"
    },
    "avaya g3r rev. v6" => {
        "username" => "root",
        "password" => "password"
    },
    "avaya cajun p33x rev. firmware before 3.11.0" => {
        "username" => "n/a",
        "password" => "password"
    },
    "avaya definity rev. g3si" => {
        "username" => "craft",
        "password" => "password"
    },
    "avaya cajun pxxx" => {
        "username" => "root",
        "password" => "password"
    },
    "avaya cajun rev. p550r p580 p880 and p882" => {
        "username" => "diag",
        "password" => "password"
    },
    "avaya cajun rev. p550r p580 p880 and p882" => {
        "username" => "manuf",
        "password" => "password"
    },
    "avaya pxxx rev. 5.2.14" => {
        "username" => "diag",
        "password" => "password"
    },
    "avaya pxxx rev. 5.2.14" => {
        "username" => "manuf",
        "password" => "password"
    },
    "avaya definity rev. up to rev. 6" => {
        "username" => "craft",
        "password" => "password"
    },
    "avaya cms supervisor rev. 11" => {
        "username" => "root",
        "password" => "password"
    },
    "avaya definity" => {
        "username" => "dadmin",
        "password" => "password"
    },
    "axis netcam rev. 200/240" => {
        "username" => "root",
        "password" => "password"
    },
    "axis all axis printserver rev. all" => {
        "username" => "root",
        "password" => "password"
    },
    "axis webcams" => {
        "username" => "root",
        "password" => "password"
    },
    "axis 540/542 print server" => {
        "username" => "root",
        "password" => "password"
    },
    "axis netcam rev. 200/240" => {
        "username" => "root",
        "password" => "password"
    },
    "axis 2100" => {
        "username" => "n/a",
        "password" => "password"
    },
    "axus axus yotta" => {
        "username" => "n/a",
        "password" => "password"
    },
    "aztech dsl-600e" => {
        "username" => "admin",
        "password" => "password"
    },
    "bausch datacom proxima pri adsl pstn router4 wireless" => {
        "username" => "admin",
        "password" => "password"
    },
    "bay networks switch rev. 350t" => {
        "username" => "n/a",
        "password" => "password"
    },
    "bay networks superstack ii" => {
        "username" => "security",
        "password" => "password"
    },
    "bay networks router" => {
        "username" => "User",
        "password" => "password"
    },
    "bay networks router" => {
        "username" => "Manager",
        "password" => "password"
    },
    "bay networks router" => {
        "username" => "User",
        "password" => "password"
    },
    "bay networks superstack ii" => {
        "username" => "security",
        "password" => "password"
    },
    "bay networks switch rev. 350t" => {
        "username" => "n/a",
        "password" => "password"
    },
    "bbr-4mg and bbr-4hg buffalo rev. all" => {
        "username" => "root",
        "password" => "password"
    },
    "belkin f5d6130" => {
        "username" => "(none)",
        "password" => "password"
    },
    "belkin f5d7150 rev. fb" => {
        "username" => "n/a",
        "password" => "password"
    },
    "belkin f5d8233-4" => {
        "username" => "(blank)",
        "password" => "password"
    },
    "belkin f5d7231" => {
        "username" => "admin",
        "password" => "password"
    },
    "benq awl 700 wireless router rev. 1.3.6 beta-002" => {
        "username" => "admin",
        "password" => "password"
    },
    "billion bipac 5100" => {
        "username" => "admin",
        "password" => "password"
    },
    "billion bipac-640 ac rev. 640ae100" => {
        "username" => "(none)",
        "password" => "password"
    },
    "bintec bianca/brick rev. xm-5.1" => {
        "username" => "n/a",
        "password" => "password"
    },
    "bintec x1200 rev. 37834" => {
        "username" => "admin",
        "password" => "password"
    },
    "bintec x2300i rev. 37834" => {
        "username" => "admin",
        "password" => "password"
    },
    "bintec x3200 rev. 37834" => {
        "username" => "admin",
        "password" => "password"
    },
    "bintec bianka routers" => {
        "username" => "admin",
        "password" => "password"
    },
    "blue coat systems proxysg rev. 3.x" => {
        "username" => "admin",
        "password" => "password"
    },
    "bmc patrol rev. 6" => {
        "username" => "patrol",
        "password" => "password"
    },
    "bmc software patrol rev. all" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "breezecom breezecom adapters rev. 3.x" => {
        "username" => "n/a",
        "password" => "password"
    },
    "breezecom breezecom adapters rev. 2.x" => {
        "username" => "n/a",
        "password" => "password"
    },
    "breezecom breezecom adapters rev. 4.4.x" => {
        "username" => "n/a",
        "password" => "password"
    },
    "breezecom breezecom adapters rev. 4.x" => {
        "username" => "n/a",
        "password" => "password"
    },
    "breezecom breezecom adapters rev. 3.x" => {
        "username" => "n/a",
        "password" => "password"
    },
    "breezecom breezecom adapters rev. 2.x" => {
        "username" => "n/a",
        "password" => "password"
    },
    "broadlogic xlt router" => {
        "username" => "webadmin",
        "password" => "password"
    },
    "broadlogic xlt router" => {
        "username" => "admin",
        "password" => "password"
    },
    "broadlogic xlt router" => {
        "username" => "installer",
        "password" => "password"
    },
    "brocade fabric os rev. all" => {
        "username" => "root",
        "password" => "password"
    },
    "brocade silkworm rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "brocade fabric os" => {
        "username" => "admin",
        "password" => "password"
    },
    "brother nc-3100h" => {
        "username" => "(none)",
        "password" => "password"
    },
    "brother nc-4100h" => {
        "username" => "(none)",
        "password" => "password"
    },
    "brother hl-1270n" => {
        "username" => "n/a",
        "password" => "password"
    },
    "buffalo wireless broadband base station-g rev. wla-g54 wbr-g54" => {
        "username" => "root",
        "password" => "password"
    },
    "cable and wireless adsl modem/router" => {
        "username" => "admin",
        "password" => "password"
    },
    "cabletron netgear modem/router and ssr" => {
        "username" => "netman",
        "password" => "password"
    },
    "canyon router" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "cayman cayman dsl" => {
        "username" => "n/a",
        "password" => "password"
    },
    "celerity mediator rev. multi" => {
        "username" => "mediator",
        "password" => "password"
    },
    "celerity mediator" => {
        "username" => "root",
        "password" => "password"
    },
    "cellit ccpro" => {
        "username" => "cellit",
        "password" => "password"
    },
    "checkpoint secureplatform rev. ng fp3" => {
        "username" => "admin",
        "password" => "password"
    },
    "ciphertrust ironmail rev. any" => {
        "username" => "admin",
        "password" => "password"
    },
    "cisco cache engine" => {
        "username" => "admin",
        "password" => "password"
    },
    "cisco configmaker" => {
        "username" => "cmaker",
        "password" => "password"
    },
    "cisco cnr rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "cisco netranger/secure ids" => {
        "username" => "netrangr",
        "password" => "password"
    },
    "cisco bbsm rev. 5.0 and 5.1" => {
        "username" => "bbsd-client",
        "password" => "password"
    },
    "cisco bbsd msde client rev. 5.0 and 5.1" => {
        "username" => "bbsd-client",
        "password" => "password"
    },
    "cisco bbsm administrator rev. 5.0 and 5.1" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "cisco netranger/secure ids rev. 3.0(5)s17" => {
        "username" => "root",
        "password" => "password"
    },
    "cisco bbsm msde administrator rev. 5.0 and 5.1" => {
        "username" => "sa",
        "password" => "password"
    },
    "cisco catalyst 4000/5000/6000 rev. all" => {
        "username" => "(none)",
        "password" => "password"
    },
    "cisco pix firewall" => {
        "username" => "(none)",
        "password" => "password"
    },
    "cisco vpn concentrator 3000 series rev. 3" => {
        "username" => "admin",
        "password" => "password"
    },
    "cisco content engine" => {
        "username" => "admin",
        "password" => "password"
    },
    "cisco ap1200 rev. ios" => {
        "username" => "Cisco",
        "password" => "password"
    },
    "cisco ciscoworks 2000" => {
        "username" => "guest",
        "password" => "password"
    },
    "cisco ciscoworks 2000" => {
        "username" => "admin",
        "password" => "password"
    },
    "cisco configmaker" => {
        "username" => "cmaker",
        "password" => "password"
    },
    "cisco ciso aironet 1100 series rev. rev. 01" => {
        "username" => "(none)",
        "password" => "password"
    },
    "cisco aironet" => {
        "username" => "(none)",
        "password" => "password"
    },
    "cisco aironet" => {
        "username" => "Cisco",
        "password" => "password"
    },
    "cisco hse" => {
        "username" => "root",
        "password" => "password"
    },
    "cisco hse" => {
        "username" => "hsa",
        "password" => "password"
    },
    "cisco wlse" => {
        "username" => "root",
        "password" => "password"
    },
    "cisco wlse" => {
        "username" => "wlse",
        "password" => "password"
    },
    "cisco aironet 1200" => {
        "username" => "root",
        "password" => "password"
    },
    "cisco cva 122" => {
        "username" => "admin",
        "password" => "password"
    },
    "cisco 3600" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "cisco 1" => {
        "username" => "admin",
        "password" => "password"
    },
    "cisco 2600" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "cisco cisco ata-186 (vonage)" => {
        "username" => "(blank)",
        "password" => "password"
    },
    "cisco 3700" => {
        "username" => "cisco",
        "password" => "password"
    },
    "cisco-arrowpoint arrowpoint" => {
        "username" => "admin",
        "password" => "password"
    },
    "cnet cnet 4port adsl modem rev. cnad nf400" => {
        "username" => "admin",
        "password" => "password"
    },
    "com3 ole" => {
        "username" => "admin",
        "password" => "password"
    },
    "compaq insight manager" => {
        "username" => "administrator",
        "password" => "password"
    },
    "compaq insight manager" => {
        "username" => "anonymous",
        "password" => "password"
    },
    "compaq insight manager" => {
        "username" => "user",
        "password" => "password"
    },
    "compaq insight manager" => {
        "username" => "operator",
        "password" => "password"
    },
    "compaq insight manager" => {
        "username" => "user",
        "password" => "password"
    },
    "compaq insight manager" => {
        "username" => "PFCUser",
        "password" => "password"
    },
    "comtrend ct536+" => {
        "username" => "admin",
        "password" => "password"
    },
    "comtrend ct-536+" => {
        "username" => "admin",
        "password" => "password"
    },
    "conexant router" => {
        "username" => "n/a",
        "password" => "password"
    },
    "conexant router" => {
        "username" => "n/a",
        "password" => "password"
    },
    "conexant access runner adsl console port 3.27" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "corecess corecess 3112" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "corecess 6808 apc" => {
        "username" => "corecess",
        "password" => "password"
    },
    "corecess 3113" => {
        "username" => "admin",
        "password" => "password"
    },
    "creative 2015u" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ctc union atu-r130 rev. 81001a" => {
        "username" => "root",
        "password" => "password"
    },
    "cyberguard all firewalls rev. all" => {
        "username" => "cgadmin",
        "password" => "password"
    },
    "cyclades pr 1000" => {
        "username" => "super",
        "password" => "password"
    },
    "cyclades ts800" => {
        "username" => "root",
        "password" => "password"
    },
    "d-link dsl-g664t rev. a1" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link hubs/switches" => {
        "username" => "D-Link",
        "password" => "password"
    },
    "d-link di-704 rev. rev a" => {
        "username" => "(none)",
        "password" => "password"
    },
    "d-link di-804 rev. v2.03" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dwl 900ap" => {
        "username" => "(none)",
        "password" => "password"
    },
    "d-link di-614+" => {
        "username" => "user",
        "password" => "password"
    },
    "d-link dwl-614+ rev. rev a rev b" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link d-704p rev. rev b" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-604 rev. rev a rev b rev c rev e" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dwl-614+ rev. 2.03" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link d-704p" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dwl-900+" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-704" => {
        "username" => "n/a",
        "password" => "password"
    },
    "d-link di-604 rev. 1.62b+" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-624 rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-624 rev. all" => {
        "username" => "User",
        "password" => "password"
    },
    "d-link di-604 rev. 2.02" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dwl 1000" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-514" => {
        "username" => "user",
        "password" => "password"
    },
    "d-link di-614+ rev. any" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dwl 2100ap" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dsl-302g" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-624+ rev. a3" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dwl-2000ap+ rev. 1.13" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-614+" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dsl-300g+ rev. teo" => {
        "username" => "(none)",
        "password" => "password"
    },
    "d-link dsl-300g+ rev. teo" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-524 rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link firewall rev. dfl-200" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-524 rev. all" => {
        "username" => "user",
        "password" => "password"
    },
    "d-link dwl-900ap+ rev. rev a rev b rev c" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dsl500g" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dsl-504t" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link dsl-g604t" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-707p router" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di624 rev. c3" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link 604" => {
        "username" => "n/a",
        "password" => "password"
    },
    "d-link dsl-500" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link 504g adsl router" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link di-524" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link adsl" => {
        "username" => "admin",
        "password" => "password"
    },
    "d-link vwr (vonage) rev. wireless broadband router" => {
        "username" => "user",
        "password" => "password"
    },
    "d-link dgl4300 rev. d-link's dgl-4300 game series router" => {
        "username" => "Admin",
        "password" => "password"
    },
    "d-link vta (vonage)" => {
        "username" => "user",
        "password" => "password"
    },
    "dallas semiconductors tini embedded java module rev. <= 1.0" => {
        "username" => "root",
        "password" => "password"
    },
    "datacom bsasx/101" => {
        "username" => "n/a",
        "password" => "password"
    },
    "datawizard.net ftpxq server" => {
        "username" => "anonymous",
        "password" => "password"
    },
    "davox unison" => {
        "username" => "root",
        "password" => "password"
    },
    "davox unison" => {
        "username" => "admin",
        "password" => "password"
    },
    "davox unison" => {
        "username" => "davox",
        "password" => "password"
    },
    "davox unison" => {
        "username" => "sa",
        "password" => "password"
    },
    "dd-wrt dd-wrt v23 sp2 (09/15/06)" => {
        "username" => "root",
        "password" => "password"
    },
    "deerfield mdaemon" => {
        "username" => "MDaemon",
        "password" => "password"
    },
    "dell laser printer 3000cn / 3100cn" => {
        "username" => "admin",
        "password" => "password"
    },
    "dell remote access card" => {
        "username" => "root",
        "password" => "password"
    },
    "demarc network monitor" => {
        "username" => "admin",
        "password" => "password"
    },
    "deutsch telekomm t-sinus 130 dsl" => {
        "username" => "(none)",
        "password" => "password"
    },
    "deutsche telekom t-sinus dsl 130" => {
        "username" => "admin",
        "password" => "password"
    },
    "deutsche telekom t-sinus 154 dsl rev. 13.9.38" => {
        "username" => "(none)",
        "password" => "password"
    },
    "deutsche telekom speedport w701" => {
        "username" => "",
        "password" => "password"
    },
    "develcon orbitor default console" => {
        "username" => "n/a",
        "password" => "password"
    },
    "develcon orbitor default console" => {
        "username" => "n/a",
        "password" => "password"
    },
    "dictaphone prolog" => {
        "username" => "PBX",
        "password" => "password"
    },
    "dictaphone prolog" => {
        "username" => "NETWORK",
        "password" => "password"
    },
    "dictaphone prolog" => {
        "username" => "NETOP",
        "password" => "password"
    },
    "digicom michelangelo" => {
        "username" => "admin",
        "password" => "password"
    },
    "digicom michelangelo" => {
        "username" => "user",
        "password" => "password"
    },
    "digicorp viper" => {
        "username" => "n/a",
        "password" => "password"
    },
    "digicorp viper" => {
        "username" => "n/a",
        "password" => "password"
    },
    "digicorp router" => {
        "username" => "n/a",
        "password" => "password"
    },
    "digicorp router" => {
        "username" => "n/a",
        "password" => "password"
    },
    "draytek vigor rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "draytek vigor 2600" => {
        "username" => "admin",
        "password" => "password"
    },
    "draytek vigor 2900+" => {
        "username" => "admin",
        "password" => "password"
    },
    "draytek 2800" => {
        "username" => "(blank)",
        "password" => "password"
    },
    "draytek vigor 3300" => {
        "username" => "draytek",
        "password" => "password"
    },
    "dynalink rta230" => {
        "username" => "admin",
        "password" => "password"
    },
    "dynalink rta700w" => {
        "username" => "admin",
        "password" => "password"
    },
    "e-con econ dsl router" => {
        "username" => "admin",
        "password" => "password"
    },
    "e-tech adsl ethernet router rev. annex a v2" => {
        "username" => "admin",
        "password" => "password"
    },
    "e-tech wireless 11mbps router model:wlrt03" => {
        "username" => "(none)",
        "password" => "password"
    },
    "e-tech router rev. rtbr03" => {
        "username" => "(none)",
        "password" => "password"
    },
    "edimax broadband router rev. hardware: rev a. boot code: 1.0 runtime code 2.63" => {
        "username" => "admin",
        "password" => "password"
    },
    "edimax ew-7205apl rev. firmware release 2.40a-00" => {
        "username" => "guest",
        "password" => "password"
    },
    "edimax es-5224rxm" => {
        "username" => "admin",
        "password" => "password"
    },
    "edimax wireless adsl router rev. ar-7024" => {
        "username" => "admin",
        "password" => "password"
    },
    "efficient speedstream dsl" => {
        "username" => "n/a",
        "password" => "password"
    },
    "efficient 5871 dsl router rev. v 5.3.3-0" => {
        "username" => "login",
        "password" => "password"
    },
    "efficient 5851" => {
        "username" => "login",
        "password" => "password"
    },
    "efficient speedstream dsl" => {
        "username" => "n/a",
        "password" => "password"
    },
    "efficient networks speedstream 5711 rev. teledanmark version (only .dk)" => {
        "username" => "n/a",
        "password" => "password"
    },
    "efficient networks en 5861" => {
        "username" => "login",
        "password" => "password"
    },
    "efficient networks 5851 sdsl router rev. n/a" => {
        "username" => "(none)",
        "password" => "password"
    },
    "elsa lancom office isdn router rev. 800/1000/1100" => {
        "username" => "n/a",
        "password" => "password"
    },
    "enterasys ang-1105 rev. unknown" => {
        "username" => "admin",
        "password" => "password"
    },
    "enterasys ang-1105 rev. unknown" => {
        "username" => "(none)",
        "password" => "password"
    },
    "enterasys vertical horizon rev. any" => {
        "username" => "admin",
        "password" => "password"
    },
    "enterasys vertical horizon rev. vh-2402s" => {
        "username" => "tiger",
        "password" => "password"
    },
    "entrust getaccess rev. 4.x and 7.x" => {
        "username" => "websecadm",
        "password" => "password"
    },
    "ericsson ericsson acc" => {
        "username" => "netman",
        "password" => "password"
    },
    "ericsson ericsson acc" => {
        "username" => "netman",
        "password" => "password"
    },
    "ericsson md110 pabx rev. up-to-bc9" => {
        "username" => "(none)",
        "password" => "password"
    },
    "ericsson ericsson acc" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ericsson acc tigris platform rev. all" => {
        "username" => "public",
        "password" => "password"
    },
    "esp digiview pro4n" => {
        "username" => "1111",
        "password" => "password"
    },
    "everfocus powerplex rev. edr1600" => {
        "username" => "admin",
        "password" => "password"
    },
    "everfocus powerplex rev. edr1600" => {
        "username" => "supervisor",
        "password" => "password"
    },
    "everfocus powerplex rev. edr1600" => {
        "username" => "operator",
        "password" => "password"
    },
    "exabyte magnum20" => {
        "username" => "anonymous",
        "password" => "password"
    },
    "extreme networks all switches" => {
        "username" => "admin",
        "password" => "password"
    },
    "f5 bigip 540" => {
        "username" => "root",
        "password" => "password"
    },
    "f5-networks bigip" => {
        "username" => "n/a",
        "password" => "password"
    },
    "flowpoint 2200 sdsl" => {
        "username" => "admin",
        "password" => "password"
    },
    "flowpoint dsl" => {
        "username" => "n/a",
        "password" => "password"
    },
    "flowpoint 100 idsn" => {
        "username" => "admin",
        "password" => "password"
    },
    "flowpoint 40 idsl" => {
        "username" => "admin",
        "password" => "password"
    },
    "flowpoint flowpoint dsl" => {
        "username" => "admin",
        "password" => "password"
    },
    "fortinet fortigate" => {
        "username" => "admin",
        "password" => "password"
    },
    "foundry networks ironview network manager rev. version 01.6.00a(service pack) 0620031754" => {
        "username" => "admin",
        "password" => "password"
    },
    "freetech pc bios" => {
        "username" => "n/a",
        "password" => "password"
    },
    "freetech bios" => {
        "username" => "n/a",
        "password" => "password"
    },
    "fujitsu siemens routers" => {
        "username" => "(none)",
        "password" => "password"
    },
    "funk software steel belted radius rev. 3.x" => {
        "username" => "admin",
        "password" => "password"
    },
    "gericom phoenix" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "giga 8ippro1000" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "gvc e800/rb4" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "hp isee" => {
        "username" => "admin",
        "password" => "password"
    },
    "hp power manager rev. 3" => {
        "username" => "admin",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "OPERATOR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "OPERATOR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "OPERATOR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "OPERATOR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "OPERATOR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "PCUSER",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "RSBCMON",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "SPOOLMAN",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "WP",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "ADVMAIL",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "ADVMAIL",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "FIELD",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "FIELD",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "FIELD",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "FIELD",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "FIELD",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "FIELD",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "FIELD",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "FIELD",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "HELLO",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "HELLO",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "HELLO",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "HELLO",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MAIL",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MAIL",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MAIL",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MAIL",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MAIL",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MANAGER",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MANAGER",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MANAGER",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MANAGER",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MANAGER",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MANAGER",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MANAGER",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp hp 2000/3000 mpe/xx" => {
        "username" => "MGR",
        "password" => "password"
    },
    "hp laserjet net printers rev. ones with jetdirect on them" => {
        "username" => "(none)",
        "password" => "password"
    },
    "hp laserjet net printers rev. ones with jetdirect on them" => {
        "username" => "(none)",
        "password" => "password"
    },
    "hp laserjet net printers rev. ones with jetdirect on them" => {
        "username" => "Anonymous",
        "password" => "password"
    },
    "hp laserjet net printers rev. ones with jetdirect on them" => {
        "username" => "(none)",
        "password" => "password"
    },
    "hp webmin rev. 0.84" => {
        "username" => "admin",
        "password" => "password"
    },
    "hp sa7200" => {
        "username" => "admin",
        "password" => "password"
    },
    "hp sa7200" => {
        "username" => "admin",
        "password" => "password"
    },
    "huawei mt880r" => {
        "username" => "TMAR#HWMT8007079",
        "password" => "password"
    },
    "huawei mt882 adsl2+" => {
        "username" => "admin",
        "password" => "password"
    },
    "iblitzz bwa711/all models rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "ibm ascend oem routers" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ibm a21m" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ibm 390e" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ibm totalstorage enterprise server" => {
        "username" => "storwatch",
        "password" => "password"
    },
    "ibm 8239 token ring hub rev. 2.5" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ibm 8224 hub" => {
        "username" => "vt100",
        "password" => "password"
    },
    "ibm 3534 f08 fibre switch" => {
        "username" => "admin",
        "password" => "password"
    },
    "ibm switch rev. 8275-217" => {
        "username" => "admin",
        "password" => "password"
    },
    "ibm directory - web administration tool rev. 5.1" => {
        "username" => "superadmin",
        "password" => "password"
    },
    "ibm hardware management console rev. 3" => {
        "username" => "hscroot",
        "password" => "password"
    },
    "ibm 3583 tape library" => {
        "username" => "admin",
        "password" => "password"
    },
    "ibm infoprint 6700 rev. http://www.phenoelit.de/dpl/dpl.html" => {
        "username" => "root",
        "password" => "password"
    },
    "ibm t20" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ibm ibm" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ibm remote supervisor adapter (rsa)" => {
        "username" => "USERID",
        "password" => "password"
    },
    "ibm bladecenter mgmt console" => {
        "username" => "USERID",
        "password" => "password"
    },
    "ibm t42" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "ibm a20m" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ihoi oihoh rev. lknlkn" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "imai traffic shaper rev. ts-1012" => {
        "username" => "n/a",
        "password" => "password"
    },
    "inchon inchon rev. inchon" => {
        "username" => "admin",
        "password" => "password"
    },
    "infosmart soho router" => {
        "username" => "admin",
        "password" => "password"
    },
    "integral technologies remoteview rev. 4" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "intel shiva" => {
        "username" => "root",
        "password" => "password"
    },
    "intel express 9520 router" => {
        "username" => "NICONEX",
        "password" => "password"
    },
    "intel express 520t switch" => {
        "username" => "setup",
        "password" => "password"
    },
    "intel wireless ap 2011 rev. 2.21" => {
        "username" => "(none)",
        "password" => "password"
    },
    "intel wireless gateway rev. 3.x" => {
        "username" => "intel",
        "password" => "password"
    },
    "intel shiva" => {
        "username" => "Guest",
        "password" => "password"
    },
    "intel shiva" => {
        "username" => "root",
        "password" => "password"
    },
    "intel netstructure rev. 480t" => {
        "username" => "admin",
        "password" => "password"
    },
    "interbase interbase database server rev. all" => {
        "username" => "SYSDBA",
        "password" => "password"
    },
    "intermec mobile lan rev. 5.25" => {
        "username" => "intermec",
        "password" => "password"
    },
    "intershop intershop rev. 4" => {
        "username" => "operator",
        "password" => "password"
    },
    "intersystems cache post-rdms" => {
        "username" => "system",
        "password" => "password"
    },
    "intex organizer" => {
        "username" => "n/a",
        "password" => "password"
    },
    "inventel livebox" => {
        "username" => "admin",
        "password" => "password"
    },
    "ion nelu rev. nel" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ion nelu rev. nel" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "ipstar ipstar satellite router/radio rev. v2" => {
        "username" => "admin",
        "password" => "password"
    },
    "ipstar ipstar network box rev. v.2+" => {
        "username" => "admin",
        "password" => "password"
    },
    "ironport messaging gateway appliance" => {
        "username" => "admin",
        "password" => "password"
    },
    "jaht adsl router rev. ar41/2a" => {
        "username" => "admin",
        "password" => "password"
    },
    "jd edwards worldvision/oneworld rev. all(?)" => {
        "username" => "JDE",
        "password" => "password"
    },
    "jde worldvision/oneworld" => {
        "username" => "PRODDTA",
        "password" => "password"
    },
    "jds microprocessing hydra 3000 rev. r2.02" => {
        "username" => "hydrasna",
        "password" => "password"
    },
    "juniper isg2000" => {
        "username" => "netscreen",
        "password" => "password"
    },
    "kalatel calibur dsr-2000e" => {
        "username" => "n/a",
        "password" => "password"
    },
    "kalatel calibur dsr-2000e" => {
        "username" => "n/a",
        "password" => "password"
    },
    "konica minolta magicolor 2300 dl" => {
        "username" => "(none)",
        "password" => "password"
    },
    "konica minolta magicolor 2430dl rev. all" => {
        "username" => "(none)",
        "password" => "password"
    },
    "kti ks-2260" => {
        "username" => "superuser",
        "password" => "password"
    },
    "kti ks2600" => {
        "username" => "admin",
        "password" => "password"
    },
    "kti ks2260" => {
        "username" => "admin",
        "password" => "password"
    },
    "kyocera ecolink rev. 7.2" => {
        "username" => "n/a",
        "password" => "password"
    },
    "kyocera telnet server ib-20/21" => {
        "username" => "root",
        "password" => "password"
    },
    "kyocera intermate lan fs pro 10/100 rev. k82_0371" => {
        "username" => "admin",
        "password" => "password"
    },
    "kyocera kr1" => {
        "username" => "admin",
        "password" => "password"
    },
    "lancom il11" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lantronics lantronics terminal server" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lantronics lantronics terminal server" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lantronix lantronix terminal" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lantronix scs1620" => {
        "username" => "sysadmin",
        "password" => "password"
    },
    "lantronix scs3200" => {
        "username" => "login",
        "password" => "password"
    },
    "lantronix scs400" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lantronix scs200" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lantronix scs100" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lantronix ets4p" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lantronix ets16p" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lantronix ets32pr" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lantronix ets422pr" => {
        "username" => "n/a",
        "password" => "password"
    },
    "latis network border guard" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lg aria ipecs rev. all" => {
        "username" => "(none)",
        "password" => "password"
    },
    "lg lam200e / lam200r" => {
        "username" => "admin",
        "password" => "password"
    },
    "linksys wap11" => {
        "username" => "n/a",
        "password" => "password"
    },
    "linksys dsl" => {
        "username" => "n/a",
        "password" => "password"
    },
    "linksys etherfast cable/dsl router" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "linksys linksys router dsl/cable" => {
        "username" => "(none)",
        "password" => "password"
    },
    "linksys befw11s4 rev. 1" => {
        "username" => "admin",
        "password" => "password"
    },
    "linksys befsr41 rev. 2" => {
        "username" => "(none)",
        "password" => "password"
    },
    "linksys wrt54g" => {
        "username" => "admin",
        "password" => "password"
    },
    "linksys wag54g" => {
        "username" => "admin",
        "password" => "password"
    },
    "linksys linksys dsl" => {
        "username" => "n/a",
        "password" => "password"
    },
    "linksys wap54g rev. 2.0" => {
        "username" => "(none)",
        "password" => "password"
    },
    "linksys wrt54g rev. all revisions" => {
        "username" => "(none)",
        "password" => "password"
    },
    "linksys model wrt54gc compact wireless-g broadband router" => {
        "username" => "(none)",
        "password" => "password"
    },
    "linksys ag 241 - adsl2 gateway with 4-port switch" => {
        "username" => "admin",
        "password" => "password"
    },
    "linksys comcast rev. comcast-supplied" => {
        "username" => "comcast",
        "password" => "password"
    },
    "linksys wag54gs" => {
        "username" => "admin",
        "password" => "password"
    },
    "linksys ap 1120" => {
        "username" => "n/a",
        "password" => "password"
    },
    "linksys pap2 / pap2v2 (vonage)" => {
        "username" => "admin",
        "password" => "password"
    },
    "linksys rt31p2 (vonage)" => {
        "username" => "admin",
        "password" => "password"
    },
    "linksys rtp300 (vonage)" => {
        "username" => "admin",
        "password" => "password"
    },
    "linksys wrt54gp2 (vonage)" => {
        "username" => "admin",
        "password" => "password"
    },
    "linksys wrtp54g (vonage)" => {
        "username" => "admin",
        "password" => "password"
    },
    "livingston irx router" => {
        "username" => "!root",
        "password" => "password"
    },
    "livingston livingston portmaster 3" => {
        "username" => "!root",
        "password" => "password"
    },
    "livingston officerouter" => {
        "username" => "!root",
        "password" => "password"
    },
    "livingstone portmaster 2r" => {
        "username" => "root",
        "password" => "password"
    },
    "lockdown networks all lockdown products rev. up to 2.7" => {
        "username" => "setup",
        "password" => "password"
    },
    "logitech logitech mobile headset" => {
        "username" => "(none)",
        "password" => "password"
    },
    "longshine isscfg" => {
        "username" => "admin",
        "password" => "password"
    },
    "loopcom " => {
        "username" => "admin",
        "password" => "password"
    },
    "lucent m770" => {
        "username" => "super",
        "password" => "password"
    },
    "lucent b-stdx9000" => {
        "username" => "(any 3 characters)",
        "password" => "password"
    },
    "lucent b-stdx9000" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lucent b-stdx9000 rev. all" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lucent cbx 500" => {
        "username" => "(any 3 characters)",
        "password" => "password"
    },
    "lucent cbx 500" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lucent gx 550" => {
        "username" => "n/a",
        "password" => "password"
    },
    "lucent max-tnt" => {
        "username" => "admin",
        "password" => "password"
    },
    "lucent psax 1200 and below" => {
        "username" => "root",
        "password" => "password"
    },
    "lucent psax 1250 and above" => {
        "username" => "readwrite",
        "password" => "password"
    },
    "lucent psax 1250 and above" => {
        "username" => "readonly",
        "password" => "password"
    },
    "lucent anymedia" => {
        "username" => "LUCENT01",
        "password" => "password"
    },
    "lucent anymedia" => {
        "username" => "LUCENT02",
        "password" => "password"
    },
    "lucent packetstar" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "lucent cellpipe 22a-bx-ar usb d" => {
        "username" => "admin",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "bciim",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "bcim",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "bcms",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "bcnas",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "blue",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "browse",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "browse",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "craft",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "craft",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "cust",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "enquiry",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "field",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "inads",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "inads",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "init",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "locate",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "maint",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "maint",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "nms",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "rcust",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "support",
        "password" => "password"
    },
    "lucent system 75" => {
        "username" => "tech",
        "password" => "password"
    },
    "marconi fore atm switches" => {
        "username" => "ami",
        "password" => "password"
    },
    "maxdata ms2137" => {
        "username" => "n/a",
        "password" => "password"
    },
    "mcafee scm 3100 rev. 4.1" => {
        "username" => "scmadmin",
        "password" => "password"
    },
    "mcdata fc switches/directors" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "mediatrix 2102 mediatrix 2102" => {
        "username" => "admin",
        "password" => "password"
    },
    "medion routers" => {
        "username" => "n/a",
        "password" => "password"
    },
    "megastar bios" => {
        "username" => "n/a",
        "password" => "password"
    },
    "mentec micro/rsx" => {
        "username" => "MICRO",
        "password" => "password"
    },
    "mentec micro/rsx" => {
        "username" => "MICRO",
        "password" => "password"
    },
    "mercury 234234 rev. 234234" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "mercury kt133a/686b" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "meridian pbx rev. any" => {
        "username" => "service",
        "password" => "password"
    },
    "micronet access point rev. sp912" => {
        "username" => "root",
        "password" => "password"
    },
    "micronet micronet sp5002" => {
        "username" => "mac",
        "password" => "password"
    },
    "micronet 3351 / 3354" => {
        "username" => "admin",
        "password" => "password"
    },
    "micronet sp918gk" => {
        "username" => "admin",
        "password" => "password"
    },
    "microplex print server" => {
        "username" => "root",
        "password" => "password"
    },
    "microrouter 900i" => {
        "username" => "n/a",
        "password" => "password"
    },
    "microsoft mn-series" => {
        "username" => "(none)",
        "password" => "password"
    },
    "mikrotik router os rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "mikrotik router os rev. 2.9.17" => {
        "username" => "admin",
        "password" => "password"
    },
    "milan mil-sm801p" => {
        "username" => "root",
        "password" => "password"
    },
    "minolta qms magicolor 3100 rev. 3.0.0" => {
        "username" => "operator",
        "password" => "password"
    },
    "minolta qms magicolor 3100 rev. 3.0.0" => {
        "username" => "admin",
        "password" => "password"
    },
    "mintel mintel pbx" => {
        "username" => "n/a",
        "password" => "password"
    },
    "mintel mintel pbx" => {
        "username" => "n/a",
        "password" => "password"
    },
    "mitel 3300 icp rev. all" => {
        "username" => "system",
        "password" => "password"
    },
    "mitel sx2000 rev. all" => {
        "username" => "n/a",
        "password" => "password"
    },
    "motorola cablerouter" => {
        "username" => "cablecom",
        "password" => "password"
    },
    "motorola wr850g rev. 4.03" => {
        "username" => "admin",
        "password" => "password"
    },
    "motorola wireless router rev. wr850g" => {
        "username" => "admin",
        "password" => "password"
    },
    "motorola sbg900" => {
        "username" => "admin",
        "password" => "password"
    },
    "motorola motorola cablerouter" => {
        "username" => "cablecom",
        "password" => "password"
    },
    "motorola vanguard" => {
        "username" => "n/a",
        "password" => "password"
    },
    "motorola vt1005 (vonage)" => {
        "username" => "(blank)",
        "password" => "password"
    },
    "motorola vt2142 (vonage)" => {
        "username" => "router",
        "password" => "password"
    },
    "motorola vt2442 (vonage)" => {
        "username" => "router",
        "password" => "password"
    },
    "motorola vt2542 (vonage)" => {
        "username" => "router",
        "password" => "password"
    },
    "mro software maximo rev. v4.1" => {
        "username" => "SYSADM",
        "password" => "password"
    },
    "mutare software evm admin rev. all" => {
        "username" => "(none)",
        "password" => "password"
    },
    "nai intrushield ips rev. 1200/2600/4000" => {
        "username" => "admin",
        "password" => "password"
    },
    "nai entercept" => {
        "username" => "GlobalAdmin",
        "password" => "password"
    },
    "nec warpstar-basestation" => {
        "username" => "n/a",
        "password" => "password"
    },
    "netcomm nb1300" => {
        "username" => "admin",
        "password" => "password"
    },
    "netcomm nb5" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear rm356 rev. none" => {
        "username" => "(none)",
        "password" => "password"
    },
    "netgear wgt624 rev. 2" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear comcast rev. comcast-supplied" => {
        "username" => "comcast",
        "password" => "password"
    },
    "netgear fr314" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear mr-314 rev. 3.26" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear rt314" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear rp614" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear rp114 rev. 3.26" => {
        "username" => "(none)",
        "password" => "password"
    },
    "netgear wg602 rev. firmware version 1.04.0" => {
        "username" => "super",
        "password" => "password"
    },
    "netgear wg602 rev. firmware version 1.7.14" => {
        "username" => "superman",
        "password" => "password"
    },
    "netgear wg602 rev. firmware version 1.5.67" => {
        "username" => "super",
        "password" => "password"
    },
    "netgear mr814" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear fvs318" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear dm602" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear fr114p" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear me102" => {
        "username" => "(none)",
        "password" => "password"
    },
    "netgear wgr614 rev. v4" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear rp114 rev. 3.20-3.26" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear dg834g" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear router/modem" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear mr314" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear gsm7224" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear adsl modem dg632 rev. v3.3.0a_cx" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear wgt634u" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear fwg114p" => {
        "username" => "n/a",
        "password" => "password"
    },
    "netgear gs724t rev. v1.0.1_1104" => {
        "username" => "n/a",
        "password" => "password"
    },
    "netgear fm114p" => {
        "username" => "n/a",
        "password" => "password"
    },
    "netgear dg834" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear wnr834 bv2" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear wnr834bv2" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgear wpn824 / wpn824v2" => {
        "username" => "admin",
        "password" => "password"
    },
    "netgenesis netanalysis web reporting" => {
        "username" => "naadmin",
        "password" => "password"
    },
    "netopia netopia 9500" => {
        "username" => "netopia",
        "password" => "password"
    },
    "netopia r910" => {
        "username" => "admin",
        "password" => "password"
    },
    "netopia 3351" => {
        "username" => "n/a",
        "password" => "password"
    },
    "netopia 4542" => {
        "username" => "admin",
        "password" => "password"
    },
    "netopia netopia 7100" => {
        "username" => "(none)",
        "password" => "password"
    },
    "netopia netopia 9500" => {
        "username" => "netopia",
        "password" => "password"
    },
    "netport express 10/100" => {
        "username" => "setup",
        "password" => "password"
    },
    "netscreen firewall" => {
        "username" => "netscreen",
        "password" => "password"
    },
    "netscreen firewall" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "netscreen firewall" => {
        "username" => "admin",
        "password" => "password"
    },
    "netscreen firewall" => {
        "username" => "operator",
        "password" => "password"
    },
    "netscreen firewall" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "netstar netpilot" => {
        "username" => "admin",
        "password" => "password"
    },
    "network appliance netcache rev. any" => {
        "username" => "admin",
        "password" => "password"
    },
    "network associates webshield security appliance e500" => {
        "username" => "e500",
        "password" => "password"
    },
    "network associates webshield security appliance e250" => {
        "username" => "e250",
        "password" => "password"
    },
    "network everywhere nwr11b" => {
        "username" => "(none)",
        "password" => "password"
    },
    "nexxt solutions nw230nxt14" => {
        "username" => "guest",
        "password" => "password"
    },
    "ngsec ngsecureweb" => {
        "username" => "admin",
        "password" => "password"
    },
    "ngsec ngsecureweb" => {
        "username" => "admin",
        "password" => "password"
    },
    "niksun netdetector" => {
        "username" => "vcr",
        "password" => "password"
    },
    "nimble pc bios" => {
        "username" => "n/a",
        "password" => "password"
    },
    "nimble bios" => {
        "username" => "n/a",
        "password" => "password"
    },
    "nokia 7360" => {
        "username" => "(none)",
        "password" => "password"
    },
    "nokia dsl router m1122 rev. 1.1 - 1.2" => {
        "username" => "m1122",
        "password" => "password"
    },
    "nokia mw1122" => {
        "username" => "telecom",
        "password" => "password"
    },
    "nortel meridian link" => {
        "username" => "disttech",
        "password" => "password"
    },
    "nortel meridian link" => {
        "username" => "maint",
        "password" => "password"
    },
    "nortel meridian link" => {
        "username" => "mlusr",
        "password" => "password"
    },
    "nortel remote office 9150" => {
        "username" => "admin",
        "password" => "password"
    },
    "nortel accelar (passport) 1000 series routing switches" => {
        "username" => "l2",
        "password" => "password"
    },
    "nortel accelar (passport) 1000 series routing switches" => {
        "username" => "l3",
        "password" => "password"
    },
    "nortel accelar (passport) 1000 series routing switches" => {
        "username" => "ro",
        "password" => "password"
    },
    "nortel accelar (passport) 1000 series routing switches" => {
        "username" => "rw",
        "password" => "password"
    },
    "nortel accelar (passport) 1000 series routing switches" => {
        "username" => "rwa",
        "password" => "password"
    },
    "nortel extranet switches" => {
        "username" => "admin",
        "password" => "password"
    },
    "nortel baystack 350-24t" => {
        "username" => "n/a",
        "password" => "password"
    },
    "nortel meridian pbx" => {
        "username" => "login",
        "password" => "password"
    },
    "nortel meridian pbx" => {
        "username" => "login",
        "password" => "password"
    },
    "nortel meridian pbx" => {
        "username" => "login",
        "password" => "password"
    },
    "nortel meridian pbx" => {
        "username" => "spcl",
        "password" => "password"
    },
    "nortel meridian max" => {
        "username" => "service",
        "password" => "password"
    },
    "nortel meridian max" => {
        "username" => "root",
        "password" => "password"
    },
    "nortel matra 6501 pbx" => {
        "username" => "(none)",
        "password" => "password"
    },
    "nortel meridian max" => {
        "username" => "maint",
        "password" => "password"
    },
    "nortel meridian ccr" => {
        "username" => "service",
        "password" => "password"
    },
    "nortel meridian ccr" => {
        "username" => "disttech",
        "password" => "password"
    },
    "nortel meridian ccr" => {
        "username" => "maint",
        "password" => "password"
    },
    "nortel meridian ccr" => {
        "username" => "ccrusr",
        "password" => "password"
    },
    "nortel meridian" => {
        "username" => "n/a",
        "password" => "password"
    },
    "nortel meridian link" => {
        "username" => "service",
        "password" => "password"
    },
    "nortel contivity rev. extranet/vpn switches" => {
        "username" => "admin",
        "password" => "password"
    },
    "nortel business communications manager / bcm400 3.6 / bcm rev. 3.5 and 3.6. you can also access these systems fro" => {
        "username" => "supervisor",
        "password" => "password"
    },
    "nortel phone system rev. all" => {
        "username" => "n/a",
        "password" => "password"
    },
    "nortel norstar" => {
        "username" => "266344",
        "password" => "password"
    },
    "nortel dms" => {
        "username" => "n/a",
        "password" => "password"
    },
    "nortel p8600" => {
        "username" => "n/a",
        "password" => "password"
    },
    "nortel bcm50 release 2.0 rev. you can also access these systems from the phone b" => {
        "username" => "supervisor",
        "password" => "password"
    },
    "nrg or ricoh dsc338 printer rev. 1.19" => {
        "username" => "(none)",
        "password" => "password"
    },
    "nullsoft shoutcast rev. 1.9.5" => {
        "username" => "admin",
        "password" => "password"
    },
    "oki c5700" => {
        "username" => "root",
        "password" => "password"
    },
    "olitec sx 200 adsl modem router" => {
        "username" => "admin",
        "password" => "password"
    },
    "olitec (trendchip) sx 202 adsl modem router" => {
        "username" => "admin",
        "password" => "password"
    },
    "omnitronix data-link rev. dl150" => {
        "username" => "(none)",
        "password" => "password"
    },
    "omnitronix data-link rev. dl150" => {
        "username" => "(none)",
        "password" => "password"
    },
    "omron mr104fh" => {
        "username" => "n/a",
        "password" => "password"
    },
    "onixon dsl x402" => {
        "username" => "root",
        "password" => "password"
    },
    "openconnect oc://webconnect pro" => {
        "username" => "admin",
        "password" => "password"
    },
    "openconnect oc://webconnect pro" => {
        "username" => "adminstat",
        "password" => "password"
    },
    "openconnect oc://webconnect pro" => {
        "username" => "adminview",
        "password" => "password"
    },
    "openconnect oc://webconnect pro" => {
        "username" => "adminuser",
        "password" => "password"
    },
    "openconnect oc://webconnect pro" => {
        "username" => "adminview",
        "password" => "password"
    },
    "openconnect oc://webconnect pro" => {
        "username" => "helpdesk",
        "password" => "password"
    },
    "openwave wap gateway rev. any" => {
        "username" => "sys",
        "password" => "password"
    },
    "openwave msp rev. any" => {
        "username" => "cac_admin",
        "password" => "password"
    },
    "oracle oracle rdbms rev. any" => {
        "username" => "system/manager",
        "password" => "password"
    },
    "orange livebox" => {
        "username" => "admin",
        "password" => "password"
    },
    "origo " => {
        "username" => "admin",
        "password" => "password"
    },
    "osicom netprint rev. 500 1000 1500 and 2000 series" => {
        "username" => "Manager",
        "password" => "password"
    },
    "osicom netprint and jetx print rev. 500 1000 1500 and 2000 series" => {
        "username" => "sysadm",
        "password" => "password"
    },
    "osicom osicom plus t1/plus 56k" => {
        "username" => "write",
        "password" => "password"
    },
    "osicom netcommuter remote access server" => {
        "username" => "debug",
        "password" => "password"
    },
    "osicom netcommuter remote access server" => {
        "username" => "echo",
        "password" => "password"
    },
    "osicom netcommuter remote access server" => {
        "username" => "guest",
        "password" => "password"
    },
    "osicom netcommuter remote access server" => {
        "username" => "Manager",
        "password" => "password"
    },
    "osicom netcommuter remote access server" => {
        "username" => "sysadm",
        "password" => "password"
    },
    "osicom osicom plus t1/plus 56k" => {
        "username" => "write",
        "password" => "password"
    },
    "osicom netcommuter remote access server" => {
        "username" => "sysadm",
        "password" => "password"
    },
    "osicom jetxprint rev. 1000e/b" => {
        "username" => "sysadm",
        "password" => "password"
    },
    "osicom jetxprint rev. 1000e/n" => {
        "username" => "sysadm",
        "password" => "password"
    },
    "osicom jetxprint rev. 1000t/n" => {
        "username" => "sysadm",
        "password" => "password"
    },
    "osicom jetxprint rev. 500 e/b" => {
        "username" => "sysadm",
        "password" => "password"
    },
    "osicom netprint rev. 500" => {
        "username" => "1500",
        "password" => "password"
    },
    "ovislink wl-1120ap" => {
        "username" => "root",
        "password" => "password"
    },
    "pacific micro data mast 9500 universal disk array rev. esm ver. 2.11 / 1" => {
        "username" => "pmd",
        "password" => "password"
    },
    "panasonic cf-28" => {
        "username" => "n/a",
        "password" => "password"
    },
    "panasonic cf-45" => {
        "username" => "n/a",
        "password" => "password"
    },
    "panasonic kxtd1232" => {
        "username" => "admin",
        "password" => "password"
    },
    "panasonic cf 27 rev. 4" => {
        "username" => "n/a",
        "password" => "password"
    },
    "penril datability vcp300 terminal server" => {
        "username" => "n/a",
        "password" => "password"
    },
    "pentagram cerberus adsl modem + router" => {
        "username" => "admin",
        "password" => "password"
    },
    "pentaoffice sat router" => {
        "username" => "(none)",
        "password" => "password"
    },
    "pentasafe vigilent security manager rev. 3" => {
        "username" => "PSEAdmin",
        "password" => "password"
    },
    "perle cs9000 rev. any" => {
        "username" => "admin",
        "password" => "password"
    },
    "phoenix v1.14 phoenix v1.14" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "pirelli pirelli router" => {
        "username" => "admin",
        "password" => "password"
    },
    "pirelli pirelli router" => {
        "username" => "admin",
        "password" => "password"
    },
    "pirelli pirelli router" => {
        "username" => "user",
        "password" => "password"
    },
    "pirelli pirelli age-sb" => {
        "username" => "admin",
        "password" => "password"
    },
    "pirelli age adsl router" => {
        "username" => "admin",
        "password" => "password"
    },
    "pirelli age adsl router" => {
        "username" => "user",
        "password" => "password"
    },
    "planet wap-1900/1950/2000 rev. 2.5.0" => {
        "username" => "(none)",
        "password" => "password"
    },
    "planet ade-4110" => {
        "username" => "admin",
        "password" => "password"
    },
    "planet xrt-401d" => {
        "username" => "admin",
        "password" => "password"
    },
    "planet ade-4000" => {
        "username" => "admin",
        "password" => "password"
    },
    "planet akcess point" => {
        "username" => "admin",
        "password" => "password"
    },
    "polycom soundpoint voip phones" => {
        "username" => "Polycom",
        "password" => "password"
    },
    "polycom viewstation 4000 rev. 3.5" => {
        "username" => "(none)",
        "password" => "password"
    },
    "polycom ipower 9000" => {
        "username" => "(none)",
        "password" => "password"
    },
    "prestigio nobile rev. 156" => {
        "username" => "n/a",
        "password" => "password"
    },
    "proxim orinoco 600/2000 rev. all" => {
        "username" => "(none)",
        "password" => "password"
    },
    "proxim tsunami mp.11 5054-r" => {
        "username" => "(none)",
        "password" => "password"
    },
    "proxim ap-4000" => {
        "username" => "",
        "password" => "password"
    },
    "psion teklogix 9150" => {
        "username" => "support",
        "password" => "password"
    },
    "pyramid computer benhur rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "quintum technologies inc. tenor series rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "radware linkproof" => {
        "username" => "lp",
        "password" => "password"
    },
    "radware linkproof rev. 3.73.03" => {
        "username" => "radware",
        "password" => "password"
    },
    "raidzone raid arrays" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ramp networks webramp" => {
        "username" => "wradmin",
        "password" => "password"
    },
    "ramp networks webramp" => {
        "username" => "wradmin",
        "password" => "password"
    },
    "redhat redhat 6.2" => {
        "username" => "piranha",
        "password" => "password"
    },
    "redhat redhat 6.2" => {
        "username" => "piranha",
        "password" => "password"
    },
    "research pc bios" => {
        "username" => "n/a",
        "password" => "password"
    },
    "research bios" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ricoh aficio rev. ap3800c" => {
        "username" => "sysadmin",
        "password" => "password"
    },
    "ricoh aficio 2228c" => {
        "username" => "sysadmin",
        "password" => "password"
    },
    "ricoh aficio ap3800c rev. 2.17" => {
        "username" => "(none)",
        "password" => "password"
    },
    "ricoh aficio 2232c" => {
        "username" => "n/a",
        "password" => "password"
    },
    "ricoh ap410n rev. 1.13" => {
        "username" => "admin",
        "password" => "password"
    },
    "ricoh aficio 2020d" => {
        "username" => "admin",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "setup",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "teacher",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "temp1",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "admin",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "admin2",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "adminstrator",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "deskalt",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "deskman",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "desknorm",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "deskres",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "guest",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "replicator",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "RMUser1",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "topicalt",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "topicnorm",
        "password" => "password"
    },
    "rm rm connect" => {
        "username" => "topicres",
        "password" => "password"
    },
    "roamabout roamabout r2 wireless access platform" => {
        "username" => "admin",
        "password" => "password"
    },
    "sagem fast 1400" => {
        "username" => "admin",
        "password" => "password"
    },
    "sagem fast 1200 (fast 1200)" => {
        "username" => "root",
        "password" => "password"
    },
    "sagem fast 1400w" => {
        "username" => "root",
        "password" => "password"
    },
    "sagem livebox" => {
        "username" => "admin",
        "password" => "password"
    },
    "samsung magiclan swl-3500rg rev. 2.15" => {
        "username" => "public",
        "password" => "password"
    },
    "samsung n620" => {
        "username" => "n/a",
        "password" => "password"
    },
    "samsung modem/router rev. aht-e300" => {
        "username" => "admin",
        "password" => "password"
    },
    "scientific atlanta dpx2100 rev. comcast-supplied" => {
        "username" => "admin",
        "password" => "password"
    },
    "senao 2611cb3+d (802.11b wireless ap)" => {
        "username" => "admin",
        "password" => "password"
    },
    "server technology sentry remote power manager" => {
        "username" => "GEN1",
        "password" => "password"
    },
    "server technology sentry remote power manager" => {
        "username" => "GEN2",
        "password" => "password"
    },
    "server technology sentry remote power manager" => {
        "username" => "ADMN",
        "password" => "password"
    },
    "sharp ar-407/s402" => {
        "username" => "n/a",
        "password" => "password"
    },
    "siemens se515" => {
        "username" => "admin",
        "password" => "password"
    },
    "siemens rolm pbx" => {
        "username" => "op",
        "password" => "password"
    },
    "siemens rolm pbx" => {
        "username" => "su",
        "password" => "password"
    },
    "siemens phonemail" => {
        "username" => "poll",
        "password" => "password"
    },
    "siemens phonemail" => {
        "username" => "sysadmin",
        "password" => "password"
    },
    "siemens rolm pbx" => {
        "username" => "admin",
        "password" => "password"
    },
    "siemens phonemail" => {
        "username" => "tech",
        "password" => "password"
    },
    "siemens 5940 t1e1 router rev. 5940-001 v6.0.180-2" => {
        "username" => "superuser",
        "password" => "password"
    },
    "siemens phonemail" => {
        "username" => "poll",
        "password" => "password"
    },
    "siemens phonemail" => {
        "username" => "sysadmin",
        "password" => "password"
    },
    "siemens phonemail" => {
        "username" => "tech",
        "password" => "password"
    },
    "siemens rolm pbx" => {
        "username" => "admin",
        "password" => "password"
    },
    "siemens rolm pbx" => {
        "username" => "eng",
        "password" => "password"
    },
    "siemens rolm pbx" => {
        "username" => "op",
        "password" => "password"
    },
    "siemens rolm pbx" => {
        "username" => "op",
        "password" => "password"
    },
    "siemens rolm pbx" => {
        "username" => "su",
        "password" => "password"
    },
    "siemens speedstream 4100" => {
        "username" => "admin",
        "password" => "password"
    },
    "siemens hipath" => {
        "username" => "n/a",
        "password" => "password"
    },
    "siemens nixdorf pc bios" => {
        "username" => "n/a",
        "password" => "password"
    },
    "siemens nixdorf bios" => {
        "username" => "n/a",
        "password" => "password"
    },
    "siemens pro c5 siemens" => {
        "username" => "n/a",
        "password" => "password"
    },
    "sigma sigmacoma ipshare rev. sigmacom router v1.0" => {
        "username" => "admin",
        "password" => "password"
    },
    "siips trojan rev. 8974202" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "silex technology pricom (printserver)" => {
        "username" => "root",
        "password" => "password"
    },
    "sitara qosworks" => {
        "username" => "root",
        "password" => "password"
    },
    "sitecom all wifi routers" => {
        "username" => "(none)",
        "password" => "password"
    },
    "sitecom dc-202" => {
        "username" => "admin",
        "password" => "password"
    },
    "smartswitch router 250 ssr2500 rev. v3.0.9" => {
        "username" => "admin",
        "password" => "password"
    },
    "smc barricade 7004 awbr" => {
        "username" => "admin",
        "password" => "password"
    },
    "smc router rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "smc smc broadband router" => {
        "username" => "admin",
        "password" => "password"
    },
    "smc smc2804wbr rev. v.1" => {
        "username" => "(none)",
        "password" => "password"
    },
    "smc wifi router rev. all" => {
        "username" => "n/a",
        "password" => "password"
    },
    "smc smb2804wbr rev. v2" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "smc 7401bra rev. 1" => {
        "username" => "admin",
        "password" => "password"
    },
    "smc 7401bra rev. 2" => {
        "username" => "smc",
        "password" => "password"
    },
    "smc barricade7204brb" => {
        "username" => "admin",
        "password" => "password"
    },
    "smc 2804wr" => {
        "username" => "(none)",
        "password" => "password"
    },
    "smc router/modem rev. br7401" => {
        "username" => "admin",
        "password" => "password"
    },
    "smc smcwbr14-g rev. smcwbr14-g" => {
        "username" => "(none)",
        "password" => "password"
    },
    "smc modem/router" => {
        "username" => "cusadmin",
        "password" => "password"
    },
    "smc 7204bra" => {
        "username" => "smc",
        "password" => "password"
    },
    "smc smcwbr14-g" => {
        "username" => "n/a",
        "password" => "password"
    },
    "smc smc 7904bra" => {
        "username" => "(none)",
        "password" => "password"
    },
    "snapgear pro rev. lite" => {
        "username" => "1.79 +",
        "password" => "password"
    },
    "solution 6 viztopia accounts" => {
        "username" => "aaa",
        "password" => "password"
    },
    "sonic-x sonicanime rev. on" => {
        "username" => "root",
        "password" => "password"
    },
    "sonicwall all rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "sophia (schweiz) ag protector" => {
        "username" => "admin",
        "password" => "password"
    },
    "sophia (schweiz) ag protector" => {
        "username" => "root",
        "password" => "password"
    },
    "sorenson sr-200" => {
        "username" => "(none)",
        "password" => "password"
    },
    "speedcom " => {
        "username" => "admin",
        "password" => "password"
    },
    "speedstream 5660" => {
        "username" => "n/a",
        "password" => "password"
    },
    "speedstream 5861 smt router" => {
        "username" => "admin",
        "password" => "password"
    },
    "speedstream 5871 idsl router" => {
        "username" => "admin",
        "password" => "password"
    },
    "speedstream router 250 ssr250" => {
        "username" => "admin",
        "password" => "password"
    },
    "speedstream dsl" => {
        "username" => "admin",
        "password" => "password"
    },
    "speedstream 5667 rev. r4.0.1" => {
        "username" => "(none)",
        "password" => "password"
    },
    "speedxess hase-120" => {
        "username" => "(none)",
        "password" => "password"
    },
    "sphairon ar860" => {
        "username" => "admin",
        "password" => "password"
    },
    "spike cpe" => {
        "username" => "enable",
        "password" => "password"
    },
    "sun javawebserver rev. 1.x 2.x" => {
        "username" => "admin",
        "password" => "password"
    },
    "sun cobalt" => {
        "username" => "admin",
        "password" => "password"
    },
    "sun microsystems ilom of x4100 rev. 1.0" => {
        "username" => "root",
        "password" => "password"
    },
    "sweex wireless adsl 2/2+ modem/router 54mbps" => {
        "username" => "Sweex",
        "password" => "password"
    },
    "swissvoice ip 10s" => {
        "username" => "target",
        "password" => "password"
    },
    "sybase easerver" => {
        "username" => "jagadmin",
        "password" => "password"
    },
    "symbol spectrum rev. series 4100-4121" => {
        "username" => "n/a",
        "password" => "password"
    },
    "symbol ap-2412" => {
        "username" => "n/a",
        "password" => "password"
    },
    "symbol ap-3020" => {
        "username" => "n/a",
        "password" => "password"
    },
    "symbol ap-4111" => {
        "username" => "n/a",
        "password" => "password"
    },
    "symbol ap-4121" => {
        "username" => "n/a",
        "password" => "password"
    },
    "symbol ap-4131" => {
        "username" => "n/a",
        "password" => "password"
    },
    "t-comfort routers" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "tandberg tandberg rev. 8000" => {
        "username" => "(none)",
        "password" => "password"
    },
    "tandberg data dlt8000 autoloader 10x" => {
        "username" => "n/a",
        "password" => "password"
    },
    "tandem tacl" => {
        "username" => "super.super",
        "password" => "password"
    },
    "tandem tacl" => {
        "username" => "super.super",
        "password" => "password"
    },
    "team xodus xeniumos rev. 2.3" => {
        "username" => "xbox",
        "password" => "password"
    },
    "teklogix accesspoint" => {
        "username" => "Administrator",
        "password" => "password"
    },
    "telco systems edge link 100" => {
        "username" => "telco",
        "password" => "password"
    },
    "teledat routers" => {
        "username" => "admin",
        "password" => "password"
    },
    "teletronics wl-cpe-router rev. 3.05.2" => {
        "username" => "admin",
        "password" => "password"
    },
    "telewell tw-ea200" => {
        "username" => "admin",
        "password" => "password"
    },
    "telindus 1124" => {
        "username" => "n/a",
        "password" => "password"
    },
    "telindus shdsl1421 rev. yes" => {
        "username" => "admin",
        "password" => "password"
    },
    "telindus telindus rev. 2002" => {
        "username" => "admin",
        "password" => "password"
    },
    "tellabs titan 5500 rev. fp 6.x" => {
        "username" => "tellabs",
        "password" => "password"
    },
    "tellabs 7120" => {
        "username" => "root",
        "password" => "password"
    },
    "terayon unknown rev. comcast-supplied" => {
        "username" => "(none)",
        "password" => "password"
    },
    "terayon unknown rev. comcast-supplied" => {
        "username" => "(none)",
        "password" => "password"
    },
    "tiara 1400 rev. 3.x" => {
        "username" => "tiara",
        "password" => "password"
    },
    "topsec firewall" => {
        "username" => "superman",
        "password" => "password"
    },
    "trendnet tew-435brm" => {
        "username" => "admin",
        "password" => "password"
    },
    "troy extendnet 100zx" => {
        "username" => "admin",
        "password" => "password"
    },
    "tvt system expresse g5" => {
        "username" => "craft",
        "password" => "password"
    },
    "tvt system expresse g5 ds1 module" => {
        "username" => "(none)",
        "password" => "password"
    },
    "u.s. robotics sureconnect 9003 adsl ethernet/usb router" => {
        "username" => "root",
        "password" => "password"
    },
    "u.s. robotics sureconnect 9105 adsl 4-port router" => {
        "username" => "admin",
        "password" => "password"
    },
    "u.s. robotics 6000 cable modem" => {
        "username" => "cablemodem",
        "password" => "password"
    },
    "u.s. robotics usr8054 rev. all" => {
        "username" => "admin",
        "password" => "password"
    },
    "unex routers" => {
        "username" => "n/a",
        "password" => "password"
    },
    "uniden uip1869v (vonage)" => {
        "username" => "admin",
        "password" => "password"
    },
    "unisys clearpath mcp" => {
        "username" => "NAU",
        "password" => "password"
    },
    "unisys clearpath mcp" => {
        "username" => "ADMINISTRATOR",
        "password" => "password"
    },
    "unisys clearpath mcp" => {
        "username" => "HTTP",
        "password" => "password"
    },
    "us robotics adsl ethernet modem" => {
        "username" => "(none)",
        "password" => "password"
    },
    "us robotics usr8000 rev. 1.23 / 1.25" => {
        "username" => "root",
        "password" => "password"
    },
    "us robotics usr8550 rev. 3.0.5" => {
        "username" => "Any",
        "password" => "password"
    },
    "us robotics sureconnect adsl rev. sureconnect adsl" => {
        "username" => "support",
        "password" => "password"
    },
    "us robotics adsl gateway wireless router" => {
        "username" => "support",
        "password" => "password"
    },
    "us21100060 hp omibook 6100" => {
        "username" => "n/a",
        "password" => "password"
    },
    "v-tech ip8100" => {
        "username" => "VTech",
        "password" => "password"
    },
    "vasco vacman middleware rev. 2.x" => {
        "username" => "admin",
        "password" => "password"
    },
    "verifone verifone junior rev. 2.05" => {
        "username" => "(none)",
        "password" => "password"
    },
    "verilink ne6100-4 netengine rev. iad 3.4.8" => {
        "username" => "(none)",
        "password" => "password"
    },
    "virgin media netgear superhub" => {
        "username" => "admin",
        "password" => "password"
    },
    "visual networks visual uptime t1 csu/dsu rev. 1" => {
        "username" => "admin",
        "password" => "password"
    },
    "vonage d-link vta" => {
        "username" => "user",
        "password" => "password"
    },
    "vonage d-link vwr" => {
        "username" => "user",
        "password" => "password"
    },
    "vonage linksys pap2/pap2v2" => {
        "username" => "admin",
        "password" => "password"
    },
    "vonage linksys rt31p2" => {
        "username" => "admin",
        "password" => "password"
    },
    "vonage linksys rtp300" => {
        "username" => "admin",
        "password" => "password"
    },
    "vonage linksys wrt54gp2" => {
        "username" => "admin",
        "password" => "password"
    },
    "vonage linksys wrtp54g" => {
        "username" => "admin",
        "password" => "password"
    },
    "vonage motorola vt1005" => {
        "username" => "(blank)",
        "password" => "password"
    },
    "vonage motorola vt2142" => {
        "username" => "router",
        "password" => "password"
    },
    "vonage motorola vt2442" => {
        "username" => "router",
        "password" => "password"
    },
    "vonage motorola vt2542" => {
        "username" => "router",
        "password" => "password"
    },
    "vonage uniden uip1869v" => {
        "username" => "admin",
        "password" => "password"
    },
    "vonage v-tech ip8100" => {
        "username" => "VTech",
        "password" => "password"
    },
    "vonage cisco ata-186" => {
        "username" => "(blank)",
        "password" => "password"
    },
    "vonage vdv21-vd" => {
        "username" => "router",
        "password" => "password"
    },
    "vxworks misc" => {
        "username" => "admin",
        "password" => "password"
    },
    "vxworks misc" => {
        "username" => "guest",
        "password" => "password"
    },
    "wanadoo livebox" => {
        "username" => "admin",
        "password" => "password"
    },
    "wang wang" => {
        "username" => "CSG",
        "password" => "password"
    },
    "watchguard firebox 1000" => {
        "username" => "admin",
        "password" => "password"
    },
    "watchguard soho and soho6 rev. all versions" => {
        "username" => "user",
        "password" => "password"
    },
    "westell versalink 327" => {
        "username" => "admin",
        "password" => "password"
    },
    "westell wirespeed" => {
        "username" => "admin",
        "password" => "password"
    },
    "westell wang" => {
        "username" => "CSG",
        "password" => "password"
    },
    "westell wirespeed wireless router" => {
        "username" => "admin",
        "password" => "password"
    },
    "westell 2200" => {
        "username" => "admin",
        "password" => "password"
    },
    "wyse winterm rev. 5440xl" => {
        "username" => "root",
        "password" => "password"
    },
    "wyse winterm rev. 5440xl" => {
        "username" => "VNC",
        "password" => "password"
    },
    "wyse winterm rev. 9455xl" => {
        "username" => "(none)",
        "password" => "password"
    },
    "wyse winterm" => {
        "username" => "root",
        "password" => "password"
    },
    "wyse rapport rev. 4.4" => {
        "username" => "rapport",
        "password" => "password"
    },
    "wyse winterm 3150" => {
        "username" => "n/a",
        "password" => "password"
    },
    "x-micro x-micro wlan 11b broadband router rev. 1.2.2 1.2.2.3 1.2.2.4 1.6.0.0" => {
        "username" => "super",
        "password" => "password"
    },
    "x-micro x-micro wlan 11b broadband router rev. 1.6.0.1" => {
        "username" => "1502",
        "password" => "password"
    },
    "x-micro wlan 11b access point rev. 1.2.2" => {
        "username" => "super",
        "password" => "password"
    },
    "xavi 7000-aba-st1" => {
        "username" => "n/a",
        "password" => "password"
    },
    "xavi 7001" => {
        "username" => "n/a",
        "password" => "password"
    },
    "xd xdd rev. xddd" => {
        "username" => "xd",
        "password" => "password"
    },
    "xerox multi function equipment" => {
        "username" => "admin",
        "password" => "password"
    },
    "xerox workcenter pro 428" => {
        "username" => "admin",
        "password" => "password"
    },
    "xerox document centre 425" => {
        "username" => "admin",
        "password" => "password"
    },
    "xerox docucentre 425" => {
        "username" => "admin",
        "password" => "password"
    },
    "xerox document centre 405 rev. -" => {
        "username" => "admin",
        "password" => "password"
    },
    "xerox xerox" => {
        "username" => "admin",
        "password" => "password"
    },
    "xerox xerox" => {
        "username" => "n/a",
        "password" => "password"
    },
    "xerox work centre pro 35" => {
        "username" => "admin",
        "password" => "password"
    },
    "xylan omniswitch" => {
        "username" => "admin",
        "password" => "password"
    },
    "xylan omniswitch" => {
        "username" => "diag",
        "password" => "password"
    },
    "xylan omniswitch" => {
        "username" => "admin",
        "password" => "password"
    },
    "xyplex routers" => {
        "username" => "n/a",
        "password" => "password"
    },
    "xyplex terminal server" => {
        "username" => "n/a",
        "password" => "password"
    },
    "xyplex terminal server" => {
        "username" => "n/a",
        "password" => "password"
    },
    "xyplex routers" => {
        "username" => "n/a",
        "password" => "password"
    },
    "xyplex routers" => {
        "username" => "n/a",
        "password" => "password"
    },
    "xyplex terminal server" => {
        "username" => "n/a",
        "password" => "password"
    },
    "xyplex terminal server" => {
        "username" => "n/a",
        "password" => "password"
    },
    "xyplex switch rev. 3.2" => {
        "username" => "n/a",
        "password" => "password"
    },
    "yakumo routers" => {
        "username" => "admin",
        "password" => "password"
    },
    "zcom wireless" => {
        "username" => "root",
        "password" => "password"
    },
    "zebra 10/100 print server" => {
        "username" => "admin",
        "password" => "password"
    },
    "zoom zoom adsl modem" => {
        "username" => "admin",
        "password" => "password"
    },
    "zxdsl zxdsl 831" => {
        "username" => "ZXDSL",
        "password" => "password"
    },
    "zyxel prestige" => {
        "username" => "n/a",
        "password" => "password"
    },
    "zyxel prestige" => {
        "username" => "root",
        "password" => "password"
    },
    "zyxel prestige" => {
        "username" => "(none)",
        "password" => "password"
    },
    "zyxel prestige 643" => {
        "username" => "(none)",
        "password" => "password"
    },
    "zyxel prestige 652hw-31 adsl router" => {
        "username" => "admin",
        "password" => "password"
    },
    "zyxel prestige 100ih" => {
        "username" => "n/a",
        "password" => "password"
    },
    "zyxel prestige 650" => {
        "username" => "1234",
        "password" => "password"
    },
    "zyxel prestige 900" => {
        "username" => "webadmin",
        "password" => "password"
    },
    "zyxel prestige 645" => {
        "username" => "admin",
        "password" => "password"
    },
    "zyxel prestige p660hw" => {
        "username" => "admin",
        "password" => "password"
    },
    "zyxel zywall 2" => {
        "username" => "n/a",
        "password" => "password"
    },
    "zyxel adsl routers rev. all zynos firmwares" => {
        "username" => "admin",
        "password" => "password"
    },
    "zyxel prestige 660hw" => {
        "username" => "admin",
        "password" => "password"
    },
    "zyxel p-660hw-61 rev. prestige 660hw-61" => {
        "username" => "n/a",
        "password" => "password"
    },
    "zyxel zywall series prestige 660r-61c" => {
        "username" => "n/a",
        "password" => "password"
    },
);

triggers any => keys %routers, "default", "password";

zci is_cached => 1;
zci answer_type => "password";

handle query => sub {
    return unless my @matches = $_ =~
                  /
                   # default $brand password $model
                   # password $model password $brand
                   ^(?:(?:default|password)\ )(.+)(?:\ (?:default|password))(?:\ (.+))$
                   # default $router password
                   |^(?:(?:default|password)\ )(.+)(?:\ (?:default|password))$
                   # $router default password
                   # default password $router
                   |^(?:(.+)\ )?(?:default\ password|password\ default)(?:\ (.+))?$
                   # password $router
                   # $router password
                   |^(?:(.+)\ )?(?:password)(?:\ (.+))?$
                   # $router
                   |^(.+)$
                  /ix;
    @matches = map {lc} grep {defined} @matches;
    if (exists $matches[0] and $matches[1]) {
        push @matches, "$matches[0] $matches[1]";
        push @matches, "$matches[1] $matches[0]";
    }
    for my $router ( @matches ) {
        if (exists $routers{$router}) {
            my $username = $routers{$router}{"username"};
            my $password = $routers{$router}{"password"};
            $router = uc $router;
            return "Default login for the $router: "
                 . "Username: $username "
                 . "Password: $password",
                    html => "Default login for the $router:<br>"
                          . "<i>Username</i>: $username<br>"
                          . "<i>Password</i>: $password";
        }
    }
    return;
};

1;
