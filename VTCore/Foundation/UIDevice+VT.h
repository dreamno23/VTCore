//
//  UIDevice+VT.h
//  VTCore
//
//  Created by zhangyu on 1/17/14.
//  Copyright (c) 2014 Raxtone. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAPPUsePrivateApi (1)

@interface UIDevice (VT)
//唯一码,根据是否使用私有api来决定到底是uuid还是avid
- (NSString *)uuid;

@end
