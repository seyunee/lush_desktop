<meta charset="utf-8">
<?
    @extract($_POST);
    @extract($_GET);
    @extract($_SESSION);


   if(!$email) 
   {
      echo("E-mail을 입력하세요.");
   }
   else
   {
      include "../lib/dbconn.php";
 
      $sql = "select * from member where email='$email' ";

      $result = mysql_query($sql, $connect);
      $num_record = mysql_num_rows($result);

/*
      if ($num_record)
      {
         echo "<div><img src='../img/id_no.jpg' alt=' ' /></div>";
        
      }
      else
      {
         echo "<div><img src='../img/id_ok.jpg' alt=' ' /></div>";
      }
     
  */
	    if ($num_record)
      {
         echo "E-mail이 중복됩니다!";
      }
      else
      {
         echo "사용가능한 E-mail입니다.";
      }
    
      mysql_close();
   }
?>

