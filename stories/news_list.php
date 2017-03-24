<? 
	session_start(); 
    @extract($_POST);
    @extract($_GET);
    @extract($_SESSION);
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
 <?
	include "../lib/dbconn.php";

	$scale=10;			// 한 화면에 표시되는 글 수

    $sql = "select * from news order by no desc";

	$result = mysql_query($sql, $connect);

	$total_record = mysql_num_rows($result); // 전체 글 수

	// 전체 페이지 수($total_page) 계산 
	if ($total_record % $scale == 0)     
		$total_page = floor($total_record/$scale);      
	else
		$total_page = floor($total_record/$scale) + 1; 
 
	if (!$page)                 // 페이지번호($page)가 0 일 때
		$page = 1;              // 페이지 번호를 1로 초기화
 
	// 표시할 페이지($page)에 따라 $start 계산  
	$start = ($page - 1) * $scale;      

	$number = $total_record - $start;
?>
<body>
    <!--    header-->
    <? include "../include/sub_header.html" ?>
    <!--   // header-->
	<section class="news">
    <h2>NEWS</h2>
    <div class="container">
      <table>
        <colgroup>
          <col>
          <col>
          <col>
          <col>
        </colgroup>
        <thead>
          <tr>
            <th>NO</th>
            <th>TITLE</th>
            <th>DATE</th>
            <th>HITS</th>
          </tr>
        </thead>
        <tbody>
          <?		
        if($total_record>0){
           for ($i=$start; $i<$start+$scale && $i < $total_record; $i++)                    
           {
              mysql_data_seek($result, $i);       
              // 가져올 레코드로 위치(포인터) 이동  
              $row = mysql_fetch_array($result);       
              // 하나의 레코드 가져오기

              $item_no     = $row[no];
              $item_title = str_replace(" ", "&nbsp;", $row[title]);
              $item_writer    = $row[fname];
              $item_date    = $row[regist_day];
              $item_hits     = $row[hits];

            ?>
            <tr> 
              <td><?= $item_no ?></td>	
              <td class="title"><a href="news_view.php?no=<?=$item_no?>&page=<?=$page?>">
                  <?= $item_title ?></a></td>	
              <td><?=date("Y-m-d",strtotime($item_date))?></td>	
              <td><?=$item_hits?></td>
          </tr>
         <?
           }
        }else{
             ?>
            <tr> 
              <td colspan="5">There is no News</td>
          </tr>
         <?}
            ?>
        </tbody>
      </table>
       <?		
        if($s_email=='123'){?>
          <a href="news_form.php" class="btn_write">WRITE</a>
        <?}
            ?>
    </div>
	</section>
	<!--    footer-->
    <? include "../include/sub_footer.html" ?>
    <!--   // footer-->
</body>
</html>
