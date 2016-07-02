//
//  WebViewController.h
//  JavaScriptCoreDemo
//
//  Created by Jafar on 16/6/13.
//  Copyright © 2016年 Jafar's Mac Pro. All rights reserved.
//

/**
 *  素材中心需要解决的问题
 *  第一：Native下载实时反馈给H5 下载回调的时候 发送下载进度给H5
 *  第二：导航栏 右上角按钮 H5定制
 */

#import <UIKit/UIKit.h>

@protocol H5ContainerDelegate <NSObject>

/**
 *  当Native收到消息JS调用的时候调用此方法
 *
 *  @param functionName 接口名称
 *  @param params       参数
 */
- (void)reveiveMessageFormJS:(NSString *)functionName params:(NSDictionary *)params;


@end

@interface XYH5ContainerVC : UIViewController

/**
 *  初始化一个WebVC
 *
 *  @param url   url
 *  @param param 启动参数
 *
 *  @return webVC
 */
- (instancetype)initWebViewWithUrl:(NSURL *)url launchParam:(NSDictionary *)param;

/**
 *  向H5发送图片 名称 参数 得到回调结果
 *
 *  @param imageStr     图片信息
 *  @param functionName 接口名称
 *  @param result       结果
 */
- (void)sendImageToJSWithImage:(NSString *)imageStr functionName:(NSString *)functionName result:(void(^)(BOOL result))result;

/**
 *  发送下载进度给H5
 *
 *  @param progress     进度
 *  @param functionName 接口名
 *  @param result       结果
 */
- (void)sendDownProgress:(NSInteger)progress functionName:(NSString *)functionName result:(void(^)(BOOL result))result;


@property (nonatomic, copy) NSURL *url;
@property (nonatomic, strong) NSDictionary *launchParam;

@property (nonatomic, weak) id<H5ContainerDelegate> delegate;

@end
