//
//  UIButton+VT.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "UIButton+VT.h"

@implementation UIButton (VT)

- (void)initStyle
{
    [[self titleLabel] setFont:[UIFont systemFontOfSize:16.f]];
}

- (void)removeActionsForControlEvents:(UIControlEvents)controlEvents
{
    NSArray *targetArray = [[self allTargets] allObjects];
    for (id target in targetArray) {
        [self removeTarget:target action:NULL forControlEvents:controlEvents];
    }
}

- (void)setPath:(NSString *)path forState:(UIControlState)state
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    [self setImage:image forState:state];
}

- (void)setBackgroundPath:(NSString *)path forState:(UIControlState)state
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    [self setBackgroundImage:image forState:state];
}

- (void)setPath:(NSString *)path forState:(UIControlState)state stretch:(BOOL)stretchable
{
    if (stretchable) {
        CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        UIGraphicsBeginImageContext(size);
        [[image stretchableImageWithLeftCapWidth:[image size].width / 2. topCapHeight:0.f]
         drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeCopy alpha:1.f];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setImage:image forState:state];
    } else {
        UIImage *aImage = [[UIImage alloc] initWithContentsOfFile:path];
        [self setImage:aImage forState:state];
    }
}

- (void)setBackgroundPath:(NSString *)path forState:(UIControlState)state stretch:(BOOL)stretchable
{
    if (stretchable) {
        CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        UIGraphicsBeginImageContext(size);
        [[image stretchableImageWithLeftCapWidth:[image size].width / 2. topCapHeight:0.f]
         drawInRect:CGRectMake(0, 0, size.width, size.height) blendMode:kCGBlendModeCopy alpha:1.f];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setBackgroundImage:image forState:state];
    } else {
        UIImage *aImage = [[UIImage alloc] initWithContentsOfFile:path];
        [self setBackgroundImage:aImage forState:state];
    }
}

- (void)setVTTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateDisabled];
}
@end
