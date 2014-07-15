//
//  VTRuntime.m
//  VTCore
//
//  Created by zhangyu on 1/17/14.
//  Copyright (c) 2014 Raxtone. All rights reserved.
//

#import "VTRuntime.h"
#import <objc/runtime.h>



@implementation VTRuntime

+ (NSArray *)classMethodNamesWithClass:(Class)aClass
{
    if (aClass == Nil) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    
    unsigned int methodCount = 0;
    Method *methodList = class_copyMethodList(aClass, &methodCount);
    unsigned int i;
    for(i = 0; i < methodCount; i++)
        [array addObject: NSStringFromSelector(method_getName(methodList[i]))];
    free(methodList);
    
    return array;
}
@end