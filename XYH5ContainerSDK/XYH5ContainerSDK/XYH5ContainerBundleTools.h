//
//  XYH5ContainerBundleTools.h
//  XYH5ContainerSDK
//
//  Created by JiaYuanFa on 16/7/1.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//
/**
 *  资源获取类
 */

#import <Foundation/Foundation.h>

#define BUNDLE_NAME @"XYH5Container"

@interface XYH5ContainerBundleTools : NSObject

/**
 *  获取Bundle
 *
 *  @return Bundle
 */
+ (NSBundle *)getBundle;

/**
 *  获取Bundle资源路径
 *
 *  @param assetName 资源名称
 *
 *  @return 资源路径
 */
+ (NSString *)getBundlePath: (NSString *) assetName;

@end
