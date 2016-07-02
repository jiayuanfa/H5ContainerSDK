//
//  WebViewController.m
//  JavaScriptCoreDemo
//
//  Created by Jafar on 16/6/13.
//  Copyright © 2016年 Jafar's Mac Pro. All rights reserved.
//

#import "XYH5ContainerVC.h"
#import "H5Container.h"
#import <objc/runtime.h>
#import "XYH5ContainerConfig.h"
#import "H5LaunchParamObject.h"
#import "XYH5ContainerTool.h"
#import <AudioToolbox/AudioToolbox.h>
#import "XYH5MessageHanderMgr.h"
#import "XYH5ContainerNavigationBar.h"
#import "XYH5ContainerBundleTools.h"

#define SCREEN_WIDTH self.view.bounds.size.width
#define SCREEN_HRIGHT self.view.bounds.size.height

typedef void(^Callback)(NSString *clientId, NSDictionary *param);

@interface XYH5ContainerVC ()<UIWebViewDelegate>

@property (nonatomic, assign) NSUInteger loadCount;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) H5Container *h5Container;
@property (nonatomic, strong) NSArray *allLaunchParamObjectArray;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) XYH5ContainerNavigationBar *navigationBar;

@property (nonatomic, copy) Callback checkJSApiCallback;    // 检查Api callback
@property (nonatomic, copy) Callback sendImageCallback; //发送图片
@property (nonatomic, copy) Callback downloadCallback;  // 下载数据

@end

@implementation XYH5ContainerVC

- (instancetype)initWebViewWithUrl:(NSURL *)url launchParam:(NSDictionary *)param{
    if (self = [super init]) {
        self.url = url;
        if (param) {
            self.launchParam = param;
        }
        [self initAllData];
    }
    return self;
}

- (void)initAllData{
        
    [self initAllLaunchParamObjectArray];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    imageView.center = self.view.center;
//    imageView.backgroundColor = [UIColor redColor];
//    imageView.image = [UIImage imageNamed:[XYH5ContainerBundleTools getBundlePath:@"xyh5container.jpg"]];
//    [self.view addSubview:imageView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNavigationBar];
    
    [self supportShake];
    
    [self initBackButton];
    
    [self initOptionMenu];
    
    [self initProgressView];
    
    [self initWebView];
    
    [self parseLaunchParamWithDic:self.launchParam];
}

#pragma mark - init navigationBar
- (void)initNavigationBar{
    self.navigationBar = [[[XYH5ContainerNavigationBar alloc] init] makeH5ContainerNavigationBarView];
    self.navigationBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [self.view addSubview:self.navigationBar];
    
    [self.navigationBar backBtnAddTarget:self action:@selector(backBtnAction)];
}

