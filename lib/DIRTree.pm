##########################################################################
#   
#   获取某目录下的所有文件路径
#   PATH 是绝对路径就返回绝对路径所有文件,相对就返回相对
#
#   @allfilepaths = DIRTree::getAllFilePaths( PATH ) ; 
#   @Author Qin Wei  
#
#   At Home Design @VERSION 0.0.2
#
package DIRTree;
@ISA = qw(Exporter);
@EXPORT = qw(getAllFilePaths);
my @ALL_FILES_LIST = ();
my $file_num = 0;
sub getAllFilePaths {
    my $url = shift;
    read_dir ( $url);
    return @ALL_FILES_LIST;
}
sub read_dir {
    my $url = shift;
    if ( -f $url) {
        push @ALL_FILES_LIST, $url;
        $file_num++;
    }
    if( -d $url ) {
        opendir DIR, $url;
        my @dirs = readdir DIR;
        close DIR;
        foreach $dir ( @dirs ) {
            if( $dir =~ /^\.$|^\.\.$/ ) {
                next;
            }
            read_dir($url."\\".$dir);
        }
    } 
}

1;
