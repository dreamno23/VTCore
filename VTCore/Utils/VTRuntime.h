//
//  VTRuntime.h
//  VTCore
//
//  Created by zhangyu on 1/17/14.
//  Copyright (c) 2014 Raxtone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTRuntime : NSObject

//获取一个类的所有方法名称NSString
+ (NSArray *)classMethodNamesWithClass:(Class)aClass;
@end
