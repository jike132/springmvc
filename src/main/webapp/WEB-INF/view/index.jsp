<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<script type="text/javascript">

//处理登录后，物理返回到个人主页，ios中，bfcache和page cache类型浏览器的兼容性。
/*window.onpageshow = function (e) {
    if (e.persisted) {
        var date_obj = new Date();
        window.location.href = window.location.href + '?timestamp=' + date_obj.getTime();
    }
}*/
//安卓qq处理回退
/*   $(window).on("pagehide",function(){
    var date_obj = new Date();
    window.location.href = window.location.href + '?timestamp=' + date_obj.getTime();
});*/

//关闭窗口事件
/* window.onbeforeunload = function()
{
    setTimeout(onunloadcancel, 10);
    return "真的离开?";
}
window.onunloadcancel = function()
{
}*/
var channel = "10086", secondChannel = "", aioChannelNum = "30006", lishiChannelNum = "30007", isAndroid = navigator.userAgent.indexOf('Android') > -1 || navigator.userAgent.indexOf('Adr') > -1;
if (channel === aioChannelNum) {
  $("#code, #phone").focus(function(){
    $('.yitiji').css('margin-top', '-250px');
  });
} else if (secondChannel === '60005' && isAndroid) {
  $("#code, #phone").focus(function(){
    $('.main').css('margin-top', '-100px');
  });
}
function getQueryString(name) {
  var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
  var r = window.location.search.substr(1).match(reg);
  if (r != null) return decodeURIComponent(r[2]);
  return null;
}
var redirecttourl = getQueryString('redirecttourl');
function oneKeyPopLogin(checkCtrol){//发送一键登录请求
    $.ajax({
        url: "../oneKeySignIn/login?checkCtrol="+checkCtrol,
        type: "GET",
        contentType: "application/json",
        dataType: "json",
        success: function(data) {
            // console.info(data);
            $("#oneLoginErrorTip").hide();
            if (redirecttourl) {
              window.location.replace(redirecttourl);
            } else {
              setTimeout(function(){
                window.location.replace(getCookie("lastUrl")?"../../.."+getCookie("lastUrl"):"../../personalHome/new/index");
              },1000);
            }
          gio('track', 'login', {'first_channel': channel, 'second_channel': secondChannel||' ', 'login_status': '0', 'login_result': '', 'authentication_type': '1'});
        },
        error: function () {
            $("#oneLoginErrorTip").show();
          gio('track', 'login', {'first_channel': channel, 'second_channel': secondChannel||' ', 'login_status': '1', 'login_result': '', 'authentication_type': '1'});
        }
    });
}
//一键免密登录，后端回掉函数
function getPhoneCallBack(callbpn){
    if(callbpn){
        if(channel == '30004'){
            oneKeyPopLogin(1);
        }else{
            $("#onekeyLoginPhone").text(callbpn);
            $(".onekeyLoginPop").show();
            gio('track', 'onekey_login', {'first_channel': channel, 'second_channel': secondChannel||' '});
            //bind事件
            //取消一键登录事件
            $(".noLogin,.colseBtn,.bdr1").click(function(){
                $(".onekeyLoginPop").hide();
            });
            //绑定一键登录事件
            $(".oneKeyPopLogin,.checkBottomName").click(function(){
                //是否勾选三天0不选，1选
                var checkCtrol=$(".checkCtl").hasClass("noCheck")?0:1;
                oneKeyPopLogin(checkCtrol);
            });
        }
    }
}
$(function() {
    //根据渠道处理
    var userAgent=navigator.userAgent;
    if (channel =='10086') {
        $("#toShortTerm,.checkCtl").show();
        if(/alipayclient/i.test(userAgent.toLowerCase())){
            $("#toPermanent,.vertical-line").show();
            $("#toPermanent").attr("href","https://t.alipayobjects.com/images/partner/T1IxxEXgJdXXbMsGbX.html");
        }else if(/micromessenger/i.test(userAgent.toLowerCase())){
            $("#toPermanent,.vertical-line").show();
            $("#toPermanent").attr("href","http://mp.weixin.qq.com/s/dHQUY-br1ISoerD6B2eajA");
        }else if(/ qq/i.test(userAgent.toLowerCase())){
             $("#toPermanent,.vertical-line").show();
             $("#toPermanent").attr("href","https://post.mp.qq.com/group/article/32353539343730303637-39198790.html?&_wv=2147483777&article_id=39198790&time=1498524600&sig=74ac9060667ff56cbce1349dd0cdb207");
        }else if(/weibo/i.test(userAgent.toLowerCase())){
            $("#toPermanent,.vertical-line").show();
            $("#toPermanent").attr("href","http://weibo.com/ttarticle/p/show?id=2309404123566718249204#_0");
        }else{
        }
    }

    //自适应处理
    function baseFit(mainHeight, footerHeight, winHeight, btmMargin) {
        var btmMg = btmMargin || 0;
        return mainHeight < winHeight - footerHeight ? winHeight - footerHeight - btmMg : mainHeight;
    }
    var mainHeight = $('.main').height();
    var footerHeight = $('.logHint').height();
    var winHeight = $(window).height()
    $('.main').height(baseFit(mainHeight, footerHeight, winHeight)-15);

    function showErr(obj, errMsg) {
        obj.val("").attr("placeholder", errMsg).addClass("err");
        if(obj.selector == '#code') $('#delCode').hide();
        else if(obj.selector == '#phone') $('#delPhone').hide();
    }
    //但仅有验证码没有电话号码时样式显示
    function errMsg(value) {
        switch (value) {
            case 1:
                return '请输入手机号码';
            case 2:
                return '验证码有误，请稍后重新获取';
            case 6002:
                return '验证码有误，请稍后重新获取';
            case 0:
                return '请输入6位验证码';
            case 6001:
                return '验证码有误，请稍后重新获取';
            case 8051:
                return '请输入中国移动手机号码';
            case 2046:
                return '您的账号已被锁定，请24小时后再次尝试！';
            case 8009:
                return '您的账号已被锁定，请24小时后再次尝试！';
            case 3:
                return '请输入6位验证码';
            default:
                return '';
        }
    }
    function toastealert(data){
        if(data.bindhevbdata.status === 1 && location.hash.indexOf('hevb') === -1){
            if (data.bindhevbdata.total > 0) {
                $(".hevbalert .hevbcon").text(data.bindhevbdata.descrip+'+'+data.bindhevbdata.total);
                var str = String(data.bindhevbdata.total),len = str.length,html = '';
                for (var i = 0;i < len ;i++) {
                    html += '<img src="../../images/hevb/'+str[i]+'.png">';
                }
                $(".hevbalert .hevbcoin").html(html);
                setTimeout(function(){
                    $(".hevbalert").show().animate({opacity:1},'slow').click(function(){
                        window.location.replace('../../hevbComplete/complete');
                    });
                },1000);
                setTimeout(function(){
                    $(".hevbalert").animate({opacity:0},'slow').hide("slow");
                },3000);
                location.hash = 'hevb';
                if (redirecttourl) {
                  window.location.replace(redirecttourl);
                } else {
                  setTimeout(function(){
                    window.location.replace(getCookie("lastUrl")?"../../.."+getCookie("lastUrl"):"../../personalHome/new/index");
                  },3500);
                }
            }
        }else{
          if (redirecttourl) {
            window.location.replace(redirecttourl);
          } else {
            window.location.replace(getCookie("lastUrl")?"../../.."+getCookie("lastUrl"):"../../personalHome/new/index");
          }
        }
    }
    //登录页面
    $(document).on('click', '#loginBtn', function(){
        if(!$(this).hasClass("disabled")){
            $("#loginBtn").addClass("disabled");
            $(".bind-pup").show();
            var re = new RegExp(" ", "g");
            var telephone = $.trim($('#phone').val()).replace(re, "");
            var checkpassword = $('#code').val();
            //是否勾选三天0不选，1选
            var checkCtrol=$(".checkCtl").hasClass("noCheck")?0:1;
            //短信登录接口
            var msgLoginUrl="../../bind/bindAccount/new";
            //语音验证码登录接口
            var voiceMsgLoginUrl="../../bind/bindAccount/voice";
            var getCodeUrl="";//实际请求的url
            //区分短信验证码和语音验证码
            if($(this).hasClass("voice")){
                getCodeUrl=voiceMsgLoginUrl;
              gio('track', 'login_button', {'first_channel': channel, 'second_channel': secondChannel||' ', 'authentication_type': '3'});
            }else{
                getCodeUrl=msgLoginUrl;
              gio('track', 'login_button', {'first_channel': channel, 'second_channel': secondChannel||' ', 'authentication_type': '2'});
            }
        …


</script>
<h2>Hello World!</h2>
用户名： ${user.userName}<br>
 密码：${user.userPassword}<br>
</body>
</html>