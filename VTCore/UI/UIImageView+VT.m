//
//  UIImageView+VT.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "UIImageView+VT.h"

@implementation UIImageView (VT)
- (void)setPath:(NSString *)path
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    [self setImage:image];
}

- (void)setHighlightedPath:(NSString *)path
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    [self setHighlightedImage:image];
}
@end
