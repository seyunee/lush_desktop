<?
   session_start();
    @extract($_POST);
    @extract($_GET);
    @extract($_SESSION);
    
   include "../lib/dbconn.php";
    $sql1 = "select from board where no = $no";
    mysql_query($sql1, $connect);
    $row = mysql_fetch_array($result);       
          // 하나의 레코드 가져오기
    $item_no     = $row[no];
    $item_email    = $row[email];


    if(!$s_fname) {
		echo("
		<script>
	     window.alert('로그인 후 이용해 주세요.');
	     location.href = '../member/login.html';
	   </script>
		");
		exit;
	}else if($item_email != $s_email ){
        echo("
		<script>
	     window.alert('글쓴이만 이용가능합니다..');
	     location.href = 'review_list.php';
	   </script>
		");
		exit;
        
    }

   $sql = "delete from board where no = $no";
   mysql_query($sql, $connect);

   mysql_close();

   echo "
	   <script>
	    location.href = 'review_list.php';
	   </script>
	";
?>

