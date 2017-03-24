<?
           session_start();
unset($_SESSION['s_email']);
unset($_SESSION['s_fname']);

?>
<meta charset="utf-8">
<?
   @extract($_GET); 
  @extract($_POST); 
  @extract($_SESSION); 
   // 이전화면에서 이름이 입력되지 않았으면 "이름을 입력하세요"
   // 메시지 출력
   // $email=>입력email값    $pass=>입력 pass
   
   if(!$email) {   
     echo("
           <script>
             window.alert('이메일을 입력하세요.');
             history.go(-1);
           </script>
         ");
         exit;
   }

   if(!$password) {
     echo("
           <script>
             window.alert('비밀번호를 입력하세요.');
             history.go(-1);
           </script>
         ");
         exit;
   }
 

   include "../lib/dbconn.php";
   $sql ="select * from member where email='$email' and pass=password('$password')";
   $result = mysql_query($sql, $connect);
   $num_match = mysql_num_rows($result);
   $row=mysql_fetch_array($result);

    if(!$num_match)  //적은 패스워드와 디비 패스워드가 같지않을때
    {
       echo("
          <script>
            window.alert('로그인정보가 틀립니다.');
            history.go(-1);
          </script>
       ");

       exit;
    }
    else    // 입력    pass 와 테이블에 저장된 pass 일치한다.
    {
       $email = $row[email];
       $fname = $row[fname];
       
       $_SESSION['s_email'] = $email;//$_SESSION['useremail'] = $row[email];
       $_SESSION['s_fname'] = $fname;//$_SESSION['useremail'] = $row[email];

       echo("
          <script>
            alert('로그인이 되었습니다.');
            location.href = '../index.php';
          </script>
       ");
    }
?>