#pragma mark - pop action
- (void)backBtnAction{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        if (self.navigationItem.leftBarButtonItems.accessibilityElementCount == 1) {
            [self configColseItem];
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- supportShake
- (void)supportShake{
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
}

#pragma mark shake delegate
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    NSLog(@"摇到了");
    
    [self callWebWithFunctionName:@"watchShake" param:@{} isCallBack:NO];
}

#pragma mark -- initOptionMenu
- (void)initOptionMenu{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button setTitle:@"Menu" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBBI;
}

#pragma mark -- show navigationBar
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - set show titleBar
- (void)setShowTitleBar:(BOOL)showTitleBar{
    // 隐藏/显示导航栏
    [self.navigationController setNavigationBarHidden:!showTitleBar animated:YES];
    
    if (showTitleBar == NO) {
    }else{
    }
}

#pragma mark initBackButton
- (void)initBackButton{
    //    导航栏的返回按钮
    //    UIImage *backImage = [UIImage imageNamed:@"cc_webview_back"];
    //    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, 40, 22)];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [backBtn setTintColor:XYWEBVIEW_PROGRESS_COLOR];
    //    [backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = colseItem;
}

#pragma mark - backBtn onClick
- (void)backBtnPressed:(UIButton *)sender{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        if (self.navigationItem.leftBarButtonItems.accessibilityElementCount == 1) {
            [self configColseItem];
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 显示关闭按钮
- (void)configColseItem {
    
    // 导航栏的关闭按钮
    UIButton *colseBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [colseBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [colseBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [colseBtn addTarget:self action:@selector(colseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [colseBtn sizeToFit];
    
    UIBarButtonItem *colseItem = [[UIBarButtonItem alloc] initWithCustomView:colseBtn];
    NSMutableArray *newArr = [NSMutableArray arrayWithObjects:self.navigationItem.leftBarButtonItem,colseItem, nil];
    self.navigationItem.leftBarButtonItems = newArr;
}

#pragma mark -- close webView
- (void)colseBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - init progressView
- (void)initProgressView{
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    progressView.tintColor = [UIColor orangeColor];
    progressView.trackTintColor = [UIColor whiteColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

#pragma mark caculater progress value
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}


#pragma mark - init all launch param array
- (void)initAllLaunchParamObjectArray{
    H5LaunchParamObject *showTitleBarObject = [[H5LaunchParamObject alloc] init];
    showTitleBarObject.shotName = XYLAUNCH_SHOW_TITLE_BAR_SHORT_NAME;
    showTitleBarObject.longName = XYLAUNCH_SHOW_TITLE_BAR_LONG_NAME;
    showTitleBarObject.type = XYLAUNCH_LAUNCH_TYPE_BOOL;
    
    H5LaunchParamObject *showToolBarObject = [[H5LaunchParamObject alloc] init];
    showToolBarObject.shotName = XYLAUNCH_SHOW_TOOL_BAR_SHART_NAME;
    showToolBarObject.longName = XYLAUNCH_SHOW_TOOL_BAR_LONG_NAME;
    showToolBarObject.type = XYLAUNCH_LAUNCH_TYPE_BOOL;
    
    H5LaunchParamObject *showLoadingObject = [[H5LaunchParamObject alloc] init];
    showLoadingObject.shotName = XYLAUNCH_SHOW_LOADING_SHORT_NAME;
    showLoadingObject.longName = XYLAUNCH_SHOW_LOADING_LONG_NAME;
    showLoadingObject.type = XYLAUNCH_LAUNCH_TYPE_BOOL;
    
    H5LaunchParamObject *showReadTitleObject = [[H5LaunchParamObject alloc] init];
    showReadTitleObject.shotName = XYLAUNCH_READ_TITLE_SHORT_NAME;
    showReadTitleObject.longName = XYLAUNCH_READ_TITLE_LONG_NAME;
    showReadTitleObject.type = XYLAUNCH_LAUNCH_TYPE_BOOL;
    
    H5LaunchParamObject *pullRefreshObject = [[H5LaunchParamObject alloc] init];
    pullRefreshObject.shotName = XYLAUNCH_PULL_REFRESH_SHORT_NAME;
    pullRefreshObject.longName = XYLAUNCH_PULL_REFRESH_LONG_NAME;
    pullRefreshObject.type = XYLAUNCH_LAUNCH_TYPE_BOOL;
    
    H5LaunchParamObject *closeBtnObject = [[H5LaunchParamObject alloc] init];
    closeBtnObject.shotName = XYLAUNCH_CLOSE_BUTTON_TEXT_SHORT_NAME;
    closeBtnObject.longName = XYLAUNCH_CLOSE_BUTTON_TEXT_LONG_NAME;
    closeBtnObject.type = XYLAUNCH_LAUNCH_TYPE_BOOL;
    
    H5LaunchParamObject *showProgressObject = [[H5LaunchParamObject alloc] init];
    showProgressObject.shotName = XYLAUNCH_SHOW_PROGRESS_SHORT_NAME;
    showProgressObject.longName = XYLAUNCH__SHOW_PROGRESS_LONG_NAME;
    showProgressObject.type = XYLAUNCH_LAUNCH_TYPE_BOOL;
    
    H5LaunchParamObject *canPullDownObject = [[H5LaunchParamObject alloc] init];
    canPullDownObject.shotName = XYLAUNCH_CAN_PULL_DOWN_SHORT_NAME;
    canPullDownObject.longName = XYLAUNCH_CAN_PULL_DOWN_LONG_NAME;
    canPullDownObject.type = XYLAUNCH_LAUNCH_TYPE_BOOL;
    
    H5LaunchParamObject *backGroundObject = [[H5LaunchParamObject alloc] init];
    backGroundObject.shotName = XYLAUNCH_BACKGROUND_COLIR_SHORT_NAME;
    backGroundObject.longName = XYLAUNCH_BACKGROUND_COLIR_LONG_NAME;
    backGroundObject.type = XYLAUNCH_LAUNCH_TYPE_INT;
    
    self.allLaunchParamObjectArray = @[showTitleBarObject,showToolBarObject,showLoadingObject,showReadTitleObject,pullRefreshObject,closeBtnObject,showProgressObject,canPullDownObject,backGroundObject];
}

#pragma mark - init webView
- (void)initWebView{
    self.webView = [[UIWebView alloc] init];
    self.webView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HRIGHT - 64);
    self.webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    self.activityIndicatorView.center = self.view.center;
    [self.view addSubview:self.activityIndicatorView];
    
    [self.activityIndicatorView startAnimating];
}


#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.loadCount++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.loadCount--;
    
    [self.activityIndicatorView stopAnimating];
    
    [self.view insertSubview:self.webView belowSubview:self.progressView];
    
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    // 注入JS代码
    [self addJSClickEvent];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.loadCount--;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"shouldStartLoadWithRequest in:%@",request.URL.absoluteString);
    NSString *url = request.URL.absoluteString;
    
    NSString *dataGBK = [url stringByRemovingPercentEncoding];
    
    if(url != nil && [url hasPrefix:JS_STRING_URL_PRFIX])
    {
        if(dataGBK != nil && dataGBK.length > JS_STRING_URL_PRFIX.length)
        {
            // 获取json数据
            NSString *param = [dataGBK substringFromIndex:JS_STRING_URL_PRFIX.length];
            NSLog(@"param:%@",param);
            
            // 转为NSDictionary H5Container模型
            NSDictionary *dic = [XYH5ContainerTool objectFromJSONStringWithStr:param];
            if (!self.h5Container) {
                self.h5Container = [[H5Container alloc] init];
                self.h5Container.keepCallback = NO;    // default is YES;
            }
            
            [self.h5Container setValuesForKeysWithDictionary:dic];
            NSLog(@"url传递过来数据信息为%@",dic);
            
            // 解析
            [self parseWithH5Container:self.h5Container];
            
        }
        return NO;
    }
    return YES;
}

#pragma mark - parse launch param with launch dic
- (void)parseLaunchParamWithDic:(NSDictionary *)launchParam{
    NSLog(@"启动参数字典为%@",launchParam);
    NSMutableDictionary *launchParamDic = [NSMutableDictionary dictionary];
    for (H5LaunchParamObject *obj in self.allLaunchParamObjectArray) {
        if ([launchParam.allKeys containsObject:obj.shotName]) {
            // 给字典赋值 并调用API
            [launchParamDic setObject:launchParam[obj.shotName] forKey:obj.longName];
        }else if([launchParam.allKeys containsObject:obj.longName]){
            [launchParamDic setObject:launchParam[obj.longName] forKey:obj.longName];
        }
    }
    
    // 分发处理
    [self handleWithLaunchParamDic:launchParamDic];
}

#pragma mark - handle with launchParamDic
- (void)handleWithLaunchParamDic:(NSDictionary *)launchParamDic{
    for (NSString *key in launchParamDic.allKeys) {
        if ([key isEqualToString:@"showTitleBar"]) {
            // 处理
            [self setShowTitleBar:[launchParamDic[key] boolValue]];
            
        }else if ([key isEqualToString:@"showToolBar"]){
            
            [self setShowToolBar:[launchParamDic[key] boolValue]];
            
        }else if ([key isEqualToString:@"readTitle"]){
            
            [self setShowReadTitle:[launchParamDic[key] boolValue]];
            
        }else if ([key isEqualToString:@"showLoading"]){
            
            [self showLoding:[launchParamDic[key] boolValue]];
            
        }else if ([key isEqualToString:@"readTitle"]){
            
            [self setShowReadTitle:[launchParamDic[key] boolValue]];
            
        }else if ([key isEqualToString:@"pullRefresh"]){
            
            [self canPullRefresh:[launchParamDic[key] boolValue]];
            
        }else if ([key isEqualToString:@"closeButtonText"]){
            
            [self appearCloseButton:[launchParamDic[key] boolValue]];
            
        }else if ([key isEqualToString:@"showProgress"]){
            
            [self isShowProgress:[launchParamDic[key] boolValue]];
            
        }else if ([key isEqualToString:@"canPullDown"]){
            
            [self isCanPullDown:[launchParamDic[key] boolValue]];
            
        }else if ([key isEqualToString:@"backgroundColor"]){
            
            [self setWebViewBackgroundColor:[launchParamDic[key] intValue]];
        }
    }
}

#pragma mark -- set webView background color
- (void)setWebViewBackgroundColor:(int)color{
    // 设置背景颜色
}

#pragma mark -- is can pull down
- (void)isCanPullDown:(BOOL)canPullDown{
    if (canPullDown) {
        
    }else{
        
    }
}

#pragma mark -- is show progress
- (void)isShowProgress:(BOOL)isShowProgress{
    if (isShowProgress) {
        self.progressView.hidden = NO;
    }else{
        self.progressView.hidden = YES;
    }
}

#pragma mark - is appear Close Button
- (void)appearCloseButton:(BOOL)appearCloseBtn{
    if (appearCloseBtn) {
        // 显示关闭按钮
    }else{
        // 隐藏关闭按钮
    }
}

#pragma mark -- can pull refresh
- (void)canPullRefresh:(BOOL)refresh{
    if (refresh) {
        // 监听下拉手势，刷新webView
    }else{
        
    }
}

#pragma mark is show loading
- (void)showLoding:(BOOL)showLoading{
    self.activityIndicatorView.hidden = !showLoading;
}

#pragma mark - showToolBar
- (void)setShowToolBar:(BOOL)setShowToolBar{
    NSLog(@"是否显示ToolBar%d",setShowToolBar);
}

#pragma mark - showReadTitle
- (void)setShowReadTitle:(BOOL)readTitle{
    NSLog(@"是否显示title%d",readTitle);
    if (readTitle) {
        self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }else{
        self.title = nil;
    }
}

#pragma mark - parse url
- (NSDictionary *)parseUrlForNSDictionaryWithUrl:(NSString *)str{
    
    //用来作为函数的返回值，数组里里面可以存放每个url转换的字典
    NSArray *subArray = [str componentsSeparatedByString:@"&"];
    NSLog(@"&拆分之后为%@",subArray);
    //tempDic中存放一个URL中转换的键值对
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    
    for (int j = 0 ; j < subArray.count; j++)
    {
        //在通过=拆分键和值
        NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
        NSLog(@"再把每个参数通过=号进行拆分：\n%@", dicArray);
        //给字典加入元素
        [tempDic setObject:dicArray[1] forKey:dicArray[0]];
    }
    NSLog(@"打印参数列表生成的字典：\n%@", tempDic[@"st"]);
    return tempDic;
}


#pragma mark - parse parameter
- (void)parseWithH5Container:(H5Container *)h5Container{
    
    // 代理扔出
    if (self.delegate && [self.delegate respondsToSelector:@selector(reveiveMessageFormJS:params:)]) {
        [self.delegate reveiveMessageFormJS:h5Container.func params:h5Container.param];
    }
    
    if ([h5Container.func isEqualToString:XYJS_CALL_POP_WINDOW]) {
        
        [self popWindowWithParam:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_POP_TO]){
        // 三种方式 url index urlPattern
        [self popToPageWithParam:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_CHECK_JS_API]){
        
        [self checkApiWithParam:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_SHOW_TITLE_BAR]){
        
        [self setShowTitleBar:YES];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_HIDE_TITLE_BAR]){
        
        [self setShowTitleBar:NO];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_SHOW_OPTION_MENU]){
        
        [self showOptionMenu];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_HIDE_OPTION_MENU]){
        
        [self hideOptionMenu];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_SET_TITLE] && h5Container.param[@"title"] != nil){
        
        // 设置title
        [self setTitleWithParam:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_SET_TITLE] && h5Container.param[@"dropdownList"] != nil){
        // 设置下拉菜单
        [self setDropdownListWithParam:h5Container.param];
    }else if ([h5Container.func isEqualToString:XYJS_CALL_SET_OPTION_MENU]){
        
        // 设置右按钮属性
        [self setOptionMenuWithParam:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_SHOW_TOOL_BAR]){
        
        [self setShowToolBar:YES];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_HIDE_TOOL_BAR]){
        
        [self setShowToolBar:NO];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_TOAST]){
        
        // 设置右按钮属性
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_SET_TOOL_BAR_MENU]){
        
        // 设置工具栏菜单
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_ALERT]){
        
        [self showAlertWithParam:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_CONFIRM]){
        
        [self showConfirmWithParam:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_SHOW_LOADING]){
        
        [self showLodingWithParam:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_HIDE_LOADING]){
        
        [self hideLodingWithParam:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_PUSH_WINDOW]){
        
        [self pushWindowWithParam:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_CLOSE_WEBVIEW]){
        
        [self closeWebView];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_OPEN_IN_BROWSER]){
        
        [self openUrlInBrowserWithUrl:h5Container.param[@"url"]];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_GET_NETWORK_TYPE]){
        
        [self getNetworkType];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_VIBRATE]){
        
        [self vibrate];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_WATCH_SHAKE]){
        
        [self watchShake];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALL_RSA]){
        
        [self rsaWithContent:h5Container.param];
        
    }else if ([h5Container.func isEqualToString:XYJS_PHOTO]){
        
        [self postPhothBase64String];
        
    }else if ([h5Container.func isEqualToString:XYJS_CALLBACK]){
        
        [self handleCallbackWithParam:h5Container];
    }
}

