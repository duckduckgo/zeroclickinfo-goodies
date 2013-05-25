package DDG::Goodie::Jira;
# ABSTRACT returns the URL of an Apache or Codehaus JIRA bug ticket according to its identifier

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => 'jira';

primary_example_queries 'ACE-230';
secondary_example_queries '[blah blah] ACE-230 [blah]';
description 'Track Apache JIRA bug tickets';
name 'Apache JIRA';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ApacheJIRA.pm';
category 'programming';
topics 'programming';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];

# Hash referencing Apache JIRA projects (KEY, PROJECT_NAME).
# reference: https://issues.apache.org/jira/secure/BrowseProjects.jspa#all
# A ticket identifier is formed by the key of the project and a number: KEY-NUMBER.

my %Apache_JIRA_projects = (
    # Ace
    "ACE", "ACE",

    # ActiveMQ
    "AMQ", "ActiveMQ",
    "AMQNET", "ActiveMQ .Net",
    "APLO", "ActiveMQ Apollo",
    "AMQCPP", "ActiveMQ C++ Client",
    "BLAZE", "ActiveRealTime",
    "STOMP", "Stomp Specification",

    # Ant
    "EASYANT", "EasyAnt",
    "IVY", "Ivy",
    "IVYDE", "IvyDE",

    # Any 23
    "ANY23", "Apache Any23",

    # Apache Software Foundation
    "ATTIC", "Attic",
    "COMDEV", "Community Development",
    "INFRA", "Infrastructure",
    "LEGAL", "Legal Discuss",
    "PRC", "Public Relations",

    # Aries
    "ARIES", "Aries",

    #Avro
    "AVRO", "Avro",

    #Axis
    "AXIS", "Axis",
    "AXISCPP", "Axis-C++",
    "AXIS2", "Axis2",
    "TRANSPORTS", "Axis2 Transports",
    "AXIS2C", "Axis2-C",
    "KAND", "Kandula",
    "RAMPART", "Rampart",
    "RAMPARTC", "Rampart/C",
    "Sandesha2", "SANDESHA2",
    "SAVAN", "Savan",

    # BigTop
    "BIGTOP", "BigTop",

    # Buildr
    "BUILDR", "Buildr",

    # BVal
    "BVAL", "BVal",

    # C++ Standard Library
    "STDCXX", "C++ Standard Library",

    # CAMEL
    "CAMEL", "Camel",

    # Cassandra
    "CASSANDRA", "Cassandra",

    # Cayenne
    "CAY", "Cayenne",

    # Chemistry
    "CMIS", "Chemistry",

    # CHUKWA
    "CHUKWA", "Chukwa",

    # CLICK
    "CLK", "Click",
    "CLKE", "Click Eclipse",

    # Cloudstack
    "CLOUDSTACK", "CloudStack",

    # Cocoon
    "COCOON", "Cocoon",
    "COCOON3", "Cocoon 3",

    # Commons
    "COMMONSSITE", "Commons All",
    "ATTRIBUTES", "Commons Attributes",
    "BCEL", "Commons BCEL",
    "BEANUTILS", "Commons BeanUtils",
    "BETWIXT", "Commons Betwixt",
    "BSF", "Commons BSF",
    "CHAIN", "Commons Chain",
    "CLI", "Commons CLI",
    "CODEC", "Commons Codec",
    "COLLECTIONS", "Commons Collections",
    "COMPRESS", "Commons Compress",
    "CONFIGURATION", "Commons Configuration",
    "CSV", "Commons CSV",
    "DAEMON", "Commons Daemon",
    "DBCP", "Commons DBCP",
    "DBUTILS", "Commons DbUtils",
    "DIGESTER", "Commons Digester",
    "DISCOVERY", "Discovery",
    "DORMANT", "Commons Dormant",
    "EL", "Commons EL",
    "EMAIL", "Commons Email",
    "EXEC", "Commons Exec",
    "FILEUPLOAD", "Commons FileUpload",
    "FUNCTOR", "Commons Functor",
    "IMAGING", "Commons Imaging",
    "IO", "Commons IO",
    "JCI", "Commons JCI",
    "JCS", "Commons JCS",
    "JELLY", "Commons Jelly",
    "JEXL", "Commons JEXL",
    "JXPATH", "Commons JXPath",
    "LANG", "Commons Lang",
    "LAUNCHER", "Commons Launcher",
    "LOGGING", "Commons Logging",
    "MATH", "Commons Math",
    "MODELER", "Commons Modeler",
    "NET", "Commons Net",
    "OGNL", "Commons OGNL",
    "POOL", "Commons Pool",
    "PRIMITIVES", "Commons Primitives",
    "PROXY", "Commons Proxy",
    "RESOURCES", "Commons Resources",
    "SANDBOX", "Commons Sandbox",
    "SANSELAN", "Commons Sanselan",
    "SCXML", "Commons SCXML",
    "TRANSACTION", "Commons Transaction",
    "VALIDATOR", "Commons Validator",
    "VFS", "Commons VFS",

    # Cordova
    "CB", "Apache Cordova",

    # CouchDB
    "COUCHDB", "CouchDB",

    #Creadur
    "RAT", "Apache Rat",
    "WHISKER", "Apache Whisker",

    # Crunch
    "CRUNCH", "Crunch",

    # CXF
    "CXF", "CXF",
    "DOSGI", "CXF Distributed OSGi",
    "FEDIZ", "CXF-Fediz",

    # DB
    "DDLUTILS", "DdlUtils",
    "DERBY", "Derby",
    "JDO", "JDO",
    "TORQUE", "Torque",
    "TORQUEOLD", "Torque issues (old)",

    # Directory
    "DIR", "Directory",
    "DIRSERVER", "Directory ApacheDS",
    "DIRAPI", "Directory Client API",
    "DIRGROOVY", "Directory Groovy LDAP",
    "DIRKRB", "Directory Kerberos",
    "DIRNAMING", "Directory Naming",
    "DIRSHARED", "Directory Shared",
    "DIRSTUDIO", "Directory Studio",
    "DIRTSEC", "Triplesec",

    # ESME
    "ESME", "Enterprise Social Messaging Environment",

    # Etch
    "ETCH", "Etch",

    # Felix
    "FELIX", "Felix",
 
    # FLUME
    "FLUME", "Flume",

    # Forrest
    "FOR", "Forrest",

    # Geronimo
    "DAYTRADER", "DayTrader",
    "GBUILD", "GBuild",
    "GERONIMO", "Geronimo",
    "GERONIMODEVTOOLS", "Geronimo-Devtools",
    "GSHELL", "GShell",
    "XBEAN", "XBean",
    "YOKO", "Yoko - CORBA Server",

    # Giraph
    "GIRAPH", "Giraph",
 
    # Gora
    "GORA", "Apache Gora",

    # Gump
    "GUMP", "Gump",

    # Hadoop
    "HADOOP", "Hadoop Common",
    "HDFS", "Hadoop HDFS",
    "MAPREDUCE", "Hadoop Map/Reduce",
    "YARN", "Hadoop YARN",
    "HBASE", "HBase",
    "HIVE", "Hive",
    "PIG", "Pig",
 
    # HAMA
    "HAMA", "Hama",

    # HTTP Server
    "MODPYTHON", "mod_python",

    # HttpComponents
    "HTTPASYNC", "HttpComponents HttpAsyncClient",
    "HTTPCLIENT", "HttpComponents HttpClient",
    "HTTPCORE", "HttpComponents HttpCore",

    # Incubator
    "AMBARI", "Ambari",
    "AMBER", "Amber",
    "AWF", "Apache AWF",
    "BLUR", "Apache Blur",
    "DIRECTMEMORY", "Apache DirectMemory",
    "DRILL", "Apache Drill",
    "HELIX", "Apache Helix",
    "S4", "Apache S4",
    "CELIX", "Celix",
    "CLEREZZA", "Clerezza",
    "CTAKES", "cTAKES",
    "DELTASPIKE", "DeltaSpike",
    "DMAP", "DeviceMap",
    "DROIDS", "Droids",
    "EMPIREDB", "Empire-DB",
    "FALCON", "Falcon",
    "HCATALOG", "HCatalog",
    "INCUBATOR", "Incubator",
    "JCLOUDS", "jclouds",
    "JSPWIKI", "JSPWiki",
    "KALUMET", "Kalumet",
    "KITTY", "Kitty",
    "LUCENENET", "Lucene.Net",
    "MARMOTTA", "Marmotta",
    "MESOS", "Mesos",
    "MRQL", "MRQL",
    "NPANDAY", "NPanday",
    "NUVEM", "Nuvem",
    "ODFTOOLKIT", "ODF Toolkit",
    "PODLINGNAMESEARCH", "Podling Suitable Names Search",
    "SIS", "Spatial Information Systems",
    "STANBOL", "Stanbol",
    "TASHI", "Tashi",
    "VCL", "VCL",
    "WOOKIE", "Wookie",
    "ZETACOMP", "Zeta Components",

    # Isis
    "ISIS", "Isis",

    # Jackrabbit
    "JCR", "Jackrabbit Content Repository",
    "JCRBENCH", "Jackrabbit JCR Benchmark",
    "JCRCL", "Jackrabbit JCR Classloader",
    "JCRSERVLET", "Jackrabbit JCR Servlets",
    "JCRTCK", "Jackrabbit JCR Tests",
    "JCRRMI", "Jackrabbit JCR-RMI",
    "OAK", "Jackrabbot Oak",
    "OCM", "Jackrabbit OCM",
    "JCRSITE", "Jackrabbit Site",

    # James
    "IMAP", "James Imap",
    "JSIEVE", "James jSieve",
    "JSPF", "James jSPF",
    "MAILET", "James Mailet",
    "MIME4J", "James Mime4j",
    "MPT", "James MPT",
    "POSTAGE", "James Postage",
    "PROTOCOLS", "James Protocols",
    "JAMES", "James Server",

    # Jena
    "JENA", "Apache Jena",

    # jUDDI
    "JUDDI", "jUDDI",
    "SCOUT", "Scout",

    # KAFKA
    "KAFKA", "Kafka",

    # Karaf
    "KARAF", "Karaf",

    # Labs
    "LABS", "Labs",
    "HTTPDRAFT", "Labs WebArch draft-fielding-http",

    # Libcloud
    "LIBCLOUD", "Libcloud",

    # Logging
    "LOGCXX", "Log4cxx",
    "LOG4J2", "Log4j2",
    "LOG4NET", "Log4net",
    "LOG4PHP", "Log4php",

    # LUCENE
    "LUCENE", "Lucene - Core",
    "LUCY", "Lucy",
    "MAHOUT", "Mahout",
    "ORP", "Open Relevance Project",
    "PyLucene", "PyLucene",
    "SOLR", "Solr",

    # ManifoldCF
    "CONNECTORS", "ManifoldCF",

    # Maven
    "MPOM", "Maven POMs",

    # MINA
    "ASYNCWEB", "Asyncweb",
    "FTPSERVER", "FtpServer",
    "DIRMINA", "MINA",
    "SSHD", "MINA SSHD",
    "VYSPER", "VYSPER",

    # MRUNIT
    "MRUNIT", "MRUnit",

    # MyFaces
    "ADFFACES", "MyFaces ADF-Faces",
    "EXTCDI", "MyFaces CODI",
    "MFCOMMONS", "MyFaces Commons",
    "MYFACES", "MyFaces Core",
    "EXTSCRIPT", "MyFaces Extensions Scripting",
    "EXTVAL", "MyFaces Core",

    # More to come  
);

