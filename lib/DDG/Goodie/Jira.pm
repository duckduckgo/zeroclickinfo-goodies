package DDG::Goodie::Jira;
# ABSTRACT returns the URL of an Apache or Codehaus JIRA bug ticket according to its identifier

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => 'jira';

primary_example_queries 'ACE-230';
secondary_example_queries '[blah blah] ACE-230 [blah]';
description 'Track Apache and Codehaus JIRA bug tickets';
name 'Jira';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Jira.pm';
category 'programming';
topics 'programming';
attribution github => [ 'https://github.com/arroway', 'arroway'],
            twitter => ['http://twitter.com/steph_ouillon', 'steph_ouillon'];

# Referencing Apache JIRA project keys.
# reference: https://issues.apache.org/jira/secure/BrowseProjects.jspa#all
# A ticket identifier is formed by the key of the project and a number: KEY-NUMBER.
my $Apache_JIRA_projects = qr/ACE|AMQ|AMQNET|APLO|AMQCPP|BLAZE|STOMP|EASYANT|IVY|IVYDE|ANY23|ATTIC|COMDEV|INFRA|LEGAL|PRC|ARIES|AVRO|AXIS|AXISCPP|AXIS2|TRANSPORTS|AXIS2C|KAND|RAMPART|RAMPARTC|SAND|SANDESHA2|SANDESHA2C|SAVAN|BIGTOP|BUILDR|BVAL|STDCXX|CAMEL|CASSANDRA|CAY|CMIS|CHUKWA|CLK|CLKE|CLOUDSTACK|COCOON|COCOON3|COMMONSSITE|ATTRIBUTES|BCEL|BEANUTILS|BETWIXT|BSF|CHAIN|CLI|CODEC|COLLECTIONS|COMPRESS|CONFIGURATION|CSV|DAEMON|DBCP|DBUTILS|DIGESTER|DISCOVERY|DORMANT|EL|EMAIL|EXEC|FILEUPLOAD|FUNCTOR|IMAGING|IO|JCI|JCS|JELLY|JEXL|JXPATH|LANG|LAUNCHER|LOGGING|MATH|MODELER|NET|OGNL|POOL|PRIMITIVES|PROXY|RESOURCES|SANDBOX|SANSELAN|SCXML|TRANSACTION|VALIDATOR|VFS|CB|COUCHDB|RAT|WHISKER|CRUNCH|CXF|DOSGI|FEDIZ|DDLUTILS|DERBY|JDO|TORQUE|TORQUEOLD|DIR|DIRSERVER|DIRAPI|DIRGROOVY|DIRKRB|DIRNAMING|DIRSHARED|DIRSTUDIO|DIRTSEC|ESME|ETCH|FELIX|FLUME|FOR|DAYTRADER|GBUILD|GERONIMO|GERONIMODEVTOOLS|GSHELL|XBEAN|YOKO|GIRAPH|GORA|GUMP|HADOOP|HDFS|MAPREDUCE|YARN|HBASE|HIVE|PIG|HAMA|MODPYTHON|HTTPASYNC|HTTPCLIENT|HTTPCORE|AMBARI|AMBER|AWF|BLUR|DIRECTMEMORY|DRILL|HELIX|S4|CELIX|CLEREZZA|CTAKES|DELTASPIKE|DMAP|DROIDS|EMPIREDB|FALCON|HCATALOG|INCUBATOR|JCLOUDS|JSPWIKI|KALUMET|KITTY|LUCENENET|MARMOTTA|MESOS|MRQL|NPANDAY|NUVEM|ODFTOOLKIT|PODLINGNAMESEARCH|SIS|STANBOL|TASHI|VCL|WOOKIE|ZETACOMP|ISIS|JCR|JCRBENCH|JCRCL|JCRSERVLET|JCRTCK|JCRRMI|OAK|OCM|JCRSITE|IMAP|JSIEVE|JSPF|MAILET|MIME4J|MPT|POSTAGE|PROTOCOLS|JAMES|JENA|JUDDI|SCOUT|KAFKA|KARAF|LABS|HTTPDRAFT|LIBCLOUD|LOGCXX|LOG4J2|LOG4NET|LOG4PHP|LUCENE|LUCY|MAHOUT|ORP|PYLUCENE|SOLR|CONNECTORS|MPOM|ASYNCWEB|FTPSERVER|DIRMINA|SSHD|VYSPER|MRUNIT|ADFFACES|EXTCDI|MFCOMMONS|MYFACES|EXTSCRIPT|EXTVAL|MFHTML5|ORCHESTRA|PORTLETBRIDGE|MYFACESTEST|TOBAGO|TOMAHAWK|TRINIDAD|NUTCH|ODE|OFBIZ|OODT|OOZIE|OPENEJB|OEP|TOMEE|OPENJPA|OPENMEETINGS|OPENNLP|OWB|PDFBOX|PIVOT|JS1|JS2|PLUTO|PORTALS|APA|PB|QPID|PROTON|AGILA|ADDR|ALOIS|ARMI|AVALON|AVNSHARP|RUNTIME|STUDIO|CENTRAL|PLANET|TOOLS|WSIF|BEEHIVE|BLUESKY|CACTUS|FEEDPARSER|DEPOT|ECS|EWS|EXLBR|FORTRESS|GRFT|HARMONY|HERALDRY|HISE|HIVEMIND|IBATISNET|IBATIS|RBATIS|IMPERIUS|JAXME|JSEC|KATO|KI|LOKAHI|LCN4C|MIRAE|MUSE|OJB|OLIO|PNIX|PHOTARK|HERMES|SMX4KNL|SHALE|SOAP|STONEHENGE|TRIPLES|TSIK|WADI|APOLLO|WSRP4J|XAP|RIVER|ROL|SM|SMX4|SMXCOMP|SMX4NMR|SHINDIG|SHIRO|SLING|SQOOP|STR|WW|SB|SITE|XW|SYNAPSE|SYNCOPE|TAPESTRY|TAP5|THRIFT|TIKA|TILES|AUTOTAG|TEVAL|TREQ|TILESSB|TILESSHARED|TILESSHOW|TS|TRB|TUSCANY|UIMA|ANAKIA|DBF|DVSL|TEXEN|VELOCITY|VELOCITYSB|VELTOOLS|AXIOM|NEETHI|WODEN|WSCOMMONS|WSS|XMLRPC|XMLSCHEMA|WHIRR|WICKET|XALANC|XALANJ|XERCESC|XERCESP|XERCESJ|XMLCOMMONS|XMLBEANS|ZOOKEEPER/i;

