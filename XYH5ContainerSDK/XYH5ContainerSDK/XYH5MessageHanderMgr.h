//
//  XYH5MessageHanderMgr.h
//  JavaScriptCoreDemo
//
//  Created by JiaYuanFa on 16/6/23.
//  Copyright © 2016年 海立婷的MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYH5MessageHanderMgr : NSObject

+ (instancetype)shareInstance;

/**
 *  检查Api是否可用
 *
 *  @param api api
 *
 *  @return YES 可用 NO 不可用
 */
- (BOOL)checkApiIsExistWithApi:(NSString *)api;

@end
