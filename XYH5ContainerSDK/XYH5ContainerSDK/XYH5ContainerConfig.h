//
//  XYH5ContainerConfig.h
//  JavaScriptCoreDemo
//
//  Created by JiaYuanFa on 16/6/20.
//  Copyright © 2016年 Jafar的MacPro. All rights reserved.
//

#ifndef XYH5ContainerConfig_h
#define XYH5ContainerConfig_h

// 要导入的JS代码"号用\转义才能识别
#define JS_STRING @"var JSBridge = {}; var callbackPoll = {}; (function initialize() { JSBridge.call = function (func, param, callback) { if ('string' !== typeof func) { return; } if ('function' === typeof param) { callback = param; param = null; } else if (typeof param !== 'object') { param = null; } var clientId = '' + new Date().getTime() + (Math.random()); if ('function' === typeof callback) { callbackPoll[clientId] = callback; } var invokeMsg = JSON.stringify({ func: func, param: param, msgType: 'call', clientId: clientId }); var url =\"http://xiaoying/clickevent?param=\"+invokeMsg; document.location = url; return url;}; JSBridge.callback = function(clientId, param) { var invokeMsg = JSON.stringify({ clientId: clientId, param: param }); var url = \"http://xiaoying/clickevent?param=\" + invokeMsg; document.location = url; return url;}; JSBridge.trigger = function(name, param, clientId) { console.log('bridge.trigger ' + name); if (name) { var evt = document.createEvent('Events'); evt.initEvent(name, false, true); if (typeof param === 'object') { for (var k in param) { evt[k] = param[k]; } } evt.clientId = clientId; console.log(evt.progress); var prevent = !document.dispatchEvent(evt); if (clientId && name === 'back') { JSBridge.callback(clientId, { prevent: prevent }); } } }; JSBridge._invokeJS = function(resp) {console.log(resp);resp = JSON.parse(resp); console.log(\"invokeJS msgType \" + resp.msgType + \" func \" + resp.func); console.log('parse end.'); if (resp.msgType === 'callback') { var func = callbackPoll[resp.clientId]; if (! (typeof resp.keepCallback == 'boolean' && resp.keepCallback)) { delete callbackPoll[resp.clientId]; } if ('function' === typeof func) { setTimeout(function() { func(resp.param); }, 1); } } else if (resp.msgType === 'call') { resp.func && this.trigger(resp.func, resp.param, resp.clientId); } }; JSBridge.startupParams = '{startupParams}'; var readyEvent = document.createEvent('Events'); readyEvent.initEvent('JSBridgeReady', false, false); var docAddEventListener = document.addEventListener; document.addEventListener = function(name, func) { console.log(docAddEventListener); if (name === readyEvent.type) { setTimeout(function() { func(readyEvent); }, 1); } else { docAddEventListener.apply(document, arguments); console.log(arguments); } }; document.dispatchEvent(readyEvent); })();"      // 该js代码创建了一个JSBridge对象，call方法，以及监听回调方法。供H5调用。

#define XYWEBVIEW_PROGRESS_COLOR [UIColor orangeColor]
#define JS_STRING_URL_PRFIX  @"http://xiaoying/clickevent?param="   // 调用方法
#define JS_LAUNCH_OPTIONS    @"__webview_options__=" // 启动参数

#define JS_STRING_IMAGE_NEW @"var JSCaller = {}; (function initialize() { JSCaller.execute = function (clickEvent,clickParam) { alert(1111);var picture_obj_src;picture_obj_src=\"%@\";var picture_obj={'src':picture_obj_src};var pic=document.getElementById('picture_img');alert(2222);pic.setAttribute('src',picture_obj.src);alert(3333+picture_obj.src+'--'+pic); alert(444+ document.images[0].src);   }})()"

