







 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
	<head>
		<!-- start of header<meta, css, script> -->
		


<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Script-Type" content="text/javascript" />
<meta http-equiv="Content-Style-Type" content="text/css" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>상품 리스트 - LUSH KOREA</title>
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
					
					var today = new Date();
					var dateA = new Date(today.getFullYear(), today.getMonth()+1, today.getDate(), today.getHours(), today.getMinutes(), today.getSeconds());
					var dateB = new Date(2014,9,4,17,0,0); // 지정날짜 세팅(시작일시)
					var dateC = new Date(2014,9,12,0,0,0); // 지정날짜 세팅(종료일시)
					var betweenSDay = (dateA.getTime() - dateB.getTime())/1000/60/60/24;		
					var betweenEDay = (dateA.getTime() - dateC.getTime())/1000/60/60/24;
					

					var dateB1 = new Date(2014,8,14,0,0,0); // 지정날짜 세팅(시작일시)
					var dateC1 = new Date(2014,9,19,10,0,0); // 지정날짜 세팅(종료일시)
					var betweenSDay1 = (dateA.getTime() - dateB1.getTime())/1000/60/60/24;		
					var betweenEDay1 = (dateA.getTime() - dateC1.getTime())/1000/60/60/24;					
					
					
					$(".basket_btn").click(function(e){
						e.preventDefault();
						var v	= $(".basket_btn").index(this);
						var cnt = $("input[name='basket_cnt']").eq(v);
						var pdt_cd = $("input[name='pdt_cd']").eq(v).val();
						var pdt_type =$("input[name='pdt_type']").eq(v).val();
						//직원 등급에게 특정 상품 장바구니 담기 X
						var gr_cd = '0';
						
						// 뉴 채러디 팟 직원 구매방지
						if(gr_cd == '5' && pdt_cd == '00847'){
							alert("부가세 제외 판매금 100%가 기부되는 착한 보디 로션 채러티 팟.\n직원분들의 뉴 채러티 팟 구매는 고객센터(1644-2357)를 통해 문의 바랍니다.");
							return false;
						}
						
						// Error404 & 러시 상품 직원 구매방지
						if(gr_cd == '5' && (pdt_cd == 'P0330' || pdt_cd == 'P0331')){
							alert("부가세 제외 판매금 100%가 기부되는 제품입니다. 직원분들의 구매는 고객센터(1644-2357)를 통해 문의 바랍니다.");
							return false;
						}
																		
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
						if(pdt_type == 2){
							/*
							if(pdt_cd != "00554" && pdt_cd != "00479" && pdt_cd != "P0121" && pdt_cd != "P0120"){
								alert("추석 연휴 기간 안전한 배송을 위해 프레쉬마스크 제품은 9월 21일 또는 28일에 일괄배송될 예정입니다.​");
							}
							*/
						}
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
									_layerShow('/cmm/layer/basket_show_box.html');
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
						hid_pdt_cd = $(this).parents(".qnt").prev(".info").find("input[name='hid_pdt_cd']").val();
						imgSrc = $(this).parents(".qnt").prev(".info").find("input[name='hid_img_src']").val();
						pdtNm = $(this).parents(".qnt").prev(".info").find("input[name='hid_pdt_nm']").val();
						pdtEnNm = $(this).parents(".qnt").prev(".info").find("input[name='hid_en_pdt_nm']").val();
						pdtAmt = $(this).parents(".qnt").prev(".info").find("input[name='hid_pdt_amt']").val();
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
							alert("입고 알림 신청을 하기 위해서는 개인정보 수집 및 이용에 동의해 주세요.");
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
				
				function info_pop(){
					var height = screen.height; 	
					var width = screen.width; 	

					var popWidth= 450;	
					var popHeight= 385;

					var leftpos = width / 2 - popWidth/2; 	
					var toppos = height / 2 - popHeight/2;
					
					var val = $.cookie('secretroom6');

					if(typeof val == 'undefined'){
						var imgWin=window.open('/site/popup/secretroom.html','info','menubar=0,toolbar=0,scrollbars=no,width=' + popWidth +', height='+popHeight+', left=' + leftpos + ',top=' + toppos);
					}	
				}
				
				function info_pop2(){
					var height = screen.height; 	
					var width = screen.width; 	

					var popWidth= 450;	
					var popHeight= 385;

					var leftpos = width / 2 - popWidth/2; 	
					var toppos = height / 2 - popHeight/2;
					
					var val = $.cookie('secretroom5');

					if(typeof val == 'undefined'){
						var imgWin=window.open('/site/popup/secretroom.html','info2','menubar=0,toolbar=0,scrollbars=no,width=' + popWidth +', height='+popHeight+', left=' + leftpos + ',top=' + toppos);
					}	
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

<div class="top_bnr_wrap">
	<div id="top_bnr">
		
			
					<!-- onmousedown="javascript:ACEL_TRACKING_164('BC','164');" -->
					<a href="http://www.lush.co.kr/site/membership/mbrship_benefit.jsp?utm_source=site&utm_medium=banner&utm_campaign=PC_MD_ONDUCZZI" target="_self" onmousedown="javascript:ACEL_TRACKING_221('BC','221');"><img src="/cmm/upload/banner/20170123765724914851299360230_img.jpg" width="980" height="87" alt="PC_MD_ONDUCZZI" /></a>
					
		
		
	</div><!-- /top_bnr -->
	<a href="#" class="close_top_bnr"><img src="/site/res/img/banner/btn_close_banner.png" width="87" height="87" alt="닫기" /></a>
</div><!-- /top_bnr_wrap -->

<!-- //TOP BANNER  -->

<div class="hdr_wrap">
	<div id="hdr">
		<div class="hdr_inner">
			<h1><a href="http://www.lush.co.kr:"><img src="/site/res/img/common/logo.png" alt="LUSH - FRESH HANDMADE COSMETICS" /></a></h1>
			<ul id="util">
				
				<li><a href="http://www.lush.co.kr:/site/login/login.jsp">로그인</a></li>
				<li><a href="https://www.lush.co.kr:/site/member/join/step_1st.jsp">회원가입</a></li>
				
				<li><a href="http://www.lush.co.kr:/site/order/basket/list.jsp">장바구니</a></li>
				<li><a href="http://www.lush.co.kr:/site/mypage/order/list.jsp">주문배송조회</a></li>
				<li><a href="http://www.lush.co.kr:/site/membership/mbrship_benefit.jsp" style="color:#fff100;font-weight:bold">멤버십혜택</a></li>
<!-- 				<li><a href="http://www.lush.co.kr:/site/event/news/view.jsp?notice_no=249" style="color:#fff100;font-weight:bold">멤버십혜택</a></li> -->
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
						
							<li><a href="http://www.lush.co.kr:/site/shop/product/list.jsp?cat2_cd=20&cat3_cd=74">설 선물 이벤트</a></li>
						
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
				
				<!--   퀵 메뉴 시작-->
				<div id="quick_menu">
					<h2><img src="/site/res/img/common/tit_quick.png" alt="QUICK" /></h2>
					<div class="quick_inner">
						<div class="q_img_wrap">
							
								<p>관심 상품이 없습니다.</p>
							
							
							<!-- <p>오늘의 내 관심 상품( <em>2</em> )</p>	
							<div id="quick_img">
								<a href="#"><img src="/site/res/img/common/quick_img_01.gif" width="64" height="62" alt="상품명1" /></a>	
								<a href="#"><img src="/site/res/img/common/quick_img_02.gif" width="64" height="62" alt="상품명1" /></a>	
								<a href="#"><img src="/site/res/img/common/quick_img_03.gif" width="64" height="62" alt="상품명1" /></a>	
							</div> -->
						</div>
						<!-- /q_img_wrap -->
						<ul>
							<li><a href="/site/mypage/basic/list.jsp" class="bgq01">MY LUSH</a></li>
							<li><a href="/site/order/basket/list.jsp" class="bgq02">장바구니</a></li>
							<li><a href="/site/mypage/order/list.jsp" class="bgq03">주문배송</a></li>
							<!--<li><a href="/site/membership/mbrship_coupon_book.jsp" class="bgq04">멤버십쿠폰</a></li>-->
							<li><a href="/site/customer/faq/list.jsp" class="bgq05">고객센터</a></li>
						</ul>	
						<div class="q_img_wrap_02">
							
						
							<p>가장 많이 사는 상품( <em>10</em> )</p>	
							<div id="quick_img_02">
						
								
								<span class="">
								
									<a href="/site/shop/product/view.jsp?pdt_cd=00191"><img src="/cmm/upload/product/00191/0/20150410336110514286558817700_img.png" width="64" height="57" alt="코스메틱 워리어" /></a>	
								
						
							
						
								
									<a href="/site/shop/product/view.jsp?pdt_cd=00378"><img src="/cmm/upload/product/00378/0/20150306482107914256261339970_img.jpg" width="64" height="57" alt="더티 보디 스프레이" /></a>	
										
								</span>
								
						
							
						
								
								<span class="">
								
									<a href="/site/shop/product/view.jsp?pdt_cd=00479"><img src="/cmm/upload/product/00479/0/20150319878911614267548620180_img.png" width="64" height="57" alt="마스크 오브 매그너민티 125g" /></a>	
								
						
							
						
								
									<a href="/site/shop/product/view.jsp?pdt_cd=00115"><img src="/cmm/upload/product/00115/0/20160113903516814526617241970_img.jpg" width="64" height="57" alt="섹스 밤" /></a>	
										
								</span>
								
						
							
						
								
								<span class="">
								
									<a href="/site/shop/product/view.jsp?pdt_cd=00188"><img src="/cmm/upload/product/00188/0/20150410177222714286563169690_img.png" width="64" height="57" alt="카타스트로피 코스메틱" /></a>	
								
						
							
						
								
									<a href="/site/shop/product/view.jsp?pdt_cd=00050"><img src="/cmm/upload/product/00050/0/20160502910348514621776709980_img.jpg" width="64" height="57" alt="더 컴포터" /></a>	
										
								</span>
								
						
							
						
								
								<span class="">
								
									<a href="/site/shop/product/view.jsp?pdt_cd=P0172"><img src="/cmm/upload/product/P0172/0/20160728429929814696878117750_img.jpg" width="64" height="57" alt="유주 앤 코코아 500g" /></a>	
								
						
							
						
								
									<a href="/site/shop/product/view.jsp?pdt_cd=00041"><img src="/cmm/upload/product/00041/0/20161128607907214802884586080_img.jpg" width="64" height="57" alt="뉴" /></a>	
										
								</span>
								
						
							
						
								
								<span class="">
								
									<a href="/site/shop/product/view.jsp?pdt_cd=00257"><img src="/cmm/upload/product/00257/0/20150924543755714430749181900_img.png" width="64" height="57" alt="콜페이스" /></a>	
								
						
							
						
								
									<a href="/site/shop/product/view.jsp?pdt_cd=00185"><img src="/cmm/upload/product/00185/0/20160614913836014658793884300_img.jpg" width="64" height="57" alt="카마 콤바" /></a>	
										
								</span>
								
								
							</div>
						
						
						</div><!-- /q_img_wrap -->
						<img src="/site/res/img/common/quick_bottom.png" class="bottom" alt="" />
						<a href="#" class="btn_top"><img src="/site/res/img/common/btn_top.png" alt="TOP" /></a>
					</div><!-- /quick_inner -->
				</div>
				<!--   퀵 메뉴 끝-->
			
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
		
			<div class="shp_mvisual" style="background-image:url('/cmm/upload/cat/20150610232353114339343563390_img.jpg');">
				<div class="inner">
					<h1>Bath</h1>
					<p>
						풍부한&nbsp;에센셜&nbsp;오일의&nbsp;향기롭고&nbsp;부드러운&nbsp;입욕
					</p>
				</div><!-- /inner -->
			</div><!-- /shopping_visual -->
		
			<div id="ctnr" class="shopping">
				<div id="subcnt" class="full">
					<!--  카테고리 탭메뉴 -->
					<ul class="shopping_tab">
						
						<li><a href="/site/shop/product/list.jsp?cat2_cd=8" >Bath<span>배쓰</span></a></li>					
												
									<li><a href="/site/shop/product/list.jsp?cat2_cd=8&cat3_cd=11" class="current">Bath Bomb<span>배쓰 밤</span></a></li>
												
									<li><a href="/site/shop/product/list.jsp?cat2_cd=8&cat3_cd=12" >Bubble Bars<span>버블 바</span></a></li>
												
									<li><a href="/site/shop/product/list.jsp?cat2_cd=8&cat3_cd=13" >Bath Oils<span>배쓰 오일</span></a></li>
												
									<li><a href="/site/shop/product/list.jsp?cat2_cd=8&cat3_cd=56" >Fun<span>펀</span></a></li>
						
					</ul>
										
						
					<!-- 리스트 정렬 -->
					<ul class="tab_sorting">
						<li><a href="list.jsp?cat2_cd=8&cat3_cd=11&srch_order=1" class='st_01 current'>신상품 순</a></li>
						<li><a href="list.jsp?cat2_cd=8&cat3_cd=11&srch_order=2" class='st_02'>인기상품 순</a></li>
						<!-- li><a href="#" class="st_03">구매후기 많은 순</a></li-->
						<li><a href="list.jsp?cat2_cd=8&cat3_cd=11&srch_order=3" class='st_04'>낮은 금액 순</a></li>
						<li><a href="list.jsp?cat2_cd=8&cat3_cd=11&srch_order=4" class='st_05'>높은 금액 순</a></li>
					</ul>

					<div class="item_list_top">
						<p>총 <em>29개</em>의 <em>Bath Bomb</em> 상품이 있습니다.</p>
						
					</div><!-- /item_list_top -->

					
					<!-- 상품리스트  -->
					<ul class="item_list">
						<li class="first">
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0266">
										
										<img src="/cmm/upload/product/P0266/20161020832499514769265440462_img.png" width="200" alt="스타더스트" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0266" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0266/20161020832499514769265440462_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="스타더스트" />
									<input type="hidden" name="hid_en_pdt_nm" value="STARDUST" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="8,000" />									
									<p class="tit">
										스타더스트
									</p>
									<p class="price">
									<span >￦ 8,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0265">
										
										<img src="/cmm/upload/product/P0265/20161020100762914769267089602_img.png" width="200" alt="쏘 화이트" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0265" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0265/20161020100762914769267089602_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="쏘 화이트" />
									<input type="hidden" name="hid_en_pdt_nm" value="SO WHITE" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="10,000" />									
									<p class="tit">
										쏘 화이트
									</p>
									<p class="price">
									<span >￦ 10,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0264">
										
										<img src="/cmm/upload/product/P0264/20161020785907114769488141912_img.png" width="200" alt="슛 포 더 스타스" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0264" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0264/20161020785907114769488141912_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="슛 포 더 스타스" />
									<input type="hidden" name="hid_en_pdt_nm" value="SHOOT FOR THE STARS" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="13,000" />									
									<p class="tit">
										슛 포 더 스타스
									</p>
									<p class="price">
									<span >￦ 13,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0263">
										
										<img src="/cmm/upload/product/P0263/20161021402386314770148049562_img.png" width="200" alt="노던 라이츠" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0263" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0263/20161021402386314770148049562_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="노던 라이츠" />
									<input type="hidden" name="hid_en_pdt_nm" value="NORTHERN LIGHTS" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="11,000" />									
									<p class="tit">
										노던 라이츠
									</p>
									<p class="price">
									<span >￦ 11,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li class="first">
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0262">
										
										<img src="/cmm/upload/product/P0262/20161020255377214769306409372_img.png" width="200" alt="네버 마인드" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0262" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0262/20161020255377214769306409372_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="네버 마인드" />
									<input type="hidden" name="hid_en_pdt_nm" value="NEVER MIND THE BALLISTICS" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="13,000" />									
									<p class="tit">
										네버 마인드
									</p>
									<p class="price">
									<span >￦ 13,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0261">
										
										<img src="/cmm/upload/product/P0261/20161020521003614769309075582_img.png" width="200" alt="미슬토" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0261" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0261/20161020521003614769309075582_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="미슬토" />
									<input type="hidden" name="hid_en_pdt_nm" value="MISTLETOE" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="15,000" />									
									<p class="tit">
										미슬토
									</p>
									<p class="price">
									<span >￦ 15,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0260">
										
										<img src="/cmm/upload/product/P0260/20161021736400314770074195192_img.png" width="200" alt="럭셔리 러쉬 퍼드" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0260" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0260/20161021736400314770074195192_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="럭셔리 러쉬 퍼드" />
									<input type="hidden" name="hid_en_pdt_nm" value="LUXURY LUSH PUD" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="14,000" />									
									<p class="tit">
										럭셔리 러쉬 퍼드
									</p>
									<p class="price">
									<span >￦ 14,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0259">
										
										<img src="/cmm/upload/product/P0259/20161020534003914769456696312_img.png" width="200" alt="골든 원더" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0259" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0259/20161020534003914769456696312_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="골든 원더" />
									<input type="hidden" name="hid_en_pdt_nm" value="GOLDEN WONDER" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="14,000" />									
									<p class="tit">
										골든 원더
									</p>
									<p class="price">
									<span >￦ 14,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li class="first">
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0343">
										
										<img src="/cmm/upload/product/P0343/20161020180128414769458408192_img.png" width="200" alt="파더 크리스마스" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0343" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0343/20161020180128414769458408192_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="파더 크리스마스" />
									<input type="hidden" name="hid_en_pdt_nm" value="FATHER CHRISTMAS" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="9,000" />									
									<p class="tit">
										파더 크리스마스
									</p>
									<p class="price">
									<span >￦ 9,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0342">
										
										<img src="/cmm/upload/product/P0342/20161020284952614769367557292_img.png" width="200" alt="버터베어" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0342" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0342/20161020284952614769367557292_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="버터베어" />
									<input type="hidden" name="hid_en_pdt_nm" value="BUTTERBEAR" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="5,000" />									
									<p class="tit">
										버터베어
									</p>
									<p class="price">
									<span >￦ 5,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0253">
										
										<img src="/cmm/upload/product/P0253/20161014792150014764210622592_img.png" width="200" alt="몬스터스 볼" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0253" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0253/20161014792150014764210622592_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="몬스터스 볼" />
									<input type="hidden" name="hid_en_pdt_nm" value="MONSTERS BALL" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="14,000" />									
									<p class="tit">
										몬스터스 볼
									</p>
									<p class="price">
									<span >￦ 14,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0252">
										
										<img src="/cmm/upload/product/P0252/201610147927014764211793352_img.png" width="200" alt="펌킨" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0252" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0252/201610147927014764211793352_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="펌킨" />
									<input type="hidden" name="hid_en_pdt_nm" value="PUMPKIN" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="10,000" />									
									<p class="tit">
										펌킨
									</p>
									<p class="price">
									<span >￦ 10,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li class="first">
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0251">
										
										<img src="/cmm/upload/product/P0251/20161014342168914764213881142_img.png" width="200" alt="로드 오브 미스룰" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0251" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0251/20161014342168914764213881142_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="로드 오브 미스룰" />
									<input type="hidden" name="hid_en_pdt_nm" value="LORD OF MISRULE" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="11,000" />									
									<p class="tit">
										로드 오브 미스룰
									</p>
									<p class="price">
									<span >￦ 11,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0248">
										
										<img src="/cmm/upload/product/P0248/20161014543437414764209965232_img.png" width="200" alt="어텀 리프" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0248" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0248/20161014543437414764209965232_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="어텀 리프" />
									<input type="hidden" name="hid_en_pdt_nm" value="AUTUMN LEAF" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="12,000" />									
									<p class="tit">
										어텀 리프
									</p>
									<p class="price">
									<span >￦ 12,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0245">
										
										<img src="/cmm/upload/product/P0245/20161007444341614758191749432_img.png" width="200" alt="라바 램프" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0245" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0245/20161007444341614758191749432_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="라바 램프" />
									<input type="hidden" name="hid_en_pdt_nm" value="LAVA LAMP" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="9,500" />									
									<p class="tit">
										라바 램프
									</p>
									<p class="price">
									<span >￦ 9,500</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="P0245"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0231">
										
										<img src="/cmm/upload/product/P0231/20160711256753314682282772322_img.png" width="200" alt="슈퍼대드" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0231" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0231/20160711256753314682282772322_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="슈퍼대드" />
									<input type="hidden" name="hid_en_pdt_nm" value="SUPERDAD" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="13,000" />									
									<p class="tit">
										슈퍼대드
									</p>
									<p class="price">
									<span >￦ 13,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
											<a href="#" class="sms_alarm"><img src="/site/res/img/sub/shopping/stock_alarm.png" alt="입고 알림" /></a>
											<img src="/site/res/img/sub/shopping/soldout.png" alt="품절" />
										
									</span>
								</dd>
							</dl>
						</li>
						<li class="first">
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0141">
										
										<img src="/cmm/upload/product/P0141/20170109391083714839216652032_img.png" width="200" alt="요가 밤" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0141" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0141/20170109391083714839216652032_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="요가 밤" />
									<input type="hidden" name="hid_en_pdt_nm" value="YOGA BOMB" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="18,000" />									
									<p class="tit">
										요가 밤
									</p>
									<p class="price">
									<span >￦ 18,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="P0141"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0140">
										
										<img src="/cmm/upload/product/P0140/20161223495937714824511596402_img.png" width="200" alt="더 엑스페리멘터" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0140" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0140/20161223495937714824511596402_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="더 엑스페리멘터" />
									<input type="hidden" name="hid_en_pdt_nm" value="THE EXPERIMENTER" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="18,000" />									
									<p class="tit">
										더 엑스페리멘터
									</p>
									<p class="price">
									<span >￦ 18,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="P0140"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0139">
										
										<img src="/cmm/upload/product/P0139/20160318248664614582646966182_img.png" width="200" alt="인터갈락틱" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0139" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0139/20160318248664614582646966182_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="인터갈락틱" />
									<input type="hidden" name="hid_en_pdt_nm" value="INTERGALACTIC" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="18,000" />									
									<p class="tit">
										인터갈락틱
									</p>
									<p class="price">
									<span >￦ 18,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="P0139"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=P0138">
										
										<img src="/cmm/upload/product/P0138/20160318324590714582640462052_img.png" width="200" alt="프로즌" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="P0138" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/P0138/20160318324590714582640462052_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="프로즌" />
									<input type="hidden" name="hid_en_pdt_nm" value="FROZEN" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="18,000" />									
									<p class="tit">
										프로즌
									</p>
									<p class="price">
									<span >￦ 18,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="P0138"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li class="first">
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=01100">
										
										<img src="/cmm/upload/product/01100/20150324694479514271614162052_img.png" width="200" alt="버터볼" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="01100" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/01100/20150324694479514271614162052_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="버터볼" />
									<input type="hidden" name="hid_en_pdt_nm" value="BUTTERBALL" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="7,500" />									
									<p class="tit">
										버터볼
									</p>
									<p class="price">
									<span >￦ 7,500</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="01100"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=01020">
										
										<img src="/cmm/upload/product/01020/20150324368099014271605567722_img.png" width="200" alt="사쿠라" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="01020" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/01020/20150324368099014271605567722_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="사쿠라" />
									<input type="hidden" name="hid_en_pdt_nm" value="SAKURA" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="10,000" />									
									<p class="tit">
										사쿠라
									</p>
									<p class="price">
									<span >￦ 10,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="01020"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=00399">
										
										<img src="/cmm/upload/product/00399/2015032443019314271631344172_img.png" width="200" alt="띵크 핑크" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="00399" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00399/2015032443019314271631344172_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="띵크 핑크" />
									<input type="hidden" name="hid_en_pdt_nm" value="THINK PINK" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="6,100" />									
									<p class="tit">
										띵크 핑크
									</p>
									<p class="price">
									<span >￦ 6,100</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="00399"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=00318">
										
										<img src="/cmm/upload/product/00318/2015032451651014271608907962_img.png" width="200" alt="이클 베이비 봇" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="00318" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00318/2015032451651014271608907962_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="이클 베이비 봇" />
									<input type="hidden" name="hid_en_pdt_nm" value="ICKLE BABY BOT" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="6,000" />									
									<p class="tit">
										이클 베이비 봇
									</p>
									<p class="price">
									<span >￦ 6,000</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="00318"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li class="first">
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=00108">
										
										<img src="/cmm/upload/product/00108/20150324269641714271634651632_img.png" width="200" alt="빅 블루" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="00108" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00108/20150324269641714271634651632_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="빅 블루" />
									<input type="hidden" name="hid_en_pdt_nm" value="BIG BLUE" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="8,300" />									
									<p class="tit">
										빅 블루
									</p>
									<p class="price">
									<span >￦ 8,300</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="00108"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=00146">
										
										<img src="/cmm/upload/product/00146/20150324641000114271635315502_img.png" width="200" alt="아보배쓰" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="00146" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00146/20150324641000114271635315502_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="아보배쓰" />
									<input type="hidden" name="hid_en_pdt_nm" value="AVOBATH" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="8,200" />									
									<p class="tit">
										아보배쓰
									</p>
									<p class="price">
									<span >￦ 8,200</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="00146"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=00115">
										
										<img src="/cmm/upload/product/00115/20150324490909314271620997552_img.png" width="200" alt="섹스 밤" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="00115" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00115/20150324490909314271620997552_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="섹스 밤" />
									<input type="hidden" name="hid_en_pdt_nm" value="SEX BOMB" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="8,500" />									
									<p class="tit">
										섹스 밤
									</p>
									<p class="price">
									<span >￦ 8,500</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="00115"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li>
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=00251">
										
										<img src="/cmm/upload/product/00251/20150324725184014271618539962_img.png" width="200" alt="티스티 토스티" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="00251" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00251/20150324725184014271618539962_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="티스티 토스티" />
									<input type="hidden" name="hid_en_pdt_nm" value="TISTY TOSTY" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="10,700" />									
									<p class="tit">
										티스티 토스티
									</p>
									<p class="price">
									<span >￦ 10,700</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="00251"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
						<li class="first">
							<dl>
								<dt>
									<a href="view.jsp?cat2_cd=8&cat3_cd=11&pdt_cd=00005">
										
										<img src="/cmm/upload/product/00005/2015032439486314271633082232_img.png" width="200" alt="블랙베리 배쓰 밤" />
										
										<span><img src="/site/res/img/sub/shopping/btn_show_detail.png" alt="자세히보기" /></span>
									</a>
								</dt>
								<dd class="info">
									<input type="hidden" name="hid_pdt_cd" value="00005" />
									<input type="hidden" name="hid_img_src" value="/cmm/upload/product/00005/2015032439486314271633082232_img.png" />
									<input type="hidden" name="hid_pdt_nm" value="블랙베리 배쓰 밤" />
									<input type="hidden" name="hid_en_pdt_nm" value="BLACKBERRY BATH BOMB" />
									
									
																	
									<input type="hidden" name="hid_pdt_amt" value="8,200" />									
									<p class="tit">
										블랙베리 배쓰 밤
									</p>
									<p class="price">
									<span >￦ 8,200</span>
									<span class="rate">
									
									</span>
									</p>
								</dd>
								<dd class="qnt">
									<a href="#" class="btn_chk">
									
										<img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" />
									
									
									</a>
										
										
									<span class="qnt_slt">
										
										<input type="hidden" name="pdt_cd" value="00005"/>
										<input type="hidden" name="pdt_type" value="1"/>
										<input type="text" name="basket_cnt" value="1" maxlength="2" /><!-- 
										 --><a href="#" class="basket_btn"><img src="/site/res/img/sub/shopping/btn_cart.gif" alt=""/></a>
										 
									</span>
								</dd>
							</dl>
						</li>
							
						
					</ul>

					<!-- <div class="icon_info">
						<dl>
							<dt><img src="/site/res/img/sub/shopping/ico_vegan.png" alt="VEGAN" /></dt>
							<dd>
								VEGAN : 동물성 성분을 일절 사용하지 않습니다.
							</dd>
						</dl>
						<dl>
							<dt><img src="/site/res/img/sub/shopping/ico_ice.png" alt="ICE" /></dt>
							<dd>
								ICE : 여름시즌 온라인에서는 냉장배송 됩니다.
							</dd>
						</dl>
						<dl>
							<dt><img src="/site/res/img/sub/shopping/ico_bye.png" alt="GOOD BYE" /></dt>
							<dd>
								GOOD BYE : 아쉬움을 뒤로하며, 단종됩니다.
							</dd>
						</dl>
						<dl>
							<dt><img src="/site/res/img/sub/shopping/ico_limit.png" alt="한정수량" /></dt>
							<dd>
								한정수량 : 소량입고, 언제 또 만날지 몰라요.
							</dd>
						</dl>
					</div> -->
				</div><!-- /subcnt -->
			</div><!-- / -->
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
									<th scope="col">목적</th>
									<th scope="col">항목</th>
									<th scope="col">보유기간</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>㈜러쉬코리아</td>
									<td>제품 입고 알림 문자발송</td>
									<td>
										성명,휴대폰번호
									</td>
									<td>
										알림 신청 후 3개월 내지 SMS 수신거부 및 동의철회 시 파기
									</td>
								</tr>
							</tbody>
						</table>
					
					
						<p class="p_agr">
							<input type="checkbox" name="agr_chk_alarm" value="Y" id="prv_agr" />
							<label for="prv_agr">개인정보 수집 및 이용(필수)에 동의합니다.</label>
						</p>
						<p class="note0920">
							※ 입고 알림 서비스 제공을 위해서 필요한 최소한의 개인정보이므로 동의를 해야만 서비스를 이용하실 수 있습니다.
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
