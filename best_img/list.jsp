






 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
	<head>
		<!-- start of header<meta, css, script> -->
		


<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title> - LUSH KOREA</title>
<meta name="description" content="" />
<meta name="keywords" content="" />
<meta name="viewport" content="width=980" />
<link rel="stylesheet" type="text/css" href="/site/res/css/common.css" />
<link rel="stylesheet" type="text/css" href="/site/res/css/jqui/jquery-ui.min.css" />
<script type="text/javascript" src="/cmm/res/jquery/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="/site/res/js/jquery.easing.js"></script>
<script type="text/javascript" src="/site/res/js/design.js"></script>
<script type="text/javascript" src="/site/res/js/jquery.cookie.js"></script>
<script type="text/javascript" src="/site/res/js/jquery.slides.min.js"></script>
<script type="text/javascript" src="/site/res/js/jquery.scrollTo-1.4.3.1-min.js"></script>
<script type="text/javascript" src="/site/res/js/jquery-ui.min.js"></script>
<script type="text/javascript" src="/cmm/res/js/popup_window.js"></script>
<script type="text/javascript" src="/cmm/res/js/StringUtil.js"></script>
<script type="text/javascript" src="/cmm/res/js/VldtUtil.js"></script>
<script type="text/javascript" src="/cmm/res/js/PagingUtil.js"></script>
<script type="text/javascript" src="/cmm/res/js/DateUtil.js"></script>
<script type="text/javascript" src="/site/res/js/google_analytics.js"></script>
<script type="text/javascript" src="/site/res/js/link.js"></script>
<!--<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.js"></script> daum 우편번호 api https -->
<script src="https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="http://wcs.naver.net/wcslog.js"></script><!-- 네이버 프리미엄 로그 분석 -->
		<!-- end of header -->
		<script type="text/javascript">
		$(function(){
			$(".basket_btn").click(function(e){
				e.preventDefault();
				var v	= $(".basket_btn").index(this);
				var cnt = $("input[name='basket_cnt']").eq(v);
				var pdt_cd = $("input[name='pdt_cd']").eq(v).val();
				var pdt_type =$("input[name='pdt_type']").eq(v).val();
				
				if($.trim(cnt.val()).length == 0){
					alert("수량을 입력하세요.");
					cnt.focus();
					return false;
				}
				if(!vldtNum(cnt.val())){
					alert("숫자만 입력 가능합니다.");
					cnt.focus();
					return false;
				}
				if(cnt.val()> 20){
					alert("최대 수량은 20개 까지 가능합니다.");
					cnt.focus();
					return false;
				}
				//if(pdt_type == 2){
					//alert("해당상품은 주문제작 상품으로\n배송완료까지 약3주의 기간이 소요되니 참조바랍니다.");							
				//}
				$.ajax({
					type : "post"
					, cache : false
					, url : "/site/order/basket/ajax_basket_insert_proc.jsp"
					, dataType : "html"
					, data : "cnt="+cnt.val()
							+"&pdt_cd="+pdt_cd
					, success : function(result){
						result = $.trim(result);
						if(result == 1){
							_layerShow('/cmm/layer/basket_show_box.html')
						}else{
							alert("등록 실패\n다시 시도해 주십시오.");
						}
					}
					, error : function(request, error){
						alert("데이터 처리 중 오류가 발생했습니다.\n다시 시도해주십시오.");
					}
				});	
				
			});			
			

			// 입고 알림 클릭 시
			$(".sms_alarm").off("click.sms_alarm").on("click.sms_alarm",function(e){
				e.preventDefault();
				var hid_pdt_cd, imgSrc, pdtNm, pdtEnNm, pdtAmt;
				hid_pdt_cd = $(this).parents(".bs_info").find("input[name='hid_pdt_cd']").val();
				imgSrc = $(this).parents(".bs_info").find("input[name='hid_img_src']").val();
				pdtNm = $(this).parents(".bs_info").find("input[name='hid_pdt_nm']").val();
				pdtEnNm = $(this).parents(".bs_info").find("input[name='hid_en_pdt_nm']").val();
				pdtAmt = $(this).parents(".bs_info").find("input[name='hid_pdt_amt']").val();
				var stockInfo = $(".stock_pop").find(".stock_info");
				$("input[name=sh_pdt_cd]").val(hid_pdt_cd);
				stockInfo.find(".sh_img_src >img").attr("src",imgSrc).attr("alt",pdtNm);
				stockInfo.find(".sh_pdt_nm").text(pdtNm);
				stockInfo.find(".sh_en_pdt_nm").text(pdtEnNm);
				stockInfo.find(".sh_pdt_amt").text(pdtAmt);
				$(".stock_pop").show();
			});
			
			
			// 입고 알림 팝업 닫기, close 클릭 시
			$(".close_btn").off("click.close_btn").on("click.close_btn",function(e){
				e.preventDefault();
				alarmPopReset();
				$(".stock_pop").hide();
			});
			
			// 상품입고 알림 신청 팝업 확인 클릭 시
			$(".confirm_btn").off("click.confirm_btn").on("click.confirm_btn",function(e){
				e.preventDefault();
				var name = $("input[name=name]");
				var mpNo1 = $("input[name=mp_no_1]");
				var mpNo2 = $("input[name=mp_no_2]");
				var mpNo3 = $("input[name=mp_no_3]");
				
				if(name.val().trim().length == 0){
					alert("이름을 입력해 주세요.");
					name.focus();
					return false;
				}

				if(vldthanEng(name.val())){
					alert("이름은 한글과 영문만 입력 가능합니다.");
					name.focus();
					return false;
				}
				
				if(mpNo1.val().trim().length == 0){
					alert("휴대폰번호를 입력해 주세요.");
					mpNo1.focus();
					return false;
				}
				
				if(mpNo2.val().trim().length == 0){
					alert("휴대폰번호를 입력해 주세요.");
					mpNo2.focus();
					return false;
				}
				
				if(mpNo3.val().trim().length == 0){
					alert("휴대폰번호를 입력해 주세요.");
					mpNo3.focus();
					return false;
				}
				
				if(!$("input:checkbox[name=agr_chk_alarm]").is(":checked")){
					alert("개인정보 수집 및 SMS 수신에 동의 해주세요.");
					$("input:checkbox[name=agr_chk_alarm]").focus();
					return false;
				}
				
				if(confirm("입고 알림 신청 하시겠습니까?")){
					$.post(
			                  'ajax_alarm_pdt_proc.jsp', 
			                  $("form[name=frm]").serialize(), 
			                  function(result) {
			                    if(result > 0) {
			                    	alert("SMS알림 신청이 완료되었습니다.");
			                    	alarmPopReset();
			                    	$(".close_btn").triggerHandler("click");
			                    }
			                    else {
			                    	alert("시스템 오류\n고객센터에 문의해 주세요.");
			                    }
			                  }
						);	
				}
				
			});				

		});
		
		function alarmPopReset(){
			$("input[name=name]").val('');
			$("input[name*=mp_no]").val('');
			$("input:checkbox[name=agr_chk_alarm]").prop('checked',false);
		}
		</script>
	</head>
	<body>
<!-- start of header -->








 


