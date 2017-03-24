<?
  session_start();
  unset($_SESSION['s_email']);
  unset($_SESSION['s_fname']);

  echo("
       <script>
          location.href = '../index.php'; 
         </script>
       ");
?>
