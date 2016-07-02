//
//  XYH5MessageHanderMgr.m
//  JavaScriptCoreDemo
//
//  Created by JiaYuanFa on 16/6/23.
//  Copyright © 2016年 海立婷的MacPro. All rights reserved.
//

#import "XYH5MessageHanderMgr.h"
#import "XYH5ContainerConfig.h"
#import "XYH5ContainerTool.h"

@interface XYH5MessageHanderMgr()

@property (nonatomic, strong) NSArray *allApiArray;
@property (nonatomic, strong) NSArray *allLaunchParamObjectArray;

@end

@implementation XYH5MessageHanderMgr

static XYH5MessageHanderMgr *msgHanderMgr;

+ (instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msgHanderMgr = [[XYH5MessageHanderMgr alloc] init];
    });
    
    return msgHanderMgr;
}

- (BOOL)checkApiIsExistWithApi:(NSString *)api{
    
    self.allApiArray = @[XYJS_CALL_CHECK_JS_API,XYJS_CALL_POP_WINDOW,XYJS_CALL_POP_TO,XYOC_CALL_BACK,XYJS_CALL_SHOW_TITLE_BAR,XYJS_CALL_HIDE_TITLE_BAR,XYJS_CALL_SHOW_OPTION_MENU,XYJS_CALL_HIDE_OPTION_MENU,XYJS_CALL_SET_TITLE,XYJS_CALL_SET_OPTION_MENU,XYJS_CALL_TOAST,XYJS_CALL_SHOW_TOOL_BAR,XYJS_CALL_HIDE_TOOL_BAR,XYJS_CALL_SET_TOOL_BAR_MENU,XYJS_CALL_ALERT,XYJS_CALL_CONFIRM,XYJS_CALL_SHOW_LOADING,XYJS_CALL_HIDE_LOADING,XYJS_CALL_OPEN_IN_BROWSER,XYJS_CALL_PUSH_WINDOW,XYJS_CALL_CLOSE_WEBVIEW,XYJS_CALL_GET_NETWORK_TYPE,XYJS_CALL_VIBRATE,XYJS_CALL_WATCH_SHAKE,XYJS_CALL_RSA,XYJS_PHOTO];
    
    if ([self.allApiArray containsObject:api]) {

        return YES;
    }else{
        return NO;
    }
}


@end