<script type="text/javascript">
//<![CDATA[
    $(document).ready(function(){
    	// top banner
    	/*
    	var topBann = $.cookie('topBann');
    	if(typeof topBann != 'undefined' && topBann == 'topBannClose'){
    		$(".top_bnr_wrap").hide();
    	}
    	*/
    	
		$(".srch_head_pdt_nm").keypress(function(e){
			if (e.keyCode == 13) {
				if($(this).val().length == 0){
					alert("상품명을 입력해 주세요.");
					$(this).focus();
					return false;
				}					
				$("form[name=srch_form]").attr("method", "post").attr("action", _getWebDomain(false)+"/site/shop/total_search.jsp").submit();			
			}
		});
    	
    	$(".srch_pdt_nm").off("click.srch_pdt_nm").on("click.srch_pdt_nm",function(e){
    		e.preventDefault();
    		//alert($(this).prev().val());
			if($(this).prev().val().length == 0 || $(this).prev().val() == '상품명을 입력해 주세요.'){
				alert("상품명을 입력해 주세요.");
				$(this).prev().focus();
				return false;
			}    		
    		$("form[name=srch_form]").attr("method", "post").attr("action", _getWebDomain(false)+"/site/shop/total_search.jsp").submit();
    	});

       	var qPdtCd 		= $("#quick_pdt_cd").val();
       	var qTImgLink	= $("#quick_thumbnail_nm").val();
       	var qTImgNm		= $("#quick_pdt_nm").val();
       	var qPdtAmt		= $("#quick_pdt_amt").val();
       	var qImgWrap	= $(".q_img_wrap");
       	var qPdtCnt		= 0;
       	var qPdtInfoList, qTag, img, pdtItems;
       	var ICnt = 1;
       	
       	//if(typeof qPdtCd == "undefined")return false;
       	// 상품코드 쿠키 리스트
       	qPdtInfoList = new cookieList('qPdtInfoList', 1);
		if(typeof $.cookie('qPdtCnt') != "undefined")qPdtCnt = $.cookie('qPdtCnt');
       	if(qPdtInfoList.items_len() > 0){       		
       		if(qPdtInfoList.items().join('').indexOf(qPdtCd+"|") < 0 && typeof qPdtCd != "undefined"){      			
       			if(typeof qPdtCd != "undefined")qPdtInfoList.add(qPdtCd+"|"+qTImgLink+"|"+qTImgNm+"|"+qPdtAmt);
       			qPdtCnt++;
       			if(qPdtCnt <= 10)$.cookie('qPdtCnt' , qPdtCnt, { expires : 1, path : '/' });
           		//이미지 추가
           		qImgWrap.find("#quick_img").html('');
		       	ICnt = 1;	
		       	for(i=(qPdtInfoList.items_len()-1); i > -1; i--){	
					pdtItems = qPdtInfoList.items()[i].split("|");
					qPdtCdItem = pdtItems[0];
					qTImgLinkItem = pdtItems[1];
					qTImgNmItem = pdtItems[2];
					if(ICnt < 11){
			       		img = $("<a />").attr({"href" : "/site/shop/product/view.jsp?pdt_cd="+qPdtCdItem+""}).append($("<img />").attr({"src" : qTImgLinkItem, "width" : "64", "height" : "57", "alt" : qTImgNmItem}));
			       		qImgWrap.find("#quick_img").append(img);
		       		}
		       		ICnt ++;
		       	}//for end
		       	if(qPdtCnt <= 10)qImgWrap.find("em").text(qPdtCnt);
		       	
			}else{				
				qImgWrap.find("#quick_img").html('');
		       	ICnt = 1;	
		       	for(i=(qPdtInfoList.items_len()-1); i > -1; i--){		       		
		       		pdtItems = qPdtInfoList.items()[i].split("|");
					qPdtCd = pdtItems[0];
					qTImgLink = pdtItems[1];
					qTImgNm = pdtItems[2];
					if(ICnt < 11){
			       		img = $("<a />").attr({"href" : "/site/shop/product/view.jsp?pdt_cd="+qPdtCd+""}).append($("<img />").attr({"src" : qTImgLink, "width" : "64", "height" : "57", "alt" : qTImgNm}));
			       		qImgWrap.find("#quick_img").append(img);
					}
		       		ICnt ++;
		       	}//for end
		       	// 쿠키 불러와서 카운트 삽입
		       	if(typeof $.cookie('qPdtCnt') != "undefined")qPdtCnt = $.cookie('qPdtCnt');
		       	qImgWrap.find("em").text(qPdtCnt);

			}
       	}else{     		
       		if(typeof qPdtCd != "undefined"){
	       		qPdtInfoList.add(qPdtCd+"|"+qTImgLink+"|"+qTImgNm+"|"+qPdtAmt);
	       		qPdtCnt++;
	       		$.cookie('qPdtCnt' , qPdtCnt, { expires : 1, path : '/' });
	       		//이미지 추가
	       		qImgWrap.html('');
	       		img = $("<a />").attr({"href" : "/site/shop/product/view.jsp?pdt_cd="+qPdtCd+""}).append($("<img />").attr({"src" : qTImgLink, "width" : "64", "height" : "57", "alt" : qTImgNm}));
	       		qTag = $("<p>오늘의 내 관심 상품(<em>"+qPdtCnt+"</em>)</p>");
	       		qImgWrap.append(qTag);
	       		qImgWrap.append($("<div />").attr({"id" : "quick_img"}).prepend(img));
       		}
       	}
       	
       	// ie7
       	$("#quick_img a img").each(function(i,o){
       		$(this).css({"width" : "64px", "height" : "57px"});
       	});
       	
       	// top banner
       	$(".close_top_bnr").off("click.topbanner").on("click",function(e){
       		e.preventDefault();
       		// 쿠기 생성
       		$.cookie('topBann' , 'topBannClose', { path : '/' });
       		$(this).parent().slideUp();
       	});
       	
       	
    });
   
    // 쿠키리스트 fun.
    function cookieList( cookieName, exp ) {
    	var cookie = $.cookie(cookieName);
    	var items = cookie ? cookie.split(/,/) : new Array();
    	return {
    		'add' : function(val){
    			items.push(val);
    			$.cookie(cookieName, items.join(','), { expires : exp, path : '/' });
    		},
    		'clear' : function(){
    			items = null;
    			$.cookie(cookieName, null);
    		},
    		'items' : function(){
    			return items;
    		},
    		'items_len' : function(){
    			return items.length;
    		}
    	}
    }
//]]>
</script> 	           
<!-- skip -->
<div class="skip">
	<a href="#util">상단메뉴 바로가기</a>
	<a href="#gnb">메뉴 바로가기</a>
	<a href="#ctnr">컨텐츠 바로가기</a>
	<a href="#aside">사이드메뉴 바로가기</a>
	<a href="#ftr">footer 바로가기</a>
</div>
<!-- // skip -->


<!-- TOP BANNER  -->

<!-- //TOP BANNER  -->

