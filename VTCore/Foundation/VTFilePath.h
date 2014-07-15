//
//  VTFilePath.h
//  VTZhangyu
//
//  Created by 张渝 on 13-4-2.
//  Copyright (c) 2013年 VIEWTOOL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTFilePath: NSObject

//app-document
+ (NSString *)documentFolder;
//app-caches
+ (NSString *)cachesFolder;

@end
