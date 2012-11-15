use strict;
use warnings;
use ExtUtils::MakeMaker;


WriteMakefile(
    NAME            => 'netsnmp-pcap-perl',
    LICENSE         => 'gpl',
    AUTHOR          => 'Sebastien Aperghis-Tramoni <sebastien@aperghis.net>',
    VERSION_FROM    => 'bin/netsnmp-pcap',
    ABSTRACT_FROM   => 'bin/netsnmp-pcap',
    EXE_FILES       => [ 'bin/netsnmp-pcap' ],
    PREREQ_PM => {
        # prereqs
        'Getopt::Long'                  => 0,
        'Net::Pcap',                    => 0,
        'NetSNMP::agent',               => 0,
        'NetSNMP::ASN',                 => 0,
        'POE'                           => 0,
        'POE::Component::NetSNMP::agent'=> '0.400',
        'POE::Component::Pcap'          => 0,
        'Proc::Daemon'                  => 0,
        'Pod::Usage'                    => 0,
        'SNMP::ToolBox'                 => '0.03',
        'Sys::Syslog'                   => 0,

        # build/test prereqs
        'Test::More'                    => '0.45',
    },
    postamble       => {
        files       => {
            'etc/pcap.conf' => '$(PREFIX)/etc/snmp/pcap.sample.conf',
        },
    },
    PL_FILES        => {},
    dist            => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean           => { FILES => 'netsnmp-pcap-perl-*' },
);


sub MY::postamble {
    my ($mm, %args) = @_;
    my $postamble = "";

    # install data files (in /etc, /usr/share, ...)
    # first, we must add a target in install::
    for my $makeline (@{ $mm->{RESULT} }) {
        $makeline =~ s/(install *::.+)\n/$1 priv_data_files\n/;
    }

    # then, declare the target with the files
    $postamble .= "\nINSTALL = install -d -p\n\npriv_data_files:\n";

    while (my($file,$target) = each %{ $args{files} }) {
        $postamble .= "\t\$(INSTALL) $file $target\n";
    }

    return $postamble
}