<div class="hdr_wrap">
	<div id="hdr">
		<div class="hdr_inner">
			<h1><a href="http://www.lush.co.kr:"><img src="/site/res/img/common/logo.png" alt="LUSH - FRESH HANDMADE COSMETICS" /><span class="xmas_logo"></span></a></h1>
			<ul id="util">
				
				<li><a href="http://www.lush.co.kr:/site/login/login.jsp">로그인</a></li>
				<li><a href="https://www.lush.co.kr:/site/member/join/step_1st.jsp">회원가입</a></li>
				
				<li><a href="http://www.lush.co.kr:/site/order/basket/list.jsp">장바구니</a></li>
				<li><a href="http://www.lush.co.kr:/site/mypage/order/list.jsp">주문배송조회</a></li>
				<li><a href="http://www.lush.co.kr:/site/event/news/view.jsp?notice_no=249" style="color:#fff100;font-weight:bold">멤버십혜택</a></li>
				<li><a href="http://www.lush.co.kr:/site/customer/faq/list.jsp">고객센터</a></li>
				<li><a href="http://www.lush.co.kr:/site/brand/shop/list.jsp">매장찾기</a></li>
			</ul>	
			
			<!-- gnb -->
			<ul id="gnb">
				<!--<li><a href="/site/shop/lush0920/view.jsp"><img src="/site/res/img/common/gnb_01.gif" alt="0920" /></a></li>-->
				<!--<li><a href="/site/shop/product/list.jsp?cat2_cd=20&cat3_cd=81"><img src="/site/res/img/common/gnb_12.gif" alt="LIMITED" /></a></li>-->
				<li><a href="http://www.lush.co.kr:/site/event/event/list.jsp"><img src="/site/res/img/common/gnb_02.png"  alt="EVENT" /></a></li>
				<li><a href="http://www.lush.co.kr:/site/lushpe/kwd.jsp"><img src="/site/res/img/common/gnb_14.png"  alt="ZOOMIN" /></a></li>
				<!--<li><a href="/site/shop/product/list.jsp?cat2_cd=8"><img src="/site/res/img/common/gnb_04.gif" alt="SHOPPING" /></a></li>-->
				<li><a href="http://www.lush.co.kr:/site/brand/campaign/campaign_main.jsp"><img src="/site/res/img/common/gnb_03.png"  alt="BRAND" /></a></li>
				<!--<li><a href="/site/concert/index.jsp"><img src="/site/res/img/common/gnb_06.gif" alt="CONCERT" /></a></li>-->
				<li><a href="http://www.lush.co.kr:/site/spa/spa_main.jsp"><img src="/site/res/img/common/gnb_05.png"  alt="SPA" /></a></li>
				<!--<li><a href="/site/lushpe/review/list.jsp"><img src="/site/res/img/common/gnb_15.png" alt="REVIEW" /></a></li>-->
				<li><a href="http://www.lush.co.kr:/site/event/event/temp/2016/lushtv/index.jsp"><img src="/site/res/img/common/gnb_16.png" alt="LUSHTV" /></a></li>
			</ul>			
			<!-- //gnb  -->
			
			<!-- form -->
			<form id="srch_form" name="srch_form" method="post" action="http://www.lush.co.kr:/site/shop/total_search.jsp">				
			<div id="srch_bar">
				<fieldset>
					<legend>검색하기</legend>	
					<input type="text" name="srch_pdt_nm" class="srch_head_pdt_nm" value="" /><a href="#" class="srch_pdt_nm"><img src="/site/res/img/common/btn_srch.png" width="25" height="24" alt="검색하기"></a>						
				</fieldset>
			</div><!-- /srch_bar -->
			</form>
			<!-- /form -->			
		</div><!-- /hdr_inner -->
		
		
		
		<div id="gds_ctg">
			<ul>
				<li class="first"><a href="http://www.lush.co.kr:/site/shop/bestseller/list.jsp" class="mc00 bs"><span class="ko">베스트</span><span class="en">BEST</span></a></li>
				
				<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=8" class="mc01 "><span class="ko">배쓰</span><span class="en">Bath</span></a>
						<ul class="sc01">
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=8&cat3_cd=11">배쓰 밤</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=8&cat3_cd=12">버블 바</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=8&cat3_cd=13">배쓰 오일</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=8&cat3_cd=56">펀</a></li>
						
						</ul>
				</li>
				
				<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=9" class="mc02 "><span class="ko">샤워</span><span class="en">Shower</span></a>
						<ul class="sc02">
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=9&cat3_cd=14">솝</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=9&cat3_cd=15">샤워 젤 &amp; 젤리</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=9&cat3_cd=16">스무디 &amp; 컨디셔너</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=9&cat3_cd=18">스크럽 &amp; 버터</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=9&cat3_cd=57">펀</a></li>
						
						</ul>
				</li>
				
				<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=10" class="mc03 "><span class="ko">보디</span><span class="en">Body</span></a>
						<ul class="sc03">
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=10&cat3_cd=68">클렌저</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=10&cat3_cd=19">로션</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=10&cat3_cd=21">핸드 앤 풋</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=10&cat3_cd=20">마사지 바</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=10&cat3_cd=67">보디 스프레이</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=10&cat3_cd=50">더스팅 파우더</a></li>
						
						</ul>
				</li>
				
				<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=12" class="mc04 "><span class="ko">페이스</span><span class="en">Face</span></a>
						<ul class="sc04">
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=12&cat3_cd=60">클렌저</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=12&cat3_cd=32">토너</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=12&cat3_cd=33">모이스춰라이저</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=12&cat3_cd=34">페이스 마스크</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=12&cat3_cd=35">립</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=12&cat3_cd=37">쉐이빙 크림</a></li>
						
						</ul>
				</li>
				
				<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=11" class="mc05 "><span class="ko">헤어</span><span class="en">Hair</span></a>
						<ul class="sc05">
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=11&cat3_cd=25">샴푸 바</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=11&cat3_cd=26">샴푸</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=11&cat3_cd=51">드라이 샴푸</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=11&cat3_cd=27">컨디셔너</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=11&cat3_cd=28">트리트먼트</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=11&cat3_cd=30">스타일링</a></li>
						
						</ul>
				</li>
				
				<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=13" class="mc06 "><span class="ko">메이크업</span><span class="en">Makeup</span></a>
						<ul class="sc06">
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=13&cat3_cd=42">페이스 파우더</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=13&cat3_cd=69">파운데이션</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=13&cat3_cd=70">리퀴드 아이라이너</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=13&cat3_cd=41">크림 아이섀도우</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=13&cat3_cd=40">립스틱</a></li>
						
						</ul>
				</li>
				
				<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=14" class="mc07 "><span class="ko">퍼퓸</span><span class="en">Perfume</span></a>
						<ul class="sc07">
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=14&cat3_cd=46">보디 스프레이</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=14&cat3_cd=83">고릴라 볼륨 3</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=14&cat3_cd=44">고릴라 볼륨 2</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=14&cat3_cd=43">고릴라 볼륨 1</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=14&cat3_cd=45">인센스</a></li>
						
						</ul>
				</li>
				
				<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=16" class="mc08 "><span class="ko">기프트</span><span class="en">Gifts</span></a>
						<ul class="sc08">
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=16&cat3_cd=48">러쉬 세트</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=16&cat3_cd=52">악세서리</a></li>
						
						</ul>
				</li>
				
				<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=20" class="mc09 "><span class="ko">이벤트</span><span class="en">Events</span></a>
						<ul class="sc09">
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=20&cat3_cd=82">온라인 전용</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=20&cat3_cd=79">리미티드</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=20&cat3_cd=77">신제품</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=20&cat3_cd=76">촉촉함 찾기</a></li>
						
						</ul>
				</li>
				
				<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=17" class="mc010 xmas"><span class="ko">크리스마스</span><span class="en">Christmas</span></a>
						<ul class="sc010">
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=17&cat3_cd=53">크리스마스 상품</a></li>
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=17&cat3_cd=54">크리스마스 기프트</a></li>
						
						</ul>
				</li>
				
				<!--<li><a href="#" class="mc08 btn_sb">NEWS</a></li>-->
				<!--<li><a href="/site/event/news/list.jsp" class="mc08">NEWS</a></li>-->
				<!--<li><a href="/site/event/event/temp/2014/event_fate.jsp" class="mc08">FAT EXPO</a></li>-->
				<!--
				<li><a href="/site/lushpe/review/list.jsp" class="mc09"><span class="ko">러쉬피</span><span class="en">LUSHPE</span></a>
					<ul class="sc09">
						<li><a href="/site/lushpe/review/list.jsp">사용후기</a></li>
						<li><a href="/site/lushpe/staff_choice.jsp">스태프 초이스</a></li>
						<li><a href="/site/lushpe/freshbio/fresh_mask.jsp">신선한 러쉬</a></li>
						<li><a href="/site/lushpe/kwd.jsp">키워드</a></li>
						<li><a href="http://www.lushtimes.co.kr" class="lush_times">LUSH TIMES</a></li>
					</ul>
				</li>
				-->
			</ul>
			
			<p class="c_news"><a href="/site/event/news/list.jsp">NEWS</a></p>
		</div><!-- /gds_ctg -->
		
		<!-- BRAND 메뉴 -->
		<!--
		<div id="brand_menu">
			<ul>
				<li class="first"><a href="/site/shop/bestseller/list.jsp" class="bs"><span class="ko">베스트셀러</span><span class="en">BEST SELLER</span></a></li>
				<li><a href="/site/brand/board/whats_new.jsp"><span>WHAT'S NEW</span></a></li>
				<li><a href="/site/brand/board/real_focus.jsp"><span>REAL FOCUS</span></a></li>
				<li><a href="/site/brand/korea/10g_news.jsp"><span>LUSH KOREA</span></a></li>
				<li><a href="/site/brand/campaign/campaign_main.jsp"><span>CAMPAIGN</span></a></li>
				<li><a href="/site/brand/board/lush_story.jsp"><span>LUSH STORY</span></a></li>
				<li><a href="/site/brand/board/we_believe.jsp"><span>WE BELIEVE</span></a></li>
				<li><a href="/site/brand/history/lush_history_01.jsp"><span>HISTORY</span></a></li>
				<li><a href="/site/brand/board/green_policy.jsp"><span>GREEN POLICY</span></a></li>
				<li><a href="/site/brand/shop/list.jsp"><span>STORE</span></a></li>
			</ul>
		</div>
		-->
		<!-- /brand_menu -->		
		

		<!--   퀵 메뉴 시작 메인, 제품에만 해당-->
			
		<!--   퀵 메뉴 끝-->
	<script type="text/javascript">
	//<![CDATA[
		/* layerPopup open/close  */
		;(function ($) {
			$.fn.extend({
				openLayerPop : function (targetLayer) {
					return this.each(function () {
						$(this).click(function (e) {
							e.preventDefault();
							
							// 마스크
							$maskLayer = $('<div id="mask"></div>');
							$targetLayer = $(targetLayer);
	
							var maskHeight = $(document).height();
							var maskWidth = $(window).width();
							var layerHeight = $targetLayer.height();	
							var layerWidth = $targetLayer.width();	
	
							$targetLayer.before($maskLayer);
							$maskLayer.css({
								'width':maskWidth,
								'height':maskHeight,
								position : "absolute",
								top : 0,
								left : 0,
								zIndex:3000,
								backgroundColor:"#000",
								display:"none"
							});
	
							$maskLayer.fadeTo("slow", 0.5);
	
							$targetLayer.css({
								position:"absolute",
								left:'50%',
								top:'50%',
								zIndex:3000,
								marginTop: -layerHeight/2,
								marginLeft: -layerWidth/2
							});
							$targetLayer.fadeIn(700);
	
						});
					});
				},	// end of openLayerPop
	
				closeLayerPop : function (targetLayer) {
					return this.each(function () {
						$(this).click(function (e) {
							e.preventDefault();
							$maskLayer = $('#mask');
							$targetLayer = $(targetLayer);
							$("#sb_frm").find("input[name=email]").val('');
							$("#sb_frm").find("input:checkbox[name=sb_agr]").prop("checked",false);
							// mask layer 숨기고 지우기
							$maskLayer.hide();
							$maskLayer.remove();
							$targetLayer.hide();
						});
					});
				}	// end of closeLayerPop
			});
		})(jQuery);
	
		$(function(){
			//$('#pop_subscribe').hide();
			$('.btn_sb').openLayerPop('#pop_subscribe');
			$('#btn_close_sb').closeLayerPop('#pop_subscribe');
		});	           
	//]]>	
	</script>		           
	</div><!-- /hdr -->
