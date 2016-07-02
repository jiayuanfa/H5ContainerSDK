//
//  XYH5ContainerTool.m
//  JavaScriptCoreDemo
//
//  Created by JiaYuanFa on 16/6/20.
//  Copyright © 2016年 Jafar的MacPro. All rights reserved.
//

#import "XYH5ContainerTool.h"
#import <objc/runtime.h>
#import "XYH5ContainerConfig.h"

@implementation XYH5ContainerTool

+ (id)objectFromJSONStringWithStr:(NSString *)str{
    NSData *dataJSON = [str dataUsingEncoding: NSUTF8StringEncoding];
    if(dataJSON){
        return [NSJSONSerialization JSONObjectWithData:dataJSON options: 0 error:nil];
    }
    return nil;
}

+ (NSString *)JSONStringWithDic:(NSDictionary *)dict{
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

+ (NSString *)timeWithCurrentTime{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a];
    return timeString;
}


+ (NSDictionary *)dictionaryWithModel:(id)model {
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


+ (NSDictionary *)parseLaunchUrl:(NSURL *)url{
    NSString *strUrl = url.absoluteString;
    NSString *dataGBK = [strUrl stringByRemovingPercentEncoding];
    
    //tempDic中存放一个URL中转换的键值对
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    
    if (strUrl != nil && [strUrl containsString:JS_LAUNCH_OPTIONS]){
        // 解析启动参数
        if(dataGBK != nil && dataGBK.length > JS_LAUNCH_OPTIONS.length)
        {
            // 获取json数据
            NSArray *array = [dataGBK componentsSeparatedByString:JS_LAUNCH_OPTIONS];
            NSString *param;
            if (array.count == 2) {
                param = array[1];
            }
            
            //用来作为函数的返回值，数组里里面可以存放每个url转换的字典
            NSArray *subArray = [param componentsSeparatedByString:@"&"];
            NSLog(@"&拆分之后为%@",subArray);
            
            for (int j = 0 ; j < subArray.count; j++)
            {
                //在通过=拆分键和值
                NSArray *dicArray = [subArray[j] componentsSeparatedByString:@"="];
                NSLog(@"再把每个参数通过=号进行拆分：\n%@", dicArray);
                //给字典加入元素
                [tempDic setObject:dicArray[1] forKey:dicArray[0]];
            }
        }
        
    }
    
    return tempDic;
}

/**
 *  通过Alpha值来判断是不是PNG格式的图片
 *
 *  @param image 图片
 *
 *  @return YES 是PNG格式的图片 NO不是PNG格式的图片
 */
+ (BOOL)imageHasAlpha:(UIImage *)image{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

/**
 *  image图片PNG格式转码
 *
 *  @param image Image
 *
 *  @return base64格式的图片
 */
+ (NSString *)imageEncodeBase64DataURL:(UIImage *)image
{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    
    if ([self imageHasAlpha: image]) {
        imageData = UIImagePNGRepresentation(image);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(image, 1.0f);
        mimeType = @"image/jpeg";
    }
    
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType,
            [imageData base64EncodedStringWithOptions: 0]];
}


@end
