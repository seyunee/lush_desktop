<meta charset="utf-8">
<?
    @extract($_POST);
    @extract($_GET);
    @extract($_SESSION);

   include "../lib/dbconn.php";       // dconn.php 파일을 불러옴

   $sql = "select * from member where email='$email'";
   $result = mysql_query($sql, $connect);
   $exist_id = mysql_num_rows($result);

   if($exist_id) {
     echo("
           <script>
             window.alert('해당 아이디가 존재합니다.')
             history.go(-1)
           </script>
         ");
         exit;
   }
   else
   {            // 레코드 삽입 명령을 $sql에 입력
	    $sql = "insert into member(fname, lname, email, pass, regist_day) ";
		$sql .= "values('$firstName','$lastName','$email', password('$password'), now())";

		mysql_query($sql, $connect);  // $sql 에 저장된 명령 실행
   }

   mysql_close();                // DB 연결 끊기
   echo "
	   <script>
        alert('회원가입이 완료되었습니다.');
	    location.href = '../index.html';
	   </script>
	";
?>

   