</div><!-- /hdr_wrap -->
<!-- end of header -->
		<div class="ctnr_wrap">
			<div class="bs_mvisual">
				<div class="inner">
					<h1>BEST SELLER</h1>
				</div><!-- /inner -->
			</div><!-- /shopping_visual -->

			<div id="ctnr" class="bestseller">
				<div id="subcnt" class="full">
					<ul class="shopping_tab">
						<li>
							<a href="/site/shop/bestseller/list.jsp?srch_best_type=1" class="current">
								Weekly Best
								<span>주간베스트</span>
							</a>
						</li>
						<li>
							<a href="/site/shop/bestseller/list.jsp?srch_best_type=2" >
								Monthly Best
								<span>월간베스트</span>
							</a>
						</li>
						<li>
							<a href="/site/shop/bestseller/list.jsp?srch_best_type=3" >
								Steady Seller
								<span>스테디셀러</span>
							</a>
						</li>
					</ul>


					<h2>WEEKLY BEST</h2>
					<p class="intro_txt">
						한주간 가장 많은 관심과 사랑을 받은 베스트 상품
					</p>

					<div class="best_seller_wrap">
						<div id="bestSeller" >
						
						
										<ul>
						
										<li class="first">
											<dl>
												<dt><a href="/site/shop/product/view.jsp?pdt_cd=00191"><img src="/cmm/upload/product/00191/0/20150410336110514286558817700_img.png" width="155" height="137" alt="코스메틱 워리어" /></a>
													<img src="/site/res/img/main_new/ico_bs_01.png"  alt="No.01" class="ico_top" />
												</dt>
												<dd class="tit">코스메틱 워리어</dd>
												<dd>￦28,000원</dd>
											</dl>
										</li>

						
						
						
										<li >
											<dl>
												<dt><a href="/site/shop/product/view.jsp?pdt_cd=P0165"><img src="/cmm/upload/product/P0165/0/20170110439044514840057460010_img.jpg" width="155" height="137" alt="뷰티풀 250g" /></a>
													<img src="/site/res/img/main_new/ico_bs_02.png"  alt="No.02" class="ico_top" />
												</dt>
												<dd class="tit">뷰티풀 250g</dd>
												<dd>￦26,000원</dd>
											</dl>
										</li>

						
						
						
										<li >
											<dl>
												<dt><a href="/site/shop/product/view.jsp?pdt_cd=00100"><img src="/cmm/upload/product/00100/0/20170111601822314840924711820_img.png" width="155" height="137" alt="브레이즌드 허니" /></a>
													<img src="/site/res/img/main_new/ico_bs_03.png"  alt="No.03" class="ico_top" />
												</dt>
												<dd class="tit">브레이즌드 허니</dd>
												<dd>￦28,000원</dd>
											</dl>
										</li>

						
						
						
										<li >
											<dl>
												<dt><a href="/site/shop/product/view.jsp?pdt_cd=00479"><img src="/cmm/upload/product/00479/0/20150319878911614267548620180_img.png" width="155" height="137" alt="마스크 오브 매그너민티 125g" /></a>
													<img src="/site/res/img/main_new/ico_bs_04.png"  alt="No.04" class="ico_top" />
												</dt>
												<dd class="tit">마스크 오브 매그너민티 125g</dd>
												<dd>￦20,700원</dd>
											</dl>
										</li>

						
						
						
										<li >
											<dl>
												<dt><a href="/site/shop/product/view.jsp?pdt_cd=00050"><img src="/cmm/upload/product/00050/0/20160502910348514621776709980_img.jpg" width="155" height="137" alt="더 컴포터" /></a>
													<img src="/site/res/img/main_new/ico_bs_05.png"  alt="No.05" class="ico_top" />
												</dt>
												<dd class="tit">더 컴포터</dd>
												<dd>￦12,900원</dd>
											</dl>
										</li>

							
										</ul>
						
						
						
										<ul>
						
										<li class="first">
											<dl>
												<dt><a href="/site/shop/product/view.jsp?pdt_cd=00378"><img src="/cmm/upload/product/00378/0/20150306482107914256261339970_img.jpg" width="155" height="137" alt="더티 보디 스프레이" /></a>
													<img src="/site/res/img/main_new/ico_bs_06.png"  alt="No.06" class="ico_top" />
												</dt>
												<dd class="tit">더티 보디 스프레이</dd>
												<dd>￦41,500원</dd>
											</dl>
										</li>

						
						
						
										<li >
											<dl>
												<dt><a href="/site/shop/product/view.jsp?pdt_cd=00554"><img src="/cmm/upload/product/00554/0/20150319525518214267559114620_img.png" width="155" height="137" alt="마스크 오브 매그너민티 315g" /></a>
													<img src="/site/res/img/main_new/ico_bs_07.png"  alt="No.07" class="ico_top" />
												</dt>
												<dd class="tit">마스크 오브 매그너민티 315g</dd>
												<dd>￦36,700원</dd>
											</dl>
										</li>

						
						
						
										<li >
											<dl>
												<dt><a href="/site/shop/product/view.jsp?pdt_cd=00257"><img src="/cmm/upload/product/00257/0/20150924543755714430749181900_img.png" width="155" height="137" alt="콜페이스" /></a>
													<img src="/site/res/img/main_new/ico_bs_08.png"  alt="No.08" class="ico_top" />
												</dt>
												<dd class="tit">콜페이스</dd>
												<dd>￦16,200원</dd>
											</dl>
										</li>

						
						
						
										<li >
											<dl>
												<dt><a href="/site/shop/product/view.jsp?pdt_cd=00188"><img src="/cmm/upload/product/00188/0/20150410177222714286563169690_img.png" width="155" height="137" alt="카타스트로피 코스메틱" /></a>
													<img src="/site/res/img/main_new/ico_bs_09.png"  alt="No.09" class="ico_top" />
												</dt>
												<dd class="tit">카타스트로피 코스메틱</dd>
												<dd>￦28,000원</dd>
											</dl>
										</li>

						
						
						
										<li >
											<dl>
												<dt><a href="/site/shop/product/view.jsp?pdt_cd=00041"><img src="/cmm/upload/product/00041/0/20161128607907214802884586080_img.jpg" width="155" height="137" alt="뉴" /></a>
													<img src="/site/res/img/main_new/ico_bs_10.png"  alt="No.10" class="ico_top" />
												</dt>
												<dd class="tit">뉴</dd>
												<dd>￦18,500원</dd>
											</dl>
										</li>

							
										</ul>
						
							
						</div>
					</div><!-- /best_seller_wrap -->					
																	
					<div class="bs_list_wrap">
						
						
						<div class="bs_items">
							
							<div class="bs_pic">
								<a href="/site/shop/product/view.jsp?pdt_cd=00191"><img src="/cmm/upload/product/00191/20150410786738614286558831852_img.png" width="340" height="340" alt="코스메틱 워리어" /></a>
								<img src="/site/res/img/sub/bestseller/rank_01.png" class="rnk_num" alt="1위" />
								
								<!--<img src="/site/res/img/sub/bestseller/mark_fd_big.png" class="mark" alt="FREE DELIVERY" />-->
								
							</div><!-- /bs_pic -->


							<div class="bs_info">
								<input type="hidden" name="hid_pdt_cd" value="00191" />
								<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00191/20150410786738614286558831852_img.png" />
								<input type="hidden" name="hid_pdt_nm" value="코스메틱 워리어" />
								<input type="hidden" name="hid_en_pdt_nm" value="COSMETIC WARRIOR" />
								<input type="hidden" name="hid_pdt_amt" value="28,000" />							
								<dl>
									<dt>
										<span>Face Masks</span>
										<strong><a href="/site/shop/product/view.jsp?pdt_cd=00191">코스메틱 워리어</a></strong>
										<em>COSMETIC WARRIOR</em>
									</dt>
									<dd class="desc">
										프레쉬 마스크
									</dd>
									<dd class="selection">
										<select name="">
											<option value="">75</>g / ￦28,000</option>
										</select>
										
										<input type="text" name="basket_cnt" value="1" maxlength="2" class="qnt" />
										<input type="hidden" name="pdt_cd" value="00191"/>
										<input type="hidden" name="pdt_type" value="2"/>
										<a href="#" class="basket_btn"><img src="/site/res/img/sub/bestseller/btn_order.gif" width="84" height="22" alt="주문하기" /></a>
										
										<span class="">
											
											
											
										</span>
									</dd>
								</dl>
								
								
									<div class="chosed_with">
										<p>다른 고객이 함께 구매한 상품</p>
										<ul>
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00007"><img src="/cmm/upload/product/00007/0/20150317729034414265573187430_img.png" width="120" height="106" alt="풀 오브 그레이스" /></a></span>
												<strong><a href="/site/shop/product/view.jsp?pdt_cd=00007">풀 오브 그레이스</a></strong>
												<em>￦26,300원</em>
											</li>
											
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00089"><img src="/cmm/upload/product/00089/0/20150317672058614265570004360_img.png" width="120" height="106" alt="배니싱 크림" /></a></span>
												<strong><a href="/site/shop/product/view.jsp?pdt_cd=00089">배니싱 크림</a></strong>
												<em>￦76,500원</em>
											</li>
											
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00211"><img src="/cmm/upload/product/00211/0/20150317629669814265576520610_img.png" width="120" height="106" alt="티 트리 워터 250g" /></a></span>
												<strong><a href="site/shop/product/view.jsp?pdt_cd=00211">티 트리 워터 250g</a></strong>
												<em>￦27,000원</em>
											</li>
											
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00507"><img src="/cmm/upload/product/00507/0/2015031734446914265571038690_img.png" width="120" height="106" alt="엔지미온_09" /></a></span>
												<strong><a href="/site/shop/product/view.jsp?pdt_cd=00507">엔지미온_09</a></strong>
												<em>￦58,500원</em>
											</li>
											
										</ul>
									</div>
								
							</div><!-- /bs_info -->
						</div><!-- /bs_items -->
						
						
						
						
						<div class="bs_items">
							
							<div class="bs_pic">
								<a href="/site/shop/product/view.jsp?pdt_cd=P0165"><img src="/cmm/upload/product/P0165/20170110273397914840057587962_img.png" width="340" height="340" alt="뷰티풀 250g" /></a>
								<img src="/site/res/img/sub/bestseller/rank_02.png" class="rnk_num" alt="2위" />
								
								<!--<img src="/site/res/img/sub/bestseller/mark_fd_big.png" class="mark" alt="FREE DELIVERY" />-->
								
							</div><!-- /bs_pic -->


							<div class="bs_info">
								<input type="hidden" name="hid_pdt_cd" value="P0165" />
								<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0165/20170110273397914840057587962_img.png" />
								<input type="hidden" name="hid_pdt_nm" value="뷰티풀 250g" />
								<input type="hidden" name="hid_en_pdt_nm" value="BEAUTIFUL 250g" />
								<input type="hidden" name="hid_pdt_amt" value="26,000" />							
								<dl>
									<dt>
										<span>Shower Gels &amp; Jellies</span>
										<strong><a href="/site/shop/product/view.jsp?pdt_cd=P0165">뷰티풀 250g</a></strong>
										<em>BEAUTIFUL 250g</em>
									</dt>
									<dd class="desc">
										샤워 젤
									</dd>
									<dd class="selection">
										<select name="">
											<option value="">250</>g / ￦26,000</option>
										</select>
										
										<input type="text" name="basket_cnt" value="1" maxlength="2" class="qnt" />
										<input type="hidden" name="pdt_cd" value="P0165"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<a href="#" class="basket_btn"><img src="/site/res/img/sub/bestseller/btn_order.gif" width="84" height="22" alt="주문하기" /></a>
										
										<span class="">
											
													<img src="/site/res/img/sub/bestseller/mark_vg.png" alt="vegan" />
											
											
											
										</span>
									</dd>
								</dl>
								
								
									<div class="chosed_with">
										<p>다른 고객이 함께 구매한 상품</p>
										<ul>
											
											
											
											
										</ul>
									</div>
								
							</div><!-- /bs_info -->
						</div><!-- /bs_items -->
						
						
						
						
						<div class="bs_items">
							
							<div class="bs_pic">
								<a href="/site/shop/product/view.jsp?pdt_cd=00100"><img src="/cmm/upload/product/00100/20170111148526114840924990032_img.png" width="340" height="340" alt="브레이즌드 허니" /></a>
								<img src="/site/res/img/sub/bestseller/rank_03.png" class="rnk_num" alt="3위" />
								
								<!--<img src="/site/res/img/sub/bestseller/mark_fd_big.png" class="mark" alt="FREE DELIVERY" />-->
								
							</div><!-- /bs_pic -->


							<div class="bs_info">
								<input type="hidden" name="hid_pdt_cd" value="00100" />
								<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00100/20170111148526114840924990032_img.png" />
								<input type="hidden" name="hid_pdt_nm" value="브레이즌드 허니" />
								<input type="hidden" name="hid_en_pdt_nm" value="BRAZENED HONEY" />
								<input type="hidden" name="hid_pdt_amt" value="28,000" />							
								<dl>
									<dt>
										<span>Face Masks</span>
										<strong><a href="/site/shop/product/view.jsp?pdt_cd=00100">브레이즌드 허니</a></strong>
										<em>BRAZENED HONEY</em>
									</dt>
									<dd class="desc">
										프레쉬 마스크
									</dd>
									<dd class="selection">
										<select name="">
											<option value="">75</>g / ￦28,000</option>
										</select>
										
										<input type="text" name="basket_cnt" value="1" maxlength="2" class="qnt" />
										<input type="hidden" name="pdt_cd" value="00100"/>
										<input type="hidden" name="pdt_type" value="2"/>
										<a href="#" class="basket_btn"><img src="/site/res/img/sub/bestseller/btn_order.gif" width="84" height="22" alt="주문하기" /></a>
										
										<span class="">
											
											
											
										</span>
									</dd>
								</dl>
								
								
									<div class="chosed_with">
										<p>다른 고객이 함께 구매한 상품</p>
										<ul>
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00038"><img src="/cmm/upload/product/00038/0/20150319573582014267275697610_img.png" width="120" height="106" alt="나인 투 파이브 240g" /></a></span>
												<strong><a href="/site/shop/product/view.jsp?pdt_cd=00038">나인 투 파이브 240g</a></strong>
												<em>￦25,200원</em>
											</li>
											
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00161"><img src="/cmm/upload/product/00161/0/2015031758288414265576277070_img.png" width="120" height="106" alt="오 로마 워터 250g" /></a></span>
												<strong><a href="/site/shop/product/view.jsp?pdt_cd=00161">오 로마 워터 250g</a></strong>
												<em>￦29,200원</em>
											</li>
											
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00190"><img src="/cmm/upload/product/00190/0/20150317882934914265568926520_img.png" width="120" height="106" alt="코스메틱 래드" /></a></span>
												<strong><a href="site/shop/product/view.jsp?pdt_cd=00190">코스메틱 래드</a></strong>
												<em>￦43,900원</em>
											</li>
											
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00089"><img src="/cmm/upload/product/00089/0/20150317672058614265570004360_img.png" width="120" height="106" alt="배니싱 크림" /></a></span>
												<strong><a href="/site/shop/product/view.jsp?pdt_cd=00089">배니싱 크림</a></strong>
												<em>￦76,500원</em>
											</li>
											
										</ul>
									</div>
								
							</div><!-- /bs_info -->
						</div><!-- /bs_items -->
						
						
						
						
						<div class="bs_items">
							
							<div class="bs_pic">
								<a href="/site/shop/product/view.jsp?pdt_cd=00479"><img src="/cmm/upload/product/00479/20150319280655114267558232102_img.png" width="340" height="340" alt="마스크 오브 매그너민티 125g" /></a>
								<img src="/site/res/img/sub/bestseller/rank_04.png" class="rnk_num" alt="4위" />
								
								<!--<img src="/site/res/img/sub/bestseller/mark_fd_big.png" class="mark" alt="FREE DELIVERY" />-->
								
							</div><!-- /bs_pic -->


							<div class="bs_info">
								<input type="hidden" name="hid_pdt_cd" value="00479" />
								<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00479/20150319280655114267558232102_img.png" />
								<input type="hidden" name="hid_pdt_nm" value="마스크 오브 매그너민티 125g" />
								<input type="hidden" name="hid_en_pdt_nm" value="MASK OF MAGNAMINTY 125g" />
								<input type="hidden" name="hid_pdt_amt" value="20,700" />							
								<dl>
									<dt>
										<span>Scrubs &amp; Butters</span>
										<strong><a href="/site/shop/product/view.jsp?pdt_cd=00479">마스크 오브 매그너민티 125g</a></strong>
										<em>MASK OF MAGNAMINTY 125g</em>
									</dt>
									<dd class="desc">
										클렌저 & 스크럽
									</dd>
									<dd class="selection">
										<select name="">
											<option value="">125</>g / ￦20,700</option>
										</select>
										
										<input type="text" name="basket_cnt" value="1" maxlength="2" class="qnt" />
										<input type="hidden" name="pdt_cd" value="00479"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<a href="#" class="basket_btn"><img src="/site/res/img/sub/bestseller/btn_order.gif" width="84" height="22" alt="주문하기" /></a>
										
										<span class="">
											
											
											
										</span>
									</dd>
								</dl>
								
								
									<div class="chosed_with">
										<p>다른 고객이 함께 구매한 상품</p>
										<ul>
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00257"><img src="/cmm/upload/product/00257/0/20150924543755714430749181900_img.png" width="120" height="106" alt="콜페이스" /></a></span>
												<strong><a href="/site/shop/product/view.jsp?pdt_cd=00257">콜페이스</a></strong>
												<em>￦16,200원</em>
											</li>
											
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00211"><img src="/cmm/upload/product/00211/0/20150317629669814265576520610_img.png" width="120" height="106" alt="티 트리 워터 250g" /></a></span>
												<strong><a href="/site/shop/product/view.jsp?pdt_cd=00211">티 트리 워터 250g</a></strong>
												<em>￦27,000원</em>
											</li>
											
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00088"><img src="/cmm/upload/product/00088/0/20150317495677314265570691190_img.png" width="120" height="106" alt="그리스 라이트닝" /></a></span>
												<strong><a href="site/shop/product/view.jsp?pdt_cd=00088">그리스 라이트닝</a></strong>
												<em>￦18,700원</em>
											</li>
											
											
											<li>
												<span><a href="/site/shop/product/view.jsp?pdt_cd=00159"><img src="/cmm/upload/product/00159/0/2015031734446914265571038690_img.png" width="120" height="106" alt="엔지미온" /></a></span>
												<strong><a href="/site/shop/product/view.jsp?pdt_cd=00159">엔지미온</a></strong>
												<em>￦58,500원</em>
											</li>
											
										</ul>
									</div>
								
							</div><!-- /bs_info -->
						</div><!-- /bs_items -->
						
						
						
						
										<div class="liner">
						
						<div class="bs_items">
							
							<div class="bs_pic">
								<a href="/site/shop/product/view.jsp?pdt_cd=00050"><img src="/cmm/upload/product/00050/20160502541524314621776741832_img.png" width="270" height="270" alt="더 컴포터" /></a>
								<img src="/site/res/img/sub/bestseller/rank_05.png" class="rnk_num" alt="5위" />
								
								<!--<img src="/site/res/img/sub/bestseller/mark_fd_big.png" class="mark" alt="FREE DELIVERY" />-->
								
							</div><!-- /bs_pic -->


							<div class="bs_info">
								<input type="hidden" name="hid_pdt_cd" value="00050" />
								<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00050/20160502541524314621776741832_img.png" />
								<input type="hidden" name="hid_pdt_nm" value="더 컴포터" />
								<input type="hidden" name="hid_en_pdt_nm" value="THE COMFORTER" />
								<input type="hidden" name="hid_pdt_amt" value="12,900" />							
								<dl>
									<dt>
										<span>Bubble Bars</span>
										<strong><a href="/site/shop/product/view.jsp?pdt_cd=00050">더 컴포터</a></strong>
										<em>THE COMFORTER</em>
									</dt>
									<dd class="desc">
										버블 바
									</dd>
									<dd class="selection">
										<select name="">
											<option value="">200</>g / ￦12,900</option>
										</select>
										
										<input type="text" name="basket_cnt" value="1" maxlength="2" class="qnt" />
										<input type="hidden" name="pdt_cd" value="00050"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<a href="#" class="basket_btn"><img src="/site/res/img/sub/bestseller/btn_order.gif" width="84" height="22" alt="주문하기" /></a>
										
										<span class="">
											
													<img src="/site/res/img/sub/bestseller/mark_vg.png" alt="vegan" />
											
											
											
										</span>
									</dd>
								</dl>
								
								
							</div><!-- /bs_info -->
						</div><!-- /bs_items -->
						
						
						
						
						<div class="bs_items">
							
							<div class="bs_pic">
								<a href="/site/shop/product/view.jsp?pdt_cd=00378"><img src="/cmm/upload/product/00378/20150306652370114256261354182_img.png" width="270" height="270" alt="더티 보디 스프레이" /></a>
								<img src="/site/res/img/sub/bestseller/rank_06.png" class="rnk_num" alt="6위" />
								
								<!--<img src="/site/res/img/sub/bestseller/mark_fd_big.png" class="mark" alt="FREE DELIVERY" />-->
								
							</div><!-- /bs_pic -->


							<div class="bs_info">
								<input type="hidden" name="hid_pdt_cd" value="00378" />
								<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00378/20150306652370114256261354182_img.png" />
								<input type="hidden" name="hid_pdt_nm" value="더티 보디 스프레이" />
								<input type="hidden" name="hid_en_pdt_nm" value="DIRTY BODY SPRAY" />
								<input type="hidden" name="hid_pdt_amt" value="41,500" />							
								<dl>
									<dt>
										<span>Body Spray</span>
										<strong><a href="/site/shop/product/view.jsp?pdt_cd=00378">더티 보디 스프레이</a></strong>
										<em>DIRTY BODY SPRAY</em>
									</dt>
									<dd class="desc">
										보디 스프레이
									</dd>
									<dd class="selection">
										<select name="">
											<option value="">200</>ml / ￦41,500</option>
										</select>
										
										<input type="text" name="basket_cnt" value="1" maxlength="2" class="qnt" />
										<input type="hidden" name="pdt_cd" value="00378"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<a href="#" class="basket_btn"><img src="/site/res/img/sub/bestseller/btn_order.gif" width="84" height="22" alt="주문하기" /></a>
										
										<span class="">
											
													<img src="/site/res/img/sub/bestseller/mark_vg.png" alt="vegan" />
											
											
													<img src="/site/res/img/sub/bestseller/mark_fd.png" alt="free delivery" />
											
											
										</span>
									</dd>
								</dl>
								
								
							</div><!-- /bs_info -->
						</div><!-- /bs_items -->
						
						</div><!-- /liner -->
						
						
						
						
										<div class="liner">
						
						<div class="bs_items">
							
							<div class="bs_pic">
								<a href="/site/shop/product/view.jsp?pdt_cd=00554"><img src="/cmm/upload/product/00554/20150319930708714267559128672_img.png" width="270" height="270" alt="마스크 오브 매그너민티 315g" /></a>
								<img src="/site/res/img/sub/bestseller/rank_07.png" class="rnk_num" alt="7위" />
								
								<!--<img src="/site/res/img/sub/bestseller/mark_fd_big.png" class="mark" alt="FREE DELIVERY" />-->
								
							</div><!-- /bs_pic -->


							<div class="bs_info">
								<input type="hidden" name="hid_pdt_cd" value="00554" />
								<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00554/20150319930708714267559128672_img.png" />
								<input type="hidden" name="hid_pdt_nm" value="마스크 오브 매그너민티 315g" />
								<input type="hidden" name="hid_en_pdt_nm" value="MASK OF MAGNAMINTY 315g" />
								<input type="hidden" name="hid_pdt_amt" value="36,700" />							
								<dl>
									<dt>
										<span>Scrubs &amp; Butters</span>
										<strong><a href="/site/shop/product/view.jsp?pdt_cd=00554">마스크 오브 매그너민티 315g</a></strong>
										<em>MASK OF MAGNAMINTY 315g</em>
									</dt>
									<dd class="desc">
										클렌저 & 스크럽
									</dd>
									<dd class="selection">
										<select name="">
											<option value="">315</>g / ￦36,700</option>
										</select>
										
										<input type="text" name="basket_cnt" value="1" maxlength="2" class="qnt" />
										<input type="hidden" name="pdt_cd" value="00554"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<a href="#" class="basket_btn"><img src="/site/res/img/sub/bestseller/btn_order.gif" width="84" height="22" alt="주문하기" /></a>
										
										<span class="">
											
											
													<img src="/site/res/img/sub/bestseller/mark_fd.png" alt="free delivery" />
											
											
										</span>
									</dd>
								</dl>
								
								
							</div><!-- /bs_info -->
						</div><!-- /bs_items -->
						
						
						
						
						<div class="bs_items">
							
							<div class="bs_pic">
								<a href="/site/shop/product/view.jsp?pdt_cd=00257"><img src="/cmm/upload/product/00257/2015031797028114265582944912_img.png" width="270" height="270" alt="콜페이스" /></a>
								<img src="/site/res/img/sub/bestseller/rank_08.png" class="rnk_num" alt="8위" />
								
								<!--<img src="/site/res/img/sub/bestseller/mark_fd_big.png" class="mark" alt="FREE DELIVERY" />-->
								
							</div><!-- /bs_pic -->


							<div class="bs_info">
								<input type="hidden" name="hid_pdt_cd" value="00257" />
								<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00257/2015031797028114265582944912_img.png" />
								<input type="hidden" name="hid_pdt_nm" value="콜페이스" />
								<input type="hidden" name="hid_en_pdt_nm" value="COALFACE" />
								<input type="hidden" name="hid_pdt_amt" value="16,200" />							
								<dl>
									<dt>
										<span>Cleansers</span>
										<strong><a href="/site/shop/product/view.jsp?pdt_cd=00257">콜페이스</a></strong>
										<em>COALFACE</em>
									</dt>
									<dd class="desc">
										클렌저
									</dd>
									<dd class="selection">
										<select name="">
											<option value="">100</>g / ￦16,200</option>
										</select>
										
										<input type="text" name="basket_cnt" value="1" maxlength="2" class="qnt" />
										<input type="hidden" name="pdt_cd" value="00257"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<a href="#" class="basket_btn"><img src="/site/res/img/sub/bestseller/btn_order.gif" width="84" height="22" alt="주문하기" /></a>
										
										<span class="">
											
													<img src="/site/res/img/sub/bestseller/mark_vg.png" alt="vegan" />
											
											
											
										</span>
									</dd>
								</dl>
								
								
							</div><!-- /bs_info -->
						</div><!-- /bs_items -->
						
						</div><!-- /liner -->
						
						
						
						
										<div class="liner">
						
						<div class="bs_items">
							
							<div class="bs_pic">
								<a href="/site/shop/product/view.jsp?pdt_cd=00188"><img src="/cmm/upload/product/00188/20150410173045014286563183932_img.png" width="270" height="270" alt="카타스트로피 코스메틱" /></a>
								<img src="/site/res/img/sub/bestseller/rank_09.png" class="rnk_num" alt="9위" />
								
								<!--<img src="/site/res/img/sub/bestseller/mark_fd_big.png" class="mark" alt="FREE DELIVERY" />-->
								
							</div><!-- /bs_pic -->


							<div class="bs_info">
								<input type="hidden" name="hid_pdt_cd" value="00188" />
								<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00188/20150410173045014286563183932_img.png" />
								<input type="hidden" name="hid_pdt_nm" value="카타스트로피 코스메틱" />
								<input type="hidden" name="hid_en_pdt_nm" value="CATASTROPHE COSMETIC" />
								<input type="hidden" name="hid_pdt_amt" value="28,000" />							
								<dl>
									<dt>
										<span>Face Masks</span>
										<strong><a href="/site/shop/product/view.jsp?pdt_cd=00188">카타스트로피 코스메틱</a></strong>
										<em>CATASTROPHE COSMETIC</em>
									</dt>
									<dd class="desc">
										프레쉬 마스크
									</dd>
									<dd class="selection">
										<select name="">
											<option value="">75</>g / ￦28,000</option>
										</select>
										
										<input type="text" name="basket_cnt" value="1" maxlength="2" class="qnt" />
										<input type="hidden" name="pdt_cd" value="00188"/>
										<input type="hidden" name="pdt_type" value="2"/>
										<a href="#" class="basket_btn"><img src="/site/res/img/sub/bestseller/btn_order.gif" width="84" height="22" alt="주문하기" /></a>
										
										<span class="">
											
													<img src="/site/res/img/sub/bestseller/mark_vg.png" alt="vegan" />
											
											
											
										</span>
									</dd>
								</dl>
								
								
							</div><!-- /bs_info -->
						</div><!-- /bs_items -->
						
						
						
						
						<div class="bs_items">
							
							<div class="bs_pic">
								<a href="/site/shop/product/view.jsp?pdt_cd=00041"><img src="/cmm/upload/product/00041/20161128257356714802884716512_img.png" width="270" height="270" alt="뉴" /></a>
								<img src="/site/res/img/sub/bestseller/rank_10.png" class="rnk_num" alt="10위" />
								
								<!--<img src="/site/res/img/sub/bestseller/mark_fd_big.png" class="mark" alt="FREE DELIVERY" />-->
								
							</div><!-- /bs_pic -->


							<div class="bs_info">
								<input type="hidden" name="hid_pdt_cd" value="00041" />
								<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00041/20161128257356714802884716512_img.png" />
								<input type="hidden" name="hid_pdt_nm" value="뉴" />
								<input type="hidden" name="hid_en_pdt_nm" value="NEWHAIR" />
								<input type="hidden" name="hid_pdt_amt" value="18,500" />							
								<dl>
									<dt>
										<span>Shampoo Bars</span>
										<strong><a href="/site/shop/product/view.jsp?pdt_cd=00041">뉴</a></strong>
										<em>NEWHAIR</em>
									</dt>
									<dd class="desc">
										샴푸 바
									</dd>
									<dd class="selection">
										<select name="">
											<option value="">55</>g / ￦18,500</option>
										</select>
										
										<input type="text" name="basket_cnt" value="1" maxlength="2" class="qnt" />
										<input type="hidden" name="pdt_cd" value="00041"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<a href="#" class="basket_btn"><img src="/site/res/img/sub/bestseller/btn_order.gif" width="84" height="22" alt="주문하기" /></a>
										
										<span class="">
											
													<img src="/site/res/img/sub/bestseller/mark_vg.png" alt="vegan" />
											
											
											
										</span>
									</dd>
								</dl>
								
								
							</div><!-- /bs_info -->
						</div><!-- /bs_items -->
						
						</div><!-- /liner -->
						
						
						
					</div><!-- /bs_list_wrap -->

				</div><!-- /subcnt -->
			</div><!-- /cntr -->
		</div><!-- /cnt_wrap -->
