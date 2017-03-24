<? 
	session_start(); 
    @extract($_GET); 
      @extract($_POST); 
      @extract($_SESSION); 

	include "../lib/dbconn.php";

	$sql = "select * from board where no=$no";
	$result = mysql_query($sql, $connect);

    $row = mysql_fetch_array($result);       
      // 하나의 레코드 가져오기
	
	$item_no     = $row[no];
	$item_email    = $row[email];
	$item_fname    = $row[fname];
  	$item_title    = str_replace(" ", "&nbsp;", $row[title]);
  	$item_content    = str_replace(" ", "&nbsp;", $row[content]);
	$item_hits     = $row[hits];
    $item_date    =date("Y-m-d",strtotime( $row[regist_day]));

	$new_hit = $item_hits + 1;

	$sql = "update board set hits=$new_hit where no=$no";   // 글 조회수 증가시킴
	mysql_query($sql, $connect);
?>
<!doctype html>
<html>
<head> 
<meta charset="utf-8">
<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">

	<title>LUSH KOREA-View</title>
	<script src="http://code.jquery.com/jquery-1.10.2.min.js "></script>
	<script src="../lib/common.js"></script>
	<link href="../css/lush.css" rel="stylesheet" type="text/css">
<script>
    function del(href) 
    {
        if(confirm("한번 삭제한 자료는 복구할 방법이 없습니다.\n\n정말 삭제하시겠습니까?")) {
                document.location.href = href;
        }
    }
</script>
</head>

<body>
    
    <!--    header-->
    <? include "../include/sub_header.html" ?>
    <!--   // header-->
	<section class="review">
    <h2>REVIEW</h2>
    <div class="container">
        <input type="hidden" name="no">
		<table class="write_view">
            <tbody>
               <tr class="write_data">
                    <th> TITLE </th>
                    <td><?=$item_title?></td>
                    <th> WRITER </th>
                    <td><?=$item_fname?></td>
                    <th> DATE </th>
                    <td><?= $item_date ?></td>
                    <th> HITS </th>
                    <td><?=$item_hits?></td>
				</tr>
				<tr class="write_content">
				    <td colspan="8"><?=$item_content?></td>
				</tr>
           </tbody>
		</table>
		<div class="btns">
         <form  name="board_form" method="post" action="review_form.php?page=<?=$page?>"> 
        <? 
            if($s_email==$item_email || $s_email=="admin")
            {
        ?>
           
            <input type="hidden" name="no" value="<?=$item_no?>">
            <input type="submit" value="MODIFY" class="btn_cpl">
            <input type="button" value="DELETE" class="btn_del"  onclick="location.href='delete.php?no=<?=$no?>'">

        <?
            }else if($s_email){
        ?>
            <a href="review_form.php"><img src="../img/write.png"></a>
        <?
            }
        ?>
		    <input type="button" value="LIST" class="btn_cancel" onclick="location:history.go(-1)">
            </form>
        </div>
    </div>
	</section>
	<!--    footer-->
    <? include "../include/sub_footer.html" ?>
    <!--   // footer-->

</body>
</html>
