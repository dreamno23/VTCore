//
//  VTFilePath.m
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import "VTFilePath.h"

@implementation VTFilePath

+ (NSString *)documentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)cachesFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

//if (![fileManager fileExistsAtPath:gdPath]) {
//    [fileManager createDirectoryAtPath:gdPath withIntermediateDirectories:YES attributes:nil error:nil];
//}
@end
