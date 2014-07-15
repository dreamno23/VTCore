//
//  UIWebView+VT.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "UIWebView+VT.h"

@implementation UIWebView (VT)
- (void)initStyle
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self setOpaque:NO];
    if ([[[self subviews] objectAtIndex:0] isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView *)[[self subviews] objectAtIndex:0] setBounces:NO];
    }
}
@end
