//
//  UITextField+VT.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "UITextField+VT.h"

@implementation UITextField (VT)

@end

@implementation VTDisPasteField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
    {
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}
//- (BOOL)canBecomeFirstResponder
//{
//    return YES;
//}
//- (BOOL)becomeFirstResponder
//{
//    if ([super becomeFirstResponder])
//    {
//        return YES;
//    }
//    return NO;
//}
- (void)paste:(id)sender
{
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    self.text = board.string;
    [self resignFirstResponder];
}

@end