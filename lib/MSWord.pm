package MSWord;
@ISA = qw( Exporter );
@EXPORT = qw (getContent append close);
use Win32::OLE;
use Win32::OLE::Const 'Microsoft Word';
my $WORD = CreateObject Win32::OLE 'Word.Application' or die $!;

sub new {
    my $type = shift;
    my %option = @_;
    my $this = {};
    if( defined $option{'Visible'} ) {
       $WORD->{'Visible'} = $option{'Visible'};
    }else {
        $WORD->{'Visible'} = 0;
    }
    bless $this;
    return $this;
}

sub open {
    shift;
    my $document = $WORD->Documents->Open( shift );
    return $document;
}

#===================================
# 获取内容
# 参数: 路径
#
sub getContent {
    shift;
    my $content = '';
    my $document = shift;
    my $paragraph_count = $document->Paragraphs->Count;
    my $num = 1;
    my $myrange;
    my $paragraphs;
    while ( $num <= $paragraph_count ){
        $paragraphs = $document->Paragraphs( $num );
        $myrange = $paragraphs->range;
        $content .= $myrange->Text;
        $num++;
    }
    $content =~ s/\r/\n/g;
    pos( $ocntent ) = 0;
    return $content;

}


sub append {
    shift;
    use utf8;
    use Encode;
    my $document = shift;
    $document->Sections->Last->Range->InsertAfter(  shift  );
}

sub close {
    $WORD->quit();
}


1;

__END__

#----------------------------------------  开发说明 -------------------------------------------- 
# OLE方法操作Word的封装类
# 
# 说 明: 一般我们用Perl操作Word, Excel, 其实不想去考虑怎么打开,其间创建了什么对象,用了多少方式
#       打开它们, 我们只关心获得数据后的处理, 此类的目的是封装OLE, VBA提供操作Word的方法, 
#       提供简便获取Word内容, 简单操作文档接口, 更复杂的操作请使用完整OLE并且参考VBA提供的
#       接口. 封装的优点是获取内容简单, 缺点定是不支持复杂地操作文档内容
# 
# 目 的: 创建本封装类的目的就是简单获取word内容, 让开发人员专注于对获得内容的处理 
#
# 建 议: OLE只能是在Windows下利用OLE机制, 在已安装word的机子上操作, 实际上是自动化的一个实现, 
#       在未装Word的机子 或者在Linux下, 都不能使用该方法.
#       不要使用OLE直接操作Word, Excel文档, 不实用,在Perl界也不提倡.知道怎么获取数据,简单处理
#       数据就好了, 过于复杂的word操作, 不如考虑用别的方式, 比如使用Word的宏 
#
# 
# 使用方法如下:
#


use utf8;
require "MSWord.pl";
my $word = new MSWord( "Visible" => 1 ); # 创建Word操作对象, 如果没有,默认情况下是隐式打开的
my $document1 = $word->open("F:\\Perl-work\\Word\\aaa.doc");  # 用Word打开文档1, 返回该文档对象, 需要绝对路径
my $document2 = $word->open("F:\\Perl-work\\Word\\xxx.doc");  # 用Word打开文档2
$word->append( $document1, "are you ok?" ); # word操作, 向文档1末尾添加数据, 需要传递一个文档对象,告诉word操作哪个文档
my $content = $word->getContent( $document2 ); # Word操作, 获取文档2的所有内容
$document1->save(); # OLE提供的保存方法, 该$document是OLE实例对象,方法是OLE通过VBA提供
open FILE, ">bbb.txt";
print FILE $content;
close FILE;
$word->close();
