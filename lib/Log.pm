#----------------------------------------------------
# Log 日志记录
# 用法:
# log "this is log";
# STDOUT输出:
# this is log
# 并且会记录入log日志到logs目录中
#
use Encode;
use utf8;
sub Log {
   my $message = shift;
   my $filename = shift || "logs";
   my ($sec, $minu, $hour, $date, $mon, $year) = gmtime();
   $message = Encode::is_utf8( $message ) ? encode("gbk", $message) : $message;
   Encode::_utf8_off($message); #关闭utf8标记,才不会在window出现Wide....
   print $message."\n";
   open LOG, ">>.\\Logs\\$mon-$date-$filename.log";     
   print LOG  $message."\n";
   close LOG;
}
package Log;
use Cwd;
my $_LOG_PATH = getcwd;
mkdir($_lOG_PATH.'\Logs');

1;