- (void)sendImageToJSWithImage:(NSString *)imageStr functionName:(NSString *)functionName result:(void (^)(BOOL))result{
    
    // 发送图片信息 接口名 等等
    [self postPhothBase64String];
    
    self.sendImageCallback = ^(NSString *cliendId,NSDictionary *params){
        
        // 判断结果
        result(YES);    // 发送结果
    };
}

#pragma mark -- handle Callback 
- (void)handleCallbackWithParam:(H5Container *)h5Container{
    // 处理回调
    // clientId param  判断是不是和之前的clientId相同 如果是则分发回调事件处理
    if ([self.h5Container.clientId isEqualToString:h5Container.clientId]) {
        if ([h5Container.func isEqualToString:XYJS_CALL_CHECK_JS_API]) {
            // 调用回调
            self.checkJSApiCallback(h5Container.func,h5Container.param);
        }else if ([h5Container.func isEqualToString:XYJS_PHOTO]){
            self.sendImageCallback(h5Container.func,h5Container.param);
        }
    }
}

#pragma mark -- post photo base64 string
- (void)postPhothBase64String{
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"H5Resource" ofType:@"bundle"]];
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"detail" ofType:@"jpg"]];
    NSString *base64Str = [XYH5ContainerTool imageEncodeBase64DataURL:image];
    NSDictionary *photoParam = @{@"img":base64Str};
    NSLog(@"%@",photoParam);
    [self callWebWithFunctionName:XYJS_PHOTO param:photoParam isCallBack:YES];
}