<!-- start of footer -->




 

<!-- <link rel="stylesheet" href="/site/res/css/keep-it-on.css" />
[if lt IE 9]>
<script src="/site/res/js/html5shiv.js"></script>
<script src="/site/res/js/queryselector.js"></script>
<![endif]
<script type="text/javascript">
window.lushTakeover = {
	langCode: 'ko'
};
</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.15.1/moment.min.js"></script>	
<script src="/site/res/js/countdown.js"></script>
<script src="/site/res/js/init.js"></script>
<script src="/site/res/js/mode.js"></script>
<script src="/site/res/js/preroll.js"></script>
<script src="/site/res/js/switch-headline.js"></script>
<script src="/site/res/js/template.js"></script>
<script src="/site/res/js/translations.js"></script>
 -->
 <script type="text/javascript">
//<![CDATA[
    $(document).ready(function(){    	
    	// 이메일무단수집거부 팝업
		$(".email_pop").popupWindow({ 
			centerScreen:1,
		    height:220,  
		    width:400
		});
    	
    	// 러쉬 타임즈
		$(".lush_times").popupWindow({ 
			centerScreen:1,
		    height:$(window).height(),  
		    width:$(window).width()			
		});   	
    	
		/* Quick 오늘 본 상품 이미지 */
		var qPdtCnt = 0;
		if(typeof $.cookie('qPdtCnt') != "undefined")qPdtCnt = $.cookie('qPdtCnt');
		if(qPdtCnt > 1){
			$('#quick_img').slidesjs({
				width: 59,
				height: 57
			});
		}
		
		// 퀵 메뉴 top ini set
		quickMSet();

		/* Quick 베스트 셀러 */
		$('#quick_img_02').slidesjs({
			width: 59,
			height: 120
		});
				
		// 퀵 메뉴 animate
		var position, bodyH, footerH, contentH, viewH, headH, fixH;
		var topH = 145;
		var currentPosition = parseInt($("#quick_menu").css("top"));
		var ctnrH = parseInt($("#ctnr").height());
		var lowCtnrH = 630;
		var topIniBannH = $(".top_bnr_wrap").height();
		var prePosition = 0;
		var mainVisualH, shpMvisualH;
		
		$(window).scroll(function(){
			position = $(window).scrollTop();
			bodyH = $("body").height();
			footerH = $(".ftr_wrap").height();
			headH = $(".hdr_wrap").height();
			//컨텐츠 사이즈
			contentH = bodyH-footerH;
			
			// 화면 사이즈
			viewH = $(window).height();
			
			if($(".top_bnr_wrap").is(" :hidden")){
				topBannH = 0;	
			}else{
				topBannH = $(".top_bnr_wrap").height();
				if(!topBannH)topBannH = 0;
			}
			
			// 메인 배너 영역 존재 여부
			if(!$("#mainVisual").length){
				mainVisualH = 0;
			}else{
				mainVisualH = $("#mainVisual").find("li").height();
			}
			
			// 상품 카테고리 페이지에서 BG 이미지 영역 존재 여부
			if(!$(".shp_mvisual").length){
				shpMvisualH = 0;
			}else{
				shpMvisualH = $(".shp_mvisual").height();
			}
			
			fixH = contentH-viewH;
			if(position > fixH){
				$("#quick_menu").stop().animate({"top": position-topBannH+currentPosition-(position-fixH)-mainVisualH-shpMvisualH+"px"},'slow', 'easeOutBack');
				if(position > (topH+mainVisualH+shpMvisualH) && ctnrH < lowCtnrH){				
					$("#quick_menu").stop().animate({"top":  (topH+mainVisualH+shpMvisualH)+"px"},'slow', 'easeOutBack');
				}
			}else{
				$("#quick_menu").stop().animate({"top": position-topBannH+currentPosition-mainVisualH-shpMvisualH+"px"},'slow', 'easeOutBack');
			}

			if(position < (topH+mainVisualH+shpMvisualH)){			
				$("#quick_menu").stop().animate({"top":  (topH+mainVisualH+shpMvisualH)+"px"},'slow', 'easeOutBack');
			}

		});
		
		// top 클릭시
		$(".btn_top").off("click.btn_top").on("click.btn_top",function(e){
			e.preventDefault();
			$.scrollTo(topIniBannH+"px", 400, {queue:true});
		});
		
		
		// 구독 신청 클릭 시
		$(".sb_rec").off("click.sb_rec").on("click.sb_rec",function(e){
			e.preventDefault();
			var email = $("#sb_frm").find("input[name=email]");
			
			if(email.val().trim().length == 0){
				alert("이메일을 입력해 주세요.");
				email.focus();
				return false;
			}
			
			if(vldtEmail(email.val()) == false){
				alert("유효한 이메일을 입력해 주세요.");
				email.focus();
				return false;
			}

			
			if(!$("#sb_frm").find("input:checkbox[name=sb_agr]").prop("checked")){
				alert("뉴스구독 신청을 하기 위해서는 개인정보 수집 및 이용과\n개인정보의 취급위탁에 동의하셔야 합니다.");
				$("#sb_frm").find("input:checkbox[name=sb_agr]").focus();
				return false;
			}
			
			if(!$("#sb_frm").find("input:checkbox[name=entrust_agree]").prop("checked")){
				alert("뉴스구독 신청을 하기 위해서는 개인정보 수집 및 이용과\n개인정보의 취급위탁에 동의하셔야 합니다.");
				$("#sb_frm").find("input:checkbox[name=entrust_agree]").focus();
				return false;
			}
			
			if(confirm("뉴스구독을  신청 하시겠습니까?")){
				//$("form[name=sb_frm]").attr("method", "post").attr("action", "/site/member/news/ajax_member_news_proc.jsp").submit();
				
				$.post(
		                  '/site/member/news/ajax_member_news_proc.jsp', 
		                  $("form[name=sb_frm]").serialize(), 
		                  function(result) {
		                    if(result.indexOf('_OK_') > -1) {
		                    	alert("뉴스구독 신청이 완료 되었습니다.");
	                    		email.val('');
	                    		$("#sb_frm").find("input:checkbox[name=sb_agr]").prop("checked",false);
	                    		$('#btn_close_sb').triggerHandler("click");
		                    	$("#rcv_result").html(result.replace("_OK_",""));
		                    }else if(result.indexOf('_DU_') > -1) {//중복 이메일
		                    	alert("이미 신청된 이메일 주소입니다.");
		                    }else{
		                    	alert("시스템 오류\n고객센터에 문의해 주세요.");
		                    }
		                  }
					);
			}
			
		});
		
		if('' == "Y"){
			$('.btn_sb').triggerHandler("click");
		}
		
		//뉴스 구독 개인 정보 수집 및 이용 동의 체크 시 취급 위탁 또한 자동 체크
		$("#sb_frm").find("input:checkbox[name=sb_agr]").on("click",function(){
			if($(this).prop("checked")){
				alert("[필수]개인정보 수집 및 이용에 동의할 경우\n[필수]개인정보의 취급위탁에 대해서도 함께 동의처리 됩니다.");
				$("#sb_frm").find("input:checkbox[name=entrust_agree]").prop("checked", true);
			}
		});
		
    }); //doc func. end
    

	function quickMSet(){
		var qMt = parseInt($("#quick_menu").css("top"));
		var mImgH = 0;
		var cImgH = 0;
		if($(".main_visual_wrap").length){
			mImgH = parseInt($(".main_visual_wrap").height());
		}
		
		if($(".shp_mvisual").length){
			cImgH = parseInt($(".shp_mvisual").height());
		}
		$("#quick_menu").css({"top" : (qMt+mImgH+cImgH)+"px"});
	}
	
	//네이버 프리미엄 로그 분석
	if (!wcs_add) var wcs_add={};
	wcs_add["wa"] = "s_b0ad071d609";
	if (!_nasa) var _nasa={};
	wcs.inflow();
	wcs_do(_nasa);	
