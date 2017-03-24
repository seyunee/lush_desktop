<? 
	session_start(); 
    @extract($_POST);
    @extract($_GET);
    @extract($_SESSION);
    
    include "../lib/dbconn.php";

    
    if ($no)
	{
	   $sql = "select * from board where no=$no";
       $result = mysql_query($sql, $connect);

        $row = mysql_fetch_array($result);       
          // 하나의 레코드 가져오기

        $item_no     = $row[no];
        $item_email    = $row[email];
        $item_title    = str_replace(" ", "&nbsp;", $row[title]);
        $item_content    = str_replace(" ", "&nbsp;", $row[content]);
        $item_content    = str_replace("<br>", "\n", $row[content]);

	}else{
         echo("
           <script>
             window.alert('글번호 없움');
           </script>
         ");
    }
	


?>
<!doctype html>
<html lang="ko">
 <head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width,initial-scale=1.0">

	<title>LUSH KOREA-View</title>
	<script src="http://code.jquery.com/jquery-1.10.2.min.js "></script>
	<script src="../lib/common.js"></script>
	<link href="../css/lush.css" rel="stylesheet" type="text/css">

  <script>
  $(document).ready(function(){

  })
  </script>

 </head>
<body>
    <!--    header-->
    <? include "../include/sub_header.html" ?>
    <!--   // header-->
	<section class="review">
    <h2>REVIEW</h2>
    <div class="container">
     <form  name="board_form" method="post" action="insert.php?page=<?=$page?>"> 
         <input type="hidden" name="no" value="<?=$item_no ?>">
		<table class="write_form">
            <tbody>
               <tr>
				    <th> WRITER </th>
				    <td><?=$s_fname?></td>
				</tr>
				<tr>
				    <th> TITLE </th>
				    <td><input type="text" name="title" value="<?=$item_title ?>"></td>
				</tr>
				<tr>
				    <th> CONTENT </th>
				    <td><textarea name="content"><?=$item_content ?></textarea></td>
				</tr>
           </tbody>
		</table>
		<div class="btns">
		    <input type="button" value="CANCEL" class="btn_cancel" onclick="location:history.go(-1)">
		    <input type="submit" value="COMPLETE" class="btn_cpl">
        </div>
		</form>
    </div>
	</section>
	<!--    footer-->
    <? include "../include/sub_footer.html" ?>
    <!--   // footer-->
</body>
</html>