#pragma mark -- close webView
- (void)closeWebView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- rsa
- (void)rsaWithContent:(NSDictionary *)content{
    /*
     * action : string  encrypt/加密 decrypt/解密
     * text : string  要处理的内容
     * key : string 密匙
     * return text : string 处理后的结果
     */
    
    NSLog(@"js rsa content %@",content);
}

#pragma mark -- 摇一摇
- (void)watchShake{
    NSLog(@"摇到啦！");
}

#pragma mark -- 震动
- (void)vibrate{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

#pragma mark -- 获取网络状态
- (void)getNetworkType{
    // send message to js
    // 1 : 当前时间 毫秒为单位  为了保持和安卓一致
    _h5Container.clientId = [XYH5ContainerTool timeWithCurrentTime];
    // 2 : 调用的方法  func
    _h5Container.func = XYJS_CALL_CHECK_JS_API;
    // 3 : param
    // 4 : msg_type
    _h5Container.msgType = @"callback";
    // 5: keep:callback
    _h5Container.keepCallback = YES;
    
    NSDictionary *networkType = @{@"err_msg":@"networktype:wifi",@"networkType":@"wifi",@"networkAvailable":@"1"};
    _h5Container.param = [networkType copy];
    
    // send to web
    [self sendToWebWithH5Container:_h5Container];

}

#pragma mark - 添加下拉菜单
- (void)setDropdownListWithParam:(NSDictionary *)param{
    // 创建下拉菜单
}

- (void)pushWindowWithParam:(NSDictionary *)param{
    XYH5ContainerVC *xyH5ContainerVC = [[XYH5ContainerVC alloc] initWebViewWithUrl:[NSURL URLWithString:param[@"url"]] launchParam:param[@"param"]];
    [self.navigationController pushViewController:xyH5ContainerVC animated:YES];
}

- (void)popWindowWithParam:(NSDictionary *)param{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - showLodingWithParam
- (void)showLodingWithParam:(NSDictionary *)dic{
    /*
     * dic:
     * text 小菊花文字
     * delay int 延迟多少秒后显示小菊花
     */
    
}

#pragma mark - hideLodingWithParam
- (void)hideLodingWithParam:(NSDictionary *)dic{
    // hide loding
    
    self.activityIndicatorView.hidden = YES;
}

#pragma mark - show alert with param
- (void)showAlertWithParam:(NSDictionary *)dic{
    // use XYAlertView
    /*
     * dic:
     * title alert框标题
     * message alert框文本
     * button 按钮文字  这里只能显示一个按钮
     */
}

#pragma mark - show confirm （选择对话框）
- (void)showConfirmWithParam:(NSDictionary *)dic{
    // use XYAlertView
    /*
     * dic:
     * title confirm框标题
     * message confirm框文本
     * okButton 确定按钮文字
     * cancleButton 取消按钮文字
     * callback 用户点击确定  调用sendToWeb h5Container.param参数加入 result.ok bool类型
     */
}

#pragma mark - check API
- (void)checkApiWithParam:(NSDictionary *)param{
    NSString *api = param[@"api"];
    
    NSDictionary *callbackParam = @{};
    
    if ([[XYH5MessageHanderMgr shareInstance] checkApiIsExistWithApi:api]) {
        callbackParam = @{@"available":@"1"};
    }else{
        callbackParam = @{@"available":@"0"};
    }
    
    // 处理回调
    self.checkJSApiCallback = ^(NSString *functionName, NSDictionary *param){
        NSLog(@"func is %@, param is %@",functionName,param);
    };
    
    // send to web
    [self callWebWithFunctionName:XYJS_CALL_CHECK_JS_API param:callbackParam isCallBack:YES];
}

#pragma mark - call web or callback web
- (void)callWebWithFunctionName:(NSString *)functionName param:(NSDictionary *)params isCallBack:(BOOL)isCallback{
    H5Container *paramObj = [[H5Container alloc] init];
    // 2 : 调用的方法  func
    paramObj.func = functionName;
    // 3 : param 转为jsonStr
    paramObj.param = params;
    // 4 : msg_type
    if (isCallback) {
        // clientId为之前的ClientId
        paramObj.msgType = @"callback";
        paramObj.clientId = self.h5Container.clientId;
    }else{
        paramObj.msgType = @"call";
        // 重设ClientId
        paramObj.clientId = [XYH5ContainerTool timeWithCurrentTime];
        self.h5Container.clientId = paramObj.clientId;
    }
    
    // send to web
    [self sendToWebWithH5Container:paramObj];
}

#pragma mark - send to web
- (void)sendToWebWithH5Container:(H5Container *)h5Container{
    // 把模型转为jsonStr
    NSString *jsonStr = [self JSONStringWithDic:[self dictionaryWithModel:h5Container]];
    
    // 发送给JS
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:XYOC_CALL_INVOKE_JS,jsonStr]];
}

