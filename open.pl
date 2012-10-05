unshift @INC, ".\\lib";
use utf8;
use Encode;
require DIRTree;
my %TYPES = ();
my @ALL_FILES_PATH = DIRTree::getAllFilePaths('F:\Perl-work');
my $type = '';
foreach my $url ( @ALL_FILES_PATH ) {
    print $url."\n";
    $url =~ /\.([^\.]*)$/; 
    $type = $1;
    print $type."\n";
    $TYPES{$type}++;
}
while(my ($_type, $num) = each(%TYPES)){
    print $_type.":$num\n";
}