//]]>
</script>
<script type="text/javascript">
    var roosevelt_params = {
        retargeting_id:'3uWfwFrDEkoNokpNmtWjyA00',
        tag_label:'sT6gYkKeSoSikWPohsJHZA'
    };
</script>
<script type="text/javascript" src="//adimg.daumcdn.net/rt/roosevelt.js" async></script> 
<div class="ftr_wrap">
	<div class="bot_info_wrap">
				<div class="bot_info">
					<img src="/site/res/img/main/bot_info.gif" width="980" height="167" alt="FIGHTING ANIMAL TESTING, FRESHEST COSMETICS ONLINE, ETHICAL BUYING, 100% VEGETARIAN, HANDMADE, NAKED! PACKAGING" />
				</div>
			</div><!-- /bot_info_wrap -->

			<div id="ftr">
				<div class="ftr_top">
					<p><a href="http://www.lush.co.kr:"><img src="/site/res/img/common/logo_bot.png" width="168" height="31" alt="LUSH fresh handmade consmatics" /></a></p>
					 <ul class="bot_util">
						<li><a href="http://www.lush.co.kr:/site/brand/board/lush_story.jsp">회사소개</a></li>
						<li><a href="http://www.lush.co.kr:/site/cmm/etc/privacy.jsp"><strong>개인정보취급방침</strong></a></li>
						<li><a href="http://www.lush.co.kr:/site/cmm/etc/use_agreement.jsp">이용약관</a></li>
						<li><a href="http://www.lush.co.kr:/site/cmm/etc/reject_email_popup.jsp" class="email_pop">이메일무단수집거부</a></li>
						<li><a href="http://www.lush.co.kr:/site/cmm/etc/sales_agreement.jsp">판매약관</a></li>
						<li><a href="http://www.lush.co.kr:/site/customer/faq/list.jsp">고객센터</a></li>
						<li><a href="http://www.lush.co.kr:/site/brand/shop/list.jsp">매장찾기</a></li>
						<li><a href="http://www.lush.co.kr:/site/largeorder/theme_guide.jsp">대량주문안내</a></li>
					 </ul>
				</div>

				<div class="ftr_inner">
					<div class="ftr_side">
						<p class="sns_area">
							<a href="http://blog.naver.com/lushonline" target="_blank"><img src="/site/res/img/common/ico_blog.gif" width="33" height="32" alt="blog" /></a>
							<a href="http://www.facebook.com/lushkorea" target="_blank"><img src="/site/res/img/common/ico_facebook.gif" width="16" height="33" alt="facebook" /></a>
							<a href="http://instagram.com/lushkorea" target="_blank"><img src="/site/res/img/common/ico_instagram.gif" width="32" height="32" alt="instagram" /></a>
							<a href="http://www.youtube.com/user/Lushcosmetics"  target="_blank"><img src="/site/res/img/common/ico_youtube.gif" width="27" height="33" alt="youtube" /></a>
						</p>
						<p><a href="https://www.allatpay.com/servlet/AllatBizV2/svcinfo/SvcInfoMainCL?menu_id=m010602&action_flag=SEARCH&search_no=biz_no&es_business_no=2148787271" target="_blank"><img src="/site/res/img/common/buy_cert.png" width="146" height="28" alt="(주)올앳, 고객님의 안전 거래를 위해 실시간 계좌이체로
						결제 시 올앳 구매안전서비스를 이용하실 수 있습니다." /></a></p>
					</div><!-- /ftr_side -->
					<div class="ftr_adrs">
						<address>
							<strong>사이트 운영자:㈜러쉬코리아 / 대표이사:우미령</strong><br />
							서울시 서초구 서초동 1321-6 서초동아타워 6층<br />
							사업자 등록번호:201-81-77964 / 통신판매업 신고번호:2012-서울서초-0647 / 개인정보관리책임자:우승용<br />
							고객센터:1644-2357(운영시간:09:00~18:00, 점심시간:11:50~13:00) / FAX:02-795-7516 / 문의메일:webmaster@lush.co.kr  
						</address>

						<p class="copyright">Copyright © LUSHKOREA co., Ltd. All rights reserved.</p>
					</div><!-- /ftr_adrs -->
				</div><!-- /ftr_inner -->
			</div><!-- //ftr -->
		<!-- layer popup s -->
		<!-- 20161213 주고싶찌 팝업 -->
		<style>
			.layer_jugo{display:none;position:absolute;top:15%;left:-244px;width:488px;margin:0 50%;z-index:3000}
		</style>
		<div id="layer_jugo" class="layer_jugo">
			<img src="/site/res/img/popup/main/popup_membership.jpg" alt="주고싶찌" usemap="#tempss" />
			<map name="tempss">
				<area href="javascript:jugo_pop(2);" shape="rect" coords="444,8,476,40" target="_self" alt="닫기" style="cursor:pointer" >
			</map>
		</div>
		<!-- //20161213 주고싶찌 팝업 -->
		<div class="layer_pop" id="pop_subscribe" style="display:none">
		<form id="sb_frm" name="sb_frm" method="post" action="">	
			<div class="pop_hdr">
				<h2><img src="/site/res/img/sub/popup/main/pop_tit_01.gif" width="218" height="24" alt="LUSH 뉴스구독 신청" /></h2>
			</div>
			<div class="pop_cntr">
				<div class="pop_cnts">
					<div class="news_sb">
						<p class="sb_intro">러쉬에 관심이 있다면, 뉴스구독으로 따끈따끈한 소식을 받아보세요.</p>
						<div>
							<label for="sb_email" class="lb_hide">구독을 위한 이메일 입력</label>
							<input type="text" name="email" value="" placeholder="이메일을 입력해 주세요." id="sb_email" style="width:266px" /> 
							<a href="#"><img src="/site/res/img/sub/popup/main/btn_subscribe.gif" class="sb_rec" width="79" height="32" alt="구독신청" /></a>
						</div>
						
						
						<div class="priv_wrap">
							<h3><strong>[필수]</strong> 개인정보 수집 및 이용에 대한 동의</h3>
							<table class="tbl_priv">
								<caption>개인정보 수집 및 이용에 대한 동의</caption>
								<colgroup>
									<col width="15%" />
									<col width="35%" />
									<col width="30%" />
									<col width="20%" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col">수집자</th>
										<th scope="col">이용목적</th>
										<th scope="col">항목</th>
										<th scope="col">보유기간</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>㈜러쉬코리아</td>
										<td>신규 이벤트, 서비스, 정책, 상품의 안내 및 마케팅</td>
										<td>
											이메일
										</td>
										<td>
											구독 신청 후 3개월 내지 이메일 수신거부 및 동의철회 시 파기
										</td>
									</tr>
								</tbody>
							</table>
							<p class="agr_line"><input type="checkbox" name="sb_agr" id="sb_agr" value="1" /><label for="sb_agr">개인정보 수집 및 이용(필수)에 동의합니다.</label></p>
							<p class="agr_note">
								※ 뉴스구독 서비스 제공을 위해서 필요한 최소한의 개인정보이므로 동의를 해야만 서비스를 이용하실 수 있습니다.
							</p>
						</div><!-- /privacy -->
						
						
					<div class="priv_wrap">
						<h3><strong>[필수]</strong> 개인정보의 취급위탁에 대한 동의</h3>
						<table class="tbl_priv">
							<colgroup>
								<col width="35%" />
								<col width="30%" />
								<col width="35%" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">위탁업체</th>
									<th scope="col">위탁업무내용</th>
									<th scope="col">수탁업체</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>㈜러쉬코리아</td>
									<td>신규 이벤트, 서비스, 정책, 상품의 안내 및 마케팅</td>
									<td>
										㈜와이씨네트웍스
									</td>
								</tr>
							</tbody>
						</table>
						<p class="agr_line"><input type="checkbox" name="entrust_agree" id="entrust_agree" value="1" /><label for="entrust_agree">개인정보의 취급위탁(필수)에 동의합니다.</label></p>
						<p class="agr_note">
							※ 개인정보 수집 및 이용 등의 외 ㈜와이씨네트웍스에 대한 개인정보 위탁에도 동의해 주셔야 이메잉을 통한 신규 이벤트, 서비스, 정책, 상품의 안내 및 마케팅이 가능합니다.
 						</p>
					</div><!-- /privacy -->					
						
					</div>
				</div>
				<div class="pop_ftr">
					<p>COPYRIGHT&copy;(주)러쉬코리아 ALL RIGHTS RESERVED</p>
					<a href="#" id="btn_close_sb"><img src="/site/res/img/sub/popup/btn_close.gif" width="66" height="24" alt="닫기" /></a>
				</div>
			</div>
		</form>	
		</div>
		<!-- layer popup e -->	
