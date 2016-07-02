//
//  XYH5ContainerNavigationBar.m
//  XYH5ContainerSDK
//
//  Created by JiaYuanFa on 16/7/1.
//  Copyright © 2016年 Jafar MacPro. All rights reserved.
//

#import "XYH5ContainerNavigationBar.h"
#import "XYH5ContainerBundleTools.h"

@interface XYH5ContainerNavigationBar()
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *MenuBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *closeBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation XYH5ContainerNavigationBar

- (instancetype)makeH5ContainerNavigationBarView{
    
    NSBundle *bundle = [XYH5ContainerBundleTools getBundle];
    
    return [[bundle loadNibNamed:@"XYH5ContainerNavigationBar" owner:self options:nil] lastObject];
}

- (void)menuBtnAddTarget:(id)target action:(SEL)action{
    [self.MenuBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)backBtnAddTarget:(id)target action:(SEL)action{
    [self.backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