#pragma mark - open url in browser
- (void)openUrlInBrowserWithUrl:(NSString *)url{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

#pragma mark - pop to page
- (void)popToPageWithParam:(NSDictionary *)param{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (param[@"index"]) {
        // base index pop
    }else if (param[@"url"]){
        // base url pop
    }else if (param[@"urlPattern"]){
        // base urlPattern pop
    }else{
        // 无效的跳转方式 发送给JS
    }
}

#pragma mark - set title
- (void)setTitleWithParam:(NSDictionary *)dic{
    if (dic[@"title"] != nil) {
        self.title = dic[@"title"];
    }
}


#pragma mark - hide option menu
- (void)hideOptionMenu{
    self.navigationItem.rightBarButtonItem.accessibilityElementsHidden = YES;
}

#pragma mark - show option menu
- (void)showOptionMenu{
    self.navigationItem.rightBarButtonItem.accessibilityElementsHidden = NO;
}

#pragma mark - Set Right Btn Property
- (void)setOptionMenuWithParam:(NSDictionary *)dic{
    if (dic[@"title"] != nil) {
        
        NSLog(@"right title is %@",dic[@"title"]);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 30);
        [button.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [button setTitle:dic[@"title"] forState:UIControlStateNormal];
        UIBarButtonItem *BBI = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = BBI;
        if (dic[@"icon"]) {
            // set image use sd_webImage
        }
    }
}


#pragma mark - NSString to NSDictionary
- (id)objectFromJSONStringWithStr:(NSString *)str{
    NSData *dataJSON = [str dataUsingEncoding: NSUTF8StringEncoding];
    if(dataJSON){
        return [NSJSONSerialization JSONObjectWithData:dataJSON options: 0 error:nil];
    }
    return nil;
}

#pragma mark - NSDictionary to JSONString for JS
- (NSString *)JSONStringWithDic:(NSDictionary *)dict{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    if (error == nil && jsonData != nil && [jsonData length] > 0){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        jsonString = [NSString stringWithFormat:@"\"%@\"",jsonString];
        return jsonString;
    }else{
        return nil;
    }
}

/*!
 * @brief 把对象（Model）转换成字典
 * @param model 模型对象
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithModel:(id)model {
    if (model == nil) {
        return nil;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    // 获取类名/根据类名获取类对象
    NSString *className = NSStringFromClass([model class]);
    id classObject = objc_getClass([className UTF8String]);
    
    // 获取所有属性
    unsigned int count = 0;
    objc_property_t *properties = class_copyPropertyList(classObject, &count);
    
    // 遍历所有属性
    for (int i = 0; i < count; i++) {
        // 取得属性
        objc_property_t property = properties[i];
        // 取得属性名
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        // 取得属性值
        id propertyValue = nil;
        id valueObject = [model valueForKey:propertyName];
        
        if ([valueObject isKindOfClass:[NSDictionary class]]) {
            propertyValue = [NSDictionary dictionaryWithDictionary:valueObject];
        } else if ([valueObject isKindOfClass:[NSArray class]]) {
            propertyValue = [NSArray arrayWithArray:valueObject];
        } else {
            propertyValue = [NSString stringWithFormat:@"%@", [model valueForKey:propertyName]];
        }
        
        [dict setObject:propertyValue forKey:propertyName];
    }
    return [dict copy];
}

#pragma mark -- 注入JS代码
- (void)addJSClickEvent{
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"ocTojs" ofType:@"js"];
//    NSString *jsStr = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:path] encoding:NSUTF8StringEncoding error:nil];
    // 转义
    
    NSString* result= [self.webView stringByEvaluatingJavaScriptFromString:JS_STRING];
    NSLog(@"%@",result);
}

#pragma mark - 发送下载进度给H5
- (void)sendDownProgress:(NSInteger)progress functionName:(NSString *)functionName result:(void (^)(BOOL))result{
    // 发送进度条消息给H5
    [self callWebWithFunctionName:@"progress" param:@{@"progress":[NSString stringWithFormat:@"%ld",(long)progress]} isCallBack:NO];
    
    // 监听下载结果
    self.downloadCallback = ^(NSString *clientId, NSDictionary *params){
      
        // 发送下载结果
        result(params[@"result"]);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