my %Codehaus_JIRA_projects = (
  "TEST", "Test",

  # More to come
);

triggers query => qr/^(.*\s)*([A-Z0-9]{2,}\-[\d]{1,})\s*(.*)$/i;

handle query => sub {

    my $bugticket = $2 || '';

    my $project_key = '';
    my $ticket_id = '';
    
    my $apache_project_name = '';
    my $codehaus_project_name = '';
   
    # Online JIRA Bugtrackers
    my $is_apache = 0;   # issues.apache.org/jira
    my $is_codehaus = 0; # jira.codehaus.org

    my $html_return = '';

    # Check the project key is valid.
    if ($bugticket =~ m/([A-Z0-9]{2,})\-([\d]{1,})/){
      $project_key = $1;
      $ticket_id = $2;
      
    }
    
    # Check the project key is valid
    if ($ticket_id and $project_key){
    
      $is_apache = 1 if $apache_project_name = $Apache_JIRA_projects{$project_key};
      $is_codehaus = 1 if $codehaus_project_name = $Codehaus_JIRA_projects{$project_key};
 
    }

    if ($is_apache || $is_codehaus){

        $html_return .= qq($apache_project_name on Apache JIRA Bugtracker: see ticket <a href="https://issues.apache.org/jira/browse/$bugticket">$bugticket</a>.<br>) if $is_apache;;
        $html_return .= qq($codehaus_project_name on Codehaus JIRA Bugtracker: see ticket <a href="https://jira.codehaus.org/browse/$bugticket">$bugticket</a>.) if $is_codehaus;;
        return $bugticket, heading => 'JIRA Bugtracker', html => $html_return;
    }

    return;
};

1;