</div><!-- /ftr_wrap -->
<!-- start of find rcv result -->
<div id="rcv_result"></div>
<!-- end of find rcv result -->	
<script type="text/javascript" src="/site/res/js/lush_log_V01.js"></script>
<!-- adinsight 공통스크립트 start -->
<script type="text/javascript">
var TRS_AIDX = 8986;
var TRS_PROTOCOL = document.location.protocol;
document.writeln();
var TRS_URL = TRS_PROTOCOL + '//' + ((TRS_PROTOCOL=='https:')?'analysis.adinsight.co.kr':'adlog.adinsight.co.kr') +  '/emnet/trs_esc.js';
document.writeln("<scr"+"ipt language='javascript' src='" + TRS_URL + "'></scr"+"ipt>");
</script>
<!-- adinsight 공통스크립트 end -->
<!-- LOGGER(TM) TRACKING SCRIPT V.40 FOR logger.co.kr / 53378 : COMBINE TYPE / DO NOT ALTER THIS SCRIPT. -->
<script type="text/javascript">var _TRK_LID="53378";var _L_TD="ssl.logger.co.kr";var _TRK_CDMN=".lush.co.kr";</script>
<script type="text/javascript">var _CDN_DOMAIN = location.protocol == "https:" ? "https://fs.bizspring.net" : "http://fs.bizspring.net";
(function(b,s){var f=b.getElementsByTagName(s)[0],j=b.createElement(s);j.async=true;j.src='//fs.bizspring.net/fs4/bstrk.1.js';f.parentNode.insertBefore(j,f);})(document,'script');</script>
<noscript><img alt="Logger Script" width="1" height="1" src="http://ssl.logger.co.kr/tracker.tsp?u=53378&amp;js=N" /></noscript>
<!-- END OF LOGGER TRACKING SCRIPT -->

