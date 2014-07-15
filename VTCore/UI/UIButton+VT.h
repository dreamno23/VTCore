//
//  UIButton+VT.h
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (VT)
//一个字体..
- (void)initStyle;

//移除当前的所有action
- (void)removeActionsForControlEvents:(UIControlEvents)controlEvents;

//设置图片
- (void)setPath:(NSString *)path forState:(UIControlState)state;

//设置背景图片
- (void)setBackgroundPath:(NSString *)path forState:(UIControlState)state;

//设置图片，是否拉伸
- (void)setPath:(NSString *)path forState:(UIControlState)state stretch:(BOOL)stretchable;

//设置背景图片，是否拉伸
- (void)setBackgroundPath:(NSString *)path forState:(UIControlState)state stretch:(BOOL)stretchable;

//设置标题
- (void)setVTTitle:(NSString *)title;
@end
