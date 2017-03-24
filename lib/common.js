$(document).ready(function(){
    $('.depth1 li a').on('mouseenter focus',function(){
       $(this).parent('li').siblings().children('.depth2').removeClass('on');
       $(this).parent('li').children('.depth2').addClass('on');
    });
    
    $('.depth2 li:last-child a').on('blur',function(){
       $('.depth2').removeClass('on');
    });

    $('header').on('mouseleave',function(){
        $('.depth2').removeClass('on');
    });
});