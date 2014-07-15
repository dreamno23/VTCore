//
//  UIView+VT.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-1.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "UIView+VT.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (VT)

- (UIImage *)layerImage
{
    UIImage* newImage = nil;
    CGSize contextSize = self.bounds.size;
    UIGraphicsBeginImageContext(contextSize);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.layer.contents = nil;
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)setCornerRadius:(CGFloat)radius
            borderColor:(UIColor *)borderColor
            borderWidth:(CGFloat)borderWidth
{
    [[self layer] setMasksToBounds:YES];
    [[self layer] setCornerRadius:radius];
    [[self layer] setBorderColor:[borderColor CGColor]];
    [[self layer] setBorderWidth:borderWidth];
}

+ (instancetype)viewWithClass:(Class)aClass inFrame:(CGRect)af bgColor:(UIColor *)aC
{
    
    id ins = [[aClass alloc] initWithFrame:af];
    [ins setBackgroundColor:aC==nil?[UIColor clearColor]:aC];
    return ins;
}
@end
