//
//  H5Container.h
//  JavaScriptCoreDemo
//
//  Created by JiaYuanFa on 16/6/15.
//  Copyright © 2016年 Jafar的MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface H5Container : NSObject

@property (nonatomic, copy) NSString *clientId; // 时间戳
@property (nonatomic, copy) NSString *func; // 方法名
@property (nonatomic, copy) NSString *msgType;  // 消息类型 只有两种 call callback
@property (nonatomic, copy) NSDictionary *param;    // 参数
@property (nonatomic, assign) BOOL keepCallback;    // 是否保持和上次相同的数据

@end
