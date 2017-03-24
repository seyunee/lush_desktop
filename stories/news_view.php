<? 
	session_start(); 
    @extract($_GET); 
    @extract($_POST); 
    @extract($_SESSION); 

	include "../lib/dbconn.php";

	$sql = "select * from news where no=$no";
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
    
    $image_name[0]   = $row[file_name_0];
	$image_name[1]   = $row[file_name_1];
	$image_name[2]   = $row[file_name_2];

	$image_copied[0] = $row[file_copied_0];
	$image_copied[1] = $row[file_copied_1];
	$image_copied[2] = $row[file_copied_2];
    
    for ($i=0; $i<3; $i++)
	{
		if ($image_copied[$i]) 
		{
			$imageinfo = GetImageSize("./data/".$image_copied[$i]);

			$image_width[$i] = $imageinfo[0];
			$image_height[$i] = $imageinfo[1];
			$image_type[$i]  = $imageinfo[2];

			if ($image_width[$i] > 785)
				$image_width[$i] = 785;
		}
		else
		{
			$image_width[$i] = "";
			$image_height[$i] = "";
			$image_type[$i]  = "";
		}
	}


	$sql = "update news set hits=$new_hit where no=$no";   // 글 조회수 증가시킴
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
	<section class="news">
    <h2>NEWS</h2>
    <div class="container">
        <input type="hidden" name="no">
		<table class="write_view">
            <tbody>
               <tr class="write_data">
                    <th> TITLE </th>
                    <td><?=$item_title?></td>
                    <th> DATE </th>
                    <td><?= $item_date ?></td>
                    <th> HITS </th>
                    <td><?=$item_hits?></td>
				</tr>
				<tr class="write_content">
				    <td colspan="6">
				    <?
                        for ($i=0; $i<3; $i++)
                        {
                            if ($image_copied[$i])
                            {
                                $img_name = $image_copied[$i];
                                $img_name = "./data/".$img_name;
                                $img_width = $image_width[$i];

                                echo "<img src='$img_name' width='$img_width'>"."<br><br>";
                            }
                        }
                    ?>
				    <?=$item_content?>
				    </td>
				</tr>
           </tbody>
		</table>
		<div class="btns">
        <? 
            if($s_email=="123")
            {
        ?>
                <form  name="board_form" method="post" action="news_form.php?page=<?=$page?>">   
                    <input type="hidden" name="no" value="<?=$item_no?>">
                    <input type="submit" value="MODIFY" class="btn_cpl">
                    <input type="button" value="LIST" class="btn_cancel" onclick="location.href='news_list.php?page=<?=$page?>'">
                </form>
        <?
            }else{?>
              <input type="button" value="LIST" class="btn_cancel" onclick="location.href='news_list.php?page=<?=$page?>'">
                 <?  
            }
        ?>
        </div>
    </div>
	</section>
	<!--    footer-->
    <? include "../include/sub_footer.html" ?>
    <!--   // footer-->

</body>
</html>