#define XYJS_CALL_CHECK_JS_API             @"checkJSAPI"
#define XYJS_CALL_SET_TITLE                @"setTitle"
#define XYJS_CALL_HIDE_OPTION_MENU         @"hideOptionMenu"
#define XYJS_CALL_SHOW_OPTION_MENU         @"showOptionMenu"
#define XYJS_CALL_SET_OPTION_MENU          @"setOptionMenu"
#define XYJS_CALL_ALERT                    @"alert"
#define XYJS_CALL_CONFIRM                  @"confirm"
#define XYJS_CALL_SHOW_LOADING             @"showLoading"
#define XYJS_CALL_HIDE_LOADING             @"hideLoading"
#define XYJS_CALL_POP_TO                   @"popTo"               // 退回到指定界面
#define XYJS_CALL_OPEN_IN_BROWSER          @"openInBrowser"       // 在浏览器中打开
#define XYJS_CALL_PUSH_WINDOW              @"pushWindow"
#define XYJS_CALL_POP_WINDOW               @"popWindow"
#define XYJS_CALL_CLOSE_WEBVIEW            @"closeWebview"
#define XYJS_CALL_GET_NETWORK_TYPE         @"getNetworkType"      // 获取网络状态 使用reachAbility实现
#define XYJS_CALL_VIBRATE                  @"vibrate"             // 震动
#define XYJS_CALL_WATCH_SHAKE              @"watchShake"          // 摇一摇
#define XYJS_CALL_TOAST                    @"toast"
#define XYJS_CALL_TOOL_BAR_MENU_CLICK      @"toolbarMenuClick"
#define XYJS_CALL_SHOW_TITLE_BAR           @"showTitlebar"
#define XYJS_CALL_HIDE_TITLE_BAR           @"hideTitlebar"
#define XYJS_CALL_SHOW_TOOL_BAR            @"showToolbar"
#define XYJS_CALL_HIDE_TOOL_BAR            @"hideToolbar"
#define XYJS_CALL_TOAST                    @"toast"
#define XYJS_CALL_SET_TOOL_BAR_MENU        @"setToolbarMenu"
#define XYJS_CALL_RSA                      @"rsa"
#define XYJS_PHOTO                         @"photo"
#define XYJS_CALLBACK                      @"callback"
#define XYJS_DOWNLOAD                      @"download"

// 监听 OC to JS
#define XYOC_CALL_DROPDOWN_LIST_EVENT      @"dropdownListEvent"
#define XYOC_CALL_BACK                     @"back"
#define XYOC_CALL_INVOKE_JS                @"JSBridge._invokeJS(%@)"  // OC call or callback func


#define XYLAUNCH_SHOW_TITLE_BAR_SHORT_NAME                  @"st"; // 是否显示TitleBar default is YES
#define XYLAUNCH_SHOW_TOOL_BAR_SHART_NAME                   @"sb"; // 是否显示ToolBar  default is NO
#define XYLAUNCH_SHOW_LOADING_SHORT_NAME                    @"sl"; // 是否显示菊花      default is NO
#define XYLAUNCH_READ_TITLE_SHORT_NAME                      @"rt"; // 是否显示Title    default is YES
#define XYLAUNCH_PULL_REFRESH_SHORT_NAME                    @"pr"; // 是否支持下拉刷新  default is NO
#define XYLAUNCH_CLOSE_BUTTON_TEXT_SHORT_NAME               @"cb"; // 是否显示关闭按钮  default is nil
#define XYLAUNCH_SHOW_PROGRESS_SHORT_NAME                   @"sp"; // 是否显示进度条    default is NO
#define XYLAUNCH_CAN_PULL_DOWN_SHORT_NAME                   @"pd"; // 是否可以下拉      default is YES
#define XYLAUNCH_BACKGROUND_COLIR_SHORT_NAME                @"bc"; // Webview背景色    default is 0
#define XYLAUNCH_SHOW_TITLE_BAR_LONG_NAME                   @"showTitleBar"; // 是否显示TitleBar default is YES
#define XYLAUNCH_SHOW_TOOL_BAR_LONG_NAME                    @"showToolBar"; // 是否显示ToolBar  default is NO
#define XYLAUNCH_SHOW_LOADING_LONG_NAME                     @"showLoading"; // 是否显示菊花      default is NO
#define XYLAUNCH_READ_TITLE_LONG_NAME                       @"readTitle"; // 是否显示Title    default is YES
#define XYLAUNCH_PULL_REFRESH_LONG_NAME                     @"pullRefresh"; // 是否支持下拉刷新  default is NO
#define XYLAUNCH_CLOSE_BUTTON_TEXT_LONG_NAME                @"closeButtonText"; // 是否显示关闭按钮  default is nil
#define XYLAUNCH__SHOW_PROGRESS_LONG_NAME                    @"showProgress"; // 是否显示进度条    default is NO
#define XYLAUNCH_CAN_PULL_DOWN_LONG_NAME                    @"canPullDown"; // 是否可以下拉      default is YES
#define XYLAUNCH_BACKGROUND_COLIR_LONG_NAME                 @"backgroundColor"; // Webview背景色    default is 0
#define XYLAUNCH_LAUNCH_TYPE_BOOL                           @"bool"
#define XYLAUNCH_LAUNCH_TYPE_INT                            @"int"

#endif /* XYH5ContainerConfig_h */
