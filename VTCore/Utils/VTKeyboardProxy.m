//
//  VTKeyboardProxy.m
//  Flynavi
//
//  Created by zhangyu on 13-10-24.
//  Copyright (c) 2013年 Raxtone. All rights reserved.
//

#import "VTKeyboardProxy.h"

@interface VTKeyboardProxy()
@property(nonatomic, strong) UIView *responseView;
@property(nonatomic, strong) UIView *adjustedView;
@property(nonatomic, assign) CGPoint keybordXY;
@end

@implementation VTKeyboardProxy
@synthesize responseView;
@synthesize adjustedView;
@synthesize keybordXY;

- (void)registerKeybordNotify
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillShow:)
                          name:UIKeyboardWillShowNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillChanged:)
                          name:UIKeyboardWillChangeFrameNotification
                        object:nil];
    
    [defaultCenter addObserver:self
                      selector:@selector(keyboardWillHide:)
                          name:UIKeyboardWillHideNotification
                        object:nil];
}

- (void)unregisterKeybordNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSValue *value = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    [self setKeybordXY:[window convertPoint:[value CGRectValue].origin toWindow:window]];
    [self adjust];
}
- (void)keyboardWillChanged:(NSNotification *)notification
{
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:.2f
                     animations:^(void){
                         [adjustedView setTransform:CGAffineTransformMakeTranslation(0.f, 0.f)];
                     }
                     completion:^(BOOL finised){}];
    [self setResponseView:nil];
    [self setAdjustedView:nil];
}

- (void)adjust:(UIView *)adjuster with:(UIView *)responser
{
    BOOL shown = (nil != [self responseView]);
    if (shown) {
        if (![adjustedView isEqual:adjuster]) {
            //键盘出现过，先恢复原来的
            [adjustedView setTransform:CGAffineTransformMakeTranslation(0.f, 0.f)];
        }
    }
    [self setAdjustedView:adjuster];
    [self setResponseView:responser];
    if (shown) {
        [self adjust];
    }
}

- (void)hideKeybord
{
    [responseView resignFirstResponder];
}

- (void)adjust
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [[responseView superview] convertRect:[responseView frame] toView:window];
    CGFloat curTy = adjustedView.transform.ty;
    if ((rect.origin.y + rect.size.height - curTy) >= keybordXY.y) {
        CGFloat offset = keybordXY.y - (rect.origin.y + rect.size.height - curTy + 10.f);
        [UIView animateWithDuration:.2f
                         animations:^(void){
                             [adjustedView setTransform:CGAffineTransformMakeTranslation(0.f, offset)];
                         }
                         completion:^(BOOL finised){}];
    } else {
        [UIView animateWithDuration:.2f
                         animations:^(void){
                             [adjustedView setTransform:CGAffineTransformMakeTranslation(0.f, 0.f)];
                         }
                         completion:^(BOOL finised){}];
    }
}
+ (VTKeyboardProxy *)shared
{
    static VTKeyboardProxy *instance = nil;
    if (nil == instance) {
        instance = [[VTKeyboardProxy alloc] init];
    }
    return instance;
}
@end