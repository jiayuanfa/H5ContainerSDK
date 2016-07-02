//
//  XYH5ContainerNavigationBar.h
//  XYH5ContainerSDK
//
//  Created by JiaYuanFa on 16/7/1.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYH5ContainerNavigationBar : UIView

- (instancetype)makeH5ContainerNavigationBarView;

- (void)menuBtnAddTarget:(id)target action:(SEL)action;

- (void)backBtnAddTarget:(id)target action:(SEL)action;

@end
