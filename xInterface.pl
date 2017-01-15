#!/usr/bin/perl -d
use Data::Dumper;
use XML::XPath;

my $xp = XML::XPath->new ("InterfaceList.xml");
my $family,
my $ip;
my @parts;
my @type;
my $hostname="roxbury-north.bonet.cityofboston.gov.";

foreach my $logical ($xp ->find('//logical-interface[address-family/address-family-name = "inet"]') ->get_nodelist) 
{
    my $interface = $logical ->find('name') ->string_value;
    @type = split(/\./,$interface);
    if ($type[0] ne "bme0" &&  $type[0] ne "jsrv" &&$type[0] ne "em0" &&$type[0] ne "em1")
    {
	foreach $ip ($logical ->find('address-family[address-family-name="inet"]/interface-address') ->get_nodelist) 
	{
	    my $address = $ip->find('ifa-local')->string_value;
	    @mask=split(/\//,$address);
	    @parts=split(/\./,$mask[0]);
	    $interface=~tr/\//-/s;
	    print "$parts[3].$parts[2].$parts[1].$parts[0].in-addr.arpa. \tIN PTR\t $interface.$hostname\n"
	}
    }
}
