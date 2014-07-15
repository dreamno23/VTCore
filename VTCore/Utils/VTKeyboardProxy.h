//
//  VTKeyboardProxy.h
//  Flynavi
//
//  Created by zhangyu on 13-10-24.
//  Copyright (c) 2013年 Raxtone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTKeyboardProxy : NSObject
//注册对键盘事件的接受
- (void)registerKeybordNotify;
//取消对键盘事件的接受
- (void)unregisterKeybordNotify;
//相对于responser调整adjuster
- (void)adjust:(UIView *)adjuster with:(UIView *)responser;
//隐藏键盘
- (void)hideKeybord;

+ (VTKeyboardProxy *)shared;
@end