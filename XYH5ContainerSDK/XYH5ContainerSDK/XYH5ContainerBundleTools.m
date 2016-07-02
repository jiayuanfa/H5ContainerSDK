//
//  XYH5ContainerBundleTools.m
//  XYH5ContainerSDK
//
//  Created by JiaYuanFa on 16/7/1.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

#import "XYH5ContainerBundleTools.h"

@implementation XYH5ContainerBundleTools

+ (NSBundle *)getBundle{
    
    return [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource: BUNDLE_NAME ofType: @"bundle"]];
}

+ (NSString *)getBundlePath:(NSString *)assetName{
    NSBundle *myBundle = [XYH5ContainerBundleTools getBundle];
    
    if (myBundle && assetName) {
        
        return [[myBundle resourcePath] stringByAppendingPathComponent:assetName];
    }
    
    return nil;
}

@end