# Referencing Codehaus JIRA project keys.
# reference: http://jira.codehaus.org/secure/BrowseProjects.jspa#all
# A ticket identifier is formed by the key of the project and a number: KEY-NUMBER.
my $Codehaus_JIRA_projects = qr/AJLIB|AW|AWARE|NAN|OSLO|DNA|EOB|GRAILS|JCT|LOOM|NANO|PICO|PLX|PLXCOMP|PLXUTILS|DISPL|GBEAN|LIVETRIBE|GEO|GEOS|GEOT|UDIG|BOO|GROOVY|MMLD|MPABBOT|MPANNOUNCEMENT|MPANT|MPANTLR|MPGENAPP|MPAPPSERVER|MPARTIFACT|MPASHKELON|MPASPECTJ|MPASPECTWERKZ|MPCALLER|MPCASTOR|MPCHANGELOG|MPCHANGES|MPCHECKSTYLE|MPCLEAN|MPCLOVER|MPCONSOLE|MPCRUISECONTROL|MPDASHBOARD|MPDEVACTIVITY|MPDIST|MPDOCBOOK|MPEAR|MPECLIPSE|MPEJB|MPFAQ|MPFILEACTIVITY|MPGUMP|MPHIBERNATE|MPHTMLXDOC|MPIDEA|MPJEE|MPJALOPY|MPJAR|MPJAVA|MPJAVACC|MPJAVADOC|MPJBOSS|MPJBUILDER|MPJCOVERAGE|MPJDEE|MPJDEPEND|MPJDEVELOPER|MPJDIFF|MPJELLYDOC|MPJETTY|MPJIRA|MPJNLP|MPJUNITREPORT|MPJUNITDOCLET|MPJXR|MPLATEX|MPLATKA|MPLICENSE|MPLINKCHECK|MPMODELLO|MPMULTIPROJECT|MPMULTICHANGES|MPNATIVE|MPNSIS|MPPDF|MPPLUGIN|MPPMD|MPPOM|MPRAR|MPRELEASE|MPREPO|MPSCM|MPSHELL|MPSIMIAN|MPSITE|MPSOURCE|MPSTRUTS|MPTASKLIST|MPTEST|MPTJDO|MPUBERJAR|MPVDOCLET|MPWAR|MPWEBSERVER|MPWIZARD|MPXDOC|GMAVEN|MGROOVY|MHIBERNATE|MJAXB|MDEPLOY|MGPG|MSITE|MANT|MANTLR|MANTLRTHREE|MANTRUN|MASSEMBLY|MAXISTOOLS|MBUILDHELPER|MCASTOR|MCHANGELOG|MCHANGES|MCHECKSTYLE|MCLEAN|MCLIRR|MCOBERTURA|MCOMATTR|MCOMPILER|MIDLJ|MDEP|MDOAP|MDOCCK|MEAR|MECLIPSE|MEJB|MENFORCER|MEXEC|MFINDBUGS|MFIT|MFITNESSE|MGAE|MPH|MIDEA|MINSTALL|MINVOKER|MJAR|MJARSIGNER|MJAVACC|MJAVADOC|MJNCSS|MJBOSSPACK|MJBOSS|MJDIFF|MJPOX|MJSPC|MKEYTOOL|MLINKCHECK|MNETBEANSFREEFORM|MONE|MOUNCE|MPATCH|MPDF|MPLUGIN|MPMD|MPIR|MRAR|MREACTOR|MRELEASE|MRRESOURCES|MREPOSITORY|MRESOURCES|MRETRO|MRMIC|MSABLECC|MSCMCHGLOG|MSELENIUM|MSHADE|MSHITTY|MSOURCES|MSQL|MSTAGE|MTAGLIST|MTOOLCHAINS|MVERIFIER|MVERSIONS|MWAR|MWAS|MWEBSTART|MWEBTEST|MXMLBEANS|MACR|MGWT|MJS|MNBMODULE|MSCMPUB|MOJO|MANIMALSNIFFER|MAPPASM|MASPECTJ|MBUILDNUM|CBUILDS|MEMMA|MJSIMP|MLATEX|MRPM|MSQLJ|MSYSDEO|MWEBMINI|MCASSANDRA|MCHRONOS|MJSLINT|MLICENSE|MMOCKRM|MSONAR|MNGBOOK|MEV|MNGFAQ|MPA|MNGSITE|MAVENUPLOAD|MPOM|MRM|MAVEN|MNG|MANTTASKS|MPLUGINTESTING|MSANDBOX|ARCHETYPE|MARCHETYPES|DOXIA|DOXIASITETOOLS|DOXIATOOLS|MINDEXER|MNGECLIPSE|JXR|SCM|MSHARED|MSKINS|SUREFIRE|WAGON|MAVENPROXY|MERCURY|MEVENIDE|MNGTEST|NMAVEN|PROFICIO|CASTOR|DATAFORGE|JIBX|PRV|XSTR|XPR|ASH|CONTINUUM|DC|JBEHAVE|QUILT|SYSUNIT|FAQBOT|OXYD|SONAR|SONARDOTNT|SONARIDE|SONARJAVA|SONARJNKNS|SONARPLUGINS|XDOCLET|XDP|ACT|AWN|VIXTORY|STORIES|AGILIFIER|ANDROMDA|ANNOGEN|ANTOMOLOGY|APPINFO|ATOMSERVER|BP|BENJI|BERKANO|BLISSED|BRUCE|BTM|CAKE|CARGO|CHEN|CLASSWORLDS|COCACHE|COM|CJCOOK|MAP|CONSTELLATION|CUANTO|DACCO|DAVOS|DBUNIT|DENTAKU|DFORMS|DIMPLE|DW|DRONE|DROOLS|DROOLSDOTNET|DH|DYNJS|EASYOVF|EASYMOCK|EDUS|EINSTEIN|ENUNCIATE|ERA|ESPER|EUREKAJ|FABRICTHREE|FCBK|FEST|FITWEB|FOCI|GABRIEL|GANT|GEB|GEMS|GENCORE|GRA|GREPO|GEOBATCH|GEOTRACING|GLDP|GPARS|GP|GFS|GLOG|GRAILSPLUGINS|GRAPHPROC|GRECLIPSE|GREENMAIL|GRIFFON|GCIDE|GMOD|GFX|GRUPLE|GUESSENC|GUFF|GUMTREE|GWTOPENLAYERS|HAUS|HAUSMOB|HTCJ|HYDRACACHE|HJ|IDEACLEARCASE|IDEAJUNIT|IOKE|IUI|IVYNET|IZPACK|JSQL|JACKSON|JANINO|JASKELL|VG|JAVANCSS|JSDI|JAVASIM|JAXBITTY|JAXEN|JW|JBL|JCSP|JDBI|JDBM|JEDI|JEQUEL|JET|JETTISON|JETTY|JFDI|JGEOCODER|JIBE|JMETERPLUGIN|JPARSEC|JR|JRUBY|JSTR|JSEC|JSRCONCURRENCYMIRROR|JTESTME|JTESTR|JTSTAND|JVALIDATIONS|KEWLANG|KEYMG|KOLJA|LABSNG|LAREX|LINGO|LITHA|LOGICABYSS|MAPFACES|MARCH|MARNET|MNGIDEA|MOPENJPA|MTOMCAT|MUNIX|MVNBLAME|MVNCONFSITE|MDBUNIT|MAVENENTERPRISE|PSEUDOTRANS|MDWEB|MSR|METAPP|MRP|META|MICRO|MICROMEETING|MIDDLEGEN|MILYN|MINGLYN|MOCKINJECT|MODFORJ|MODELLO|MWEBLOGIC|MSITESKIN|MTRUEZIP|MULTIVERSE|MVEL|MVFLEX|MYTIMES|NANOIOC|NANOWAR|NANOPERSISTENCE|NANOREMOTING|NANOSANDBOX|NANOTOOLS|NEO|NEST|OAUTHSS|OORT|OPENEMPI|OPENEJB|OPENIM|OPENPIPELINE|OPENTCDB|OPENXMA|OXFJORD|PARANAMER|PASSERELLE|PERFFORJ|PERPETUUM|PHYSIOME|PICOBOOK|PICOPLUGINS|PICOUNIT|PININ|PLJ|PLATYPUS|PLXASRVR|POLYMAP|PREON|PROM|PROPHIT|PTOYS|PUZZLEGIS|QDOX|QIXWEB|QUAERE|REDBACK|RUBYRULES|RVM|SVNA|SCRUMTIME|SENRO|SERVICECONDUIT|SERVICESTUDIO|SETPOINT|SHOCKS|SIMJP|SSSO|SXC|SIPO|SOT|SPICE|SQUIGGLE|STAX|STAXMATE|STOMP|SVNJ|SWIBY|SWIZZLE|SYMMETRICDS|TEST|TESTORIENTED|TESTDOX|TIX|TIMTAM|TRAILS|TQL|TYNAMO|UISPEC|UMP|WADI|WAFFLE|WERKFLOW|WERKZ|WSTX|XTENLANG|XB|XDASJ|XFIRE|XHARNESS|XJB|XLITE|XEVPP|XSITE|XULUX|XWIRE|YAGLL|YAN|YFACES|YUMAFRAMEWORK|ZONEINFOTZ/i;

triggers query => qr/^(.*\s)*($Apache_JIRA_projects\-[\d]{1,})\s*(.*)$|^(.*\s)*($Codehaus_JIRA_projects\-[\d]{1,})\s*(.*)$/i;

handle query => sub {

    my $apacheTicket = $2 || '';
    my $codehausTicket = $5 || '';

    my $html_return = '';

    if ($apacheTicket || $codehausTicket){

	# Dealing with the case where two projects on different bugtrackers have the same project key
        $html_return .= qq(Apache JIRA Bugtracker: see ticket <a href="https://issues.apache.org/jira/browse/$apacheTicket">$apacheTicket</a>.<br>) if $apacheTicket;
        $html_return .= qq(Codehaus JIRA Bugtracker: see ticket <a href="https://jira.codehaus.org/browse/$codehausTicket">$codehausTicket</a>.) if $codehausTicket;
        return '', heading => 'JIRA Bugtracker', html => $html_return;
    }

    return;
};

1;
