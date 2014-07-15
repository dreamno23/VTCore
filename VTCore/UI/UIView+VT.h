//
//  UIView+VT.h
//  VTZhangyu
//
//  Created by 张渝 on 13-4-1.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (VT)

//获取view的当前截图
- (UIImage *)layerImage;

//设置边框
- (void)setCornerRadius:(CGFloat)radius
            borderColor:(UIColor *)borderColor
            borderWidth:(CGFloat)borderWidth;

//创建一个view
+ (instancetype)viewWithClass:(Class)aClass inFrame:(CGRect)af bgColor:(UIColor *)aC;
@end