<!-- end of footer -->
		<script type="text/javascript">
			/* Best Seller */
			$('#bestSeller').slidesjs({
				width: 847,
				height: 225,
				play: {
				  auto: false
				}
			});
		</script>
		<!-- layer popup s -->
		<div class="layer_pop stock_pop" style="display:none">
		<!-- form -->
		<form id="frm" name="frm" method="post" action="">
			<input type="hidden" name="sh_pdt_cd" value="" />		
			<div class="pop_hdr">
				<h2><img src="/site/res/img/sub/popup/stock/pop_tit_01.gif" alt="입고 알림신청" /></h2>
			</div>
			<div class="pop_cntr">
				<div class="pop_cnts">
					<div class="stock_info">
						<p class="sh_img_src"><img src="" alt="" width="115px;" /></p>
						<dl>
							<dt>
								<br />
								<span class="sh_pdt_nm"></span><br />
								(<span class="sh_en_pdt_nm"></span>)
							</dt>
							<dd>￦ <span class="sh_pdt_amt"></span>원</dd>
						</dl>
					</div><!-- /stock_info -->
					
					<div class="pop0920_ipt">
						<p>선택하신 상품의 입고 알림을 받기 원하신다면 아래의 정보를 입력해 주세요.</p>
						<p class="ipt0920_info">
							<label for="u_name">이름</label>
							<input type="text" name="name" value="" id="name" size="8" class="altM02" />
							<label for="u_phone">휴대폰번호</label>
							<input type="text" name="mp_no_1" value="" id="u_phone" class="vldt_num" maxlength="4" size="4" /> -
							<input type="text" name="mp_no_2" value="" size="4" class="vldt_num" maxlength="4" title="휴대폰둘째자리" /> -
							<input type="text" name="mp_no_3" value="" size="4" class="vldt_num" maxlength="4" title="휴대폰셋째자리" />
						</p>
						<p class="p_agr">
							<input type="checkbox" name="agr_chk_alarm" value="Y" id="prv_agr" />
							<label for="prv_agr">개인정보 수집 및 SMS 수신에 동의합니다.</label>
						</p>
						<p class="note0920">
							입력하신 개인정보는 상품의 입고 알림 안내 용도로만 활용되며,<br />
							3개월 후 자동 파기됩니다. 동의하지 않으실 경우<br />
							상품의 입고 알림 SMS를 받으실 수 없습니다.
						</p>
					</div>	
					<p class="btn_line_0920">
						<a href="#" class="confirm_btn"><img src="/site/res/img/sub/popup/btn_apply.gif" alt="신청" /></a>
						<a href="#" class="close_btn"><img src="/site/res/img/sub/popup/btn_close.png" alt="닫기" /></a>
					</p>
				</div>
				<div class="pop_ftr">
					<p>COPYRIGHT&copy;(주)러쉬코리아 ALL RIGHTS RESERVED</p>
					<a href="#" class="close_btn"><img src="/site/res/img/sub/popup/btn_close.gif" width="66" height="24" alt="" /></a>
				</div>
			</div>
		</form>
		<!-- /form -->			
		</div>
		<!-- layer popup e -->				
</body>
</html>