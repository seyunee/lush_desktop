<? 
    session_start();
    @extract($_POST);
    @extract($_GET);
    @extract($_SESSION);
?>
<meta charset="utf-8">
<?
	if(!$s_fname) {
		echo("
		<script>
	     window.alert('로그인 후 이용해 주세요.');
	     location.href = '../member/login.html';
	   </script>
		");
		exit;
	}

	if(!$title) {
		echo("
	   <script>
	     window.alert('제목을 입력하세요.')
	     history.go(-1)
	   </script>
		");
	 exit;
	}

	if(!$content) {
		echo("
	   <script>
	     window.alert('내용을 입력하세요.')
	     history.go(-1)
	   </script>
		");
	 exit;
	}

	include "../lib/dbconn.php";       // dconn.php 파일을 불러옴
    $title = htmlspecialchars($title);
    $content = htmlspecialchars($content);
    $title = str_replace("'","&#039;",$title);
    $content = str_replace("'","&#039;",$content);
    $content = str_replace("\n","<br>",$content);

	if ($no)
	{
		$sql = "update board set title='$title', content='$content' where no=$no";
	}
	else
	{
		$sql = "insert into board (email, fname, title, content, regist_day, hits) values('$s_email', '$s_fname', '$title', '$content', now(), 0)";
	}

	mysql_query($sql, $connect);  // $sql 에 저장된 명령 실행
	mysql_close();                // DB 연결 끊기

	echo "
	   <script>
	    location.href = 'review_list.php?page=$page';
	   </script>
	";
?>

  
