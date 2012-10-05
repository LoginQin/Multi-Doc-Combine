use utf8;
unshift @INC, ".\\lib";
use Cwd;
use Win32::OLE;
use Win32::OLE::Const;
use Encode;
require DIRTree;
require Log;
$PATH = getcwd;
$COMBINE_PATH = $ARGV[0] || encode("gbk", 'F:\Perl-work\Word\app');
@FILE_PATHS = DIRTree::getAllFilePaths($COMBINE_PATH);
$CONST = Win32::OLE::Const->Load('Microsoft Word');
$word = Win32::OLE->new('Word.Application') or die $!;
$word->{'Visible'} = 0;
$wordfile = 0;
my $document = $word->Documents->Add;
my $selection = $word->Selection;
foreach $url ( @FILE_PATHS ) {
    if ($url !~ /\.doc$/){
        next;
    } 
    Log("\nCombine File: $url\n");
    $selection->InsertFile({'FileName'=> $url });
    $selection->InsertBreak($CONST->{wdPageBreak});
    $wordfile++;
        
}
my $word_nums = $document->Range->ComputeStatistics($CONST->{wdStatisticWords}); #字数
my $chinese_words = $document->Range->ComputeStatistics($CONST->{wdStatisticFarEastCharacters});#中文字符数
my $pages = $document->Range->ComputeStatistics($CONST->{wdStatisticPages}); #页数

my $save_path = $ARGV[1] || encode('gbk', "$PATH\\多合一文档.doc");
#如果只简单的保存为文件名,如果不使用wdFormatDocument, 文档会损坏
$document->SaveAS({'FileName' => $save_path, 'FileFormat'=>$CONST->{wdFormatDocument}});
$word->quit();

$log = <<log;
#####################################################
#  
#  MS Word  Fils:                    $wordfile
#  Total  Pages :                    $pages
#  Chinese Words:                    $chinese_words
#  Total  Words :                    $word_nums
#
#  Save To      :                    $save_path
#
####################################################
log
Log($log);

