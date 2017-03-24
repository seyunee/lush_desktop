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
	<title>LUSH KOREA</title>
	<script src="http://code.jquery.com/jquery-1.10.2.min.js "></script>
  <script src="lib/common.js"></script>
  <script src="lib/mainpopup.js"></script>
  <link href="css/lush.css" rel="stylesheet" type="text/css">
  <script src="lib/jquery.bxslider/jquery.bxslider.js"></script>
  <link href="lib/jquery.bxslider/jquery.bxslider.css" rel="stylesheet" />
	<script>
	$(document).ready(function(){
		$('.bxslider').bxSlider({
      mode:'fade',
      speed:1000,
			auto:true,
			autoStart:true,
			preloadImages:'all',
      pager:true
		});
	});
	</script>
 </head>
<body>
    <!--    header-->
    <? include "include/header.html" ?>
    <!--   // header-->

	<section>
		<div class="mainBanner">
			<ul class="bxslider" >
			  <li><a href="#"><img src="img/main_img1.jpg" alt="내게 필요한 촉촉함을 찾고 있다면"></a></li>
			  <li><a href="#"><img src="img/main_img2.jpg" alt="당신의 헤어, 샴푸바에게 맡겨주세요"></a></li>
			  <li><a href="#"><img src="img/main_img3.jpg" alt="감성 휴식, 러시 지금 만나보세요"></a></li>
			</ul>
		</div><!-- //banner -->
		<section class="container">
		    <h2 id="contents" class="hidden">본문 콘텐츠 영역</h2>
			<div class="subBanner">
              <dl>
                <dt><img src="img/mb01.jpg" alt="러쉬만의 커플스파를 경험해보세요."></dt>
                <dd>
                  <span>ARTICLE</span>
                  <strong class="title">러쉬만의 커플스파를<br> 경험해보세요.</strong>
                  <a href="#" class="more">더보기</a>
                </dd>
              </dl>
              <dl>
                <dt><img src="img/mb02.jpg" alt="자연에서 온 화장품 보존제"></dt>
                <dd>
                  <span>ARTICLE</span>
                  <strong class="title">자연에서 온 <br>화장품 보존제</strong>
                  <a href="#" class="more">더보기</a>
                </dd>
              </dl>
              <dl>
                <dt><img src="img/mb03.jpg" alt="What's the deo-l with deodorant?"></dt>
                <dd>
                  <span>ARTICLE</span>
                  <strong class="title">What's the deo-l <br>with deodorant?</strong>
                  <a href="#" class="more">더보기</a>
                </dd>
              </dl>
			</div> <!-- //subBanner -->

			<div class="mdPick">
				<ul>
                  <li class="type1">
                    <dl>
                        <dt><img src="img/mb04.jpg" alt="당신은 사실 달콤한 사람이에요"></dt>
                        <dd>
                          <span>ARTICLE</span>
                          <strong class="title">당신은 사실 <br>달콤한 사람이에요</strong>
                          <a href="#" class="more">더보기</a>
                        </dd>
                    </dl>
                  </li>
                  <li><img src="img/md_img2.jpg"  alt="카마크림"></li>
                  <li><img src="img/md_img3.jpg"  alt="풀오브그레이스"></li>
                  <li class="type1">
                    <dl>
                        <dt><img src="img/mb07.jpg" alt="신규회원 이벤트"></dt>
                        <dd>
                          <span>신규회원 이벤트</span>
                          <strong class="title">새로운 시작<br>새로운 만남</strong>
                          <a href="#" class="more">더보기</a>
                        </dd>
                    </dl>
                  </li>
                  <li><img src="img/md_img5.jpg" alt="헬핑 핸즈"></li>
				</ul>
			</div> <!-- //mdPick -->
			<div class="ad">
               <dl>
                <dt><img src="img/bt.png" alt="SPA TREATMENTS"></dt>
                <dd>
                  <span>SPA TREATMENTS</span>
                  <strong class="title">테일즈 오브 배쓰</strong>
                  <a href="#" class="more">자세히 보기</a>
                </dd>
                </dl>
			</div> <!-- //ad -->
			<div class="customer">
				<!-- <h2 class="tit_customer">Customer Service</h2> -->
				<dl class="news">
					<dt><a href="#">NEWS</a></dt>
					<dd>
					    <ul>
                           <?	
                            include "lib/dbconn.php";

                            $sql = "select * from news order by no desc limit 3";

                            $result = mysql_query($sql, $connect);
                            $total_record = mysql_num_rows($result); // 공지 테이블 최근 3개
    
                            if($total_record>0){
                               for ($i=0; $i < $total_record; $i++)                    
                               {
                                  mysql_data_seek($result, $i);       
                                  // 가져올 레코드로 위치(포인터) 이동  
                                  $row = mysql_fetch_array($result);       
                                  // 하나의 레코드 가져오기

                                  $item_no     = $row[no];
                                  $item_title = str_replace(" ", "&nbsp;", $row[title]);
                                ?>
                                <li><a href="stories/news_view.php?no=<?= $item_no ?>"><?= $item_title ?></a></li>
                                <?}
                            }
                            ?>
						</ul>
					</dd>
				</dl>
				<dl class="membership">
					<dt>MEMBERSHIP</dt>
					<dd>
            사랑스러운 러쉬덕찌와 함께하는<br>
            특별한 혜택과 다양한 이벤트를 만나보세요.
					</dd>
				</dl>
				<dl class="cs">
					<dt>CS CENTER</dt>
					<dd>
                        <ul>
                            <li><a href="tel:1644-2357">TEL : 1644-2357</a></li>
                            <li>FAX : 02-795-7516</li>
                            <li>Mon ~ Fri 09:00 ~ 18:00</li>
                        </ul>
					</dd>
				</dl>
			</div> <!-- //customer -->
		</section>
	</section>
    <!--공지팝업-->
    <div id="showimage" style="z-index:99;position:absolute;width:팝업의너비;left:60%;top:120px;">
      <script language="javascript" type="text/javascript">
        function closeWin(){
           var chk = document.getElementById('Notice')
           if ( chk.checked ) {
                 setCookie( "Notice", "done" , 1); //1이란 숫자는 1일간 안보임을 뜻합니다. 날짜는 자신에 맞게 수정하세요
            }
        }
       if ( getCookie( "Notice" ) == "done" ) {
           hidebox();
       }
     </script>
     <div>
        <span class="hidden">공지사항 : 저작권에 대한 공지</span>
        <img src="img/pop.png" alt="본 사이트는 상업적 목적이 아닌 개인 포트폴리오 용도로 만들어졌습니다. 홈페이지의 일부 내용과 기타 이미지 등은 그 출처가 따로 있음을 밝힙니다." />
        <p style="font-size:12px;text-align:center;color:#666;height:15px;cursor:hand;"><input type="checkbox" name="Notice" id="Notice" value="" title="오늘은 이창을 열지 않음 선택상자"><label for="Notice">오늘은 이창을 열지 않음.</label><a style="cursor:pointer" onclick="closeWin();hidebox();return false;"> [close] </a></p>
     </div>
    </div>
    <!--//공지팝업-->
    
    <!--    footer-->
    <? include "include/footer.html" ?>
    <!--    //footer-->

</body>
</html>
