    // 创建JSBridge对象
    var JSBridge = {};
    var callbackPoll = {};
    (function initialize() {
    // call方法
    JSBridge.call = function(func, param, callback) {
    if ('string' !== typeof func) {
    return;
    }
    if ('function' === typeof param) {
    callback = param;
    param = null;
    } else if (typeof param !== 'object') { param = null; }
    var clientId = '' + new Date().getTime() + (Math.random());
    if ('function' === typeof callback) { callbackPoll[clientId] = callback; }
    // 组装json数据 发送给native
    var invokeMsg = JSON.stringify({ func: func, param: param, msgType: 'call', clientId: clientId });
    var url = "http://xiaoying/clickevent?param=" + invokeMsg;
    // 通过改变document.location来实现数据传递 iOS端在startLoad截取解析
    document.location = url;
    return url;
    };
    // 回调方法 传入clientId param
    JSBridge.callback = function(clientId, param) {
    var invokeMsg = JSON.stringify({ clientId: clientId, param: param });
    var url = "http://xiaoying/clickevent?param=" + invokeMsg;
    document.location = url;
    return url;
    };
    JSBridge.trigger = function(name, param, clientId) {
    console.log('bridge.trigger ' + name);
    if (name) {
    var evt = document.createEvent('Events');
    evt.initEvent(name, false, true);
    if (typeof param === 'object') {
    for (var k in param) { evt[k] = param[k]; }
    }
    evt.clientId = clientId;
    var prevent = !document.dispatchEvent(evt);
    if (clientId && name === 'back') { JSBridge.callback(clientId, { prevent: prevent }); }
    }
    };
    // native端调用此方法发送数据即可
    JSBridge._invokeJS = function(resp) {
    console.log(resp);
    resp = JSON.parse(resp);
    console.log("invokeJS msgType " + resp.msgType + " func " + resp.func);
    console.log('parse end.');
    if (resp.msgType === 'callback') {
    var func = callbackPoll[resp.clientId];
    if (!(typeof resp.keepCallback == 'boolean' && resp.keepCallback)) { delete callbackPoll[resp.clientId]; }
    if ('function' === typeof func) { setTimeout(function() { func(resp.param); }, 1); }
    } else if (resp.msgType === 'call') { resp.func && this.trigger(resp.func, resp.param, resp.clientId); }
    };
    JSBridge.startupParams = '{startupParams}';
    var readyEvent = document.createEvent('Events');
    readyEvent.initEvent('JSBridgeReady', false, false);
    var docAddEventListener = document.addEventListener;

    // js添加监听方法  name func即可  native传递数据即可
    document.addEventListener = function(name, func) {
     console.log(docAddEventListener);
    if (name === readyEvent.type) {
    setTimeout(function() {
            func(readyEvent);
            }, 1);
    } else {
    docAddEventListener.apply(document, arguments);
    }
    };
    document.dispatchEvent(readyEvent);
    })();
