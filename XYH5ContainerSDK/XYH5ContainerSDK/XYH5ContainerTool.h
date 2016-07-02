//
//  XYH5ContainerTool.h
//  JavaScriptCoreDemo
//
//  Created by JiaYuanFa on 16/6/20.
//  Copyright © 2016年 Jafar的MacPro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XYH5ContainerTool : NSObject

/*
 * NSString to NSDictionary
 */
+ (id)objectFromJSONStringWithStr:(NSString *)str;

/**
 *  字典转带转移符的json
 *
 *  @param dict 字典
 *
 *  @return 带转义符的json字符串
 */
+ (NSString *)JSONStringWithDic:(NSDictionary *)dict;

/**
 *  获取当前时间戳
 *
 *  @return 时间戳
 */
+ (NSString *)timeWithCurrentTime;

/*!
 * @brief 把对象（Model）转换成字典
 * @param model 模型对象
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithModel:(id)model;

/*
 * 解析url启动参数
 */
+ (NSDictionary *)parseLaunchUrl:(NSURL *)url;

/**
 *  图片base64转码
 *
 *  @param image image
 *
 *  @return base64 string
 */
+ (NSString *)imageEncodeBase64DataURL:(UIImage *)image;

@end
