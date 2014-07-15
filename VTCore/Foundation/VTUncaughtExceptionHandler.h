//
//  VTUncaughtExceptionHandler.h
//  VTCore
//
//  Created by zhangyu on 14-4-8.
//  Copyright (c) 2014年 Raxtone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VTException : NSException

@property (nonatomic, readonly) NSArray *backtraces;

@end
@interface VTSignalException : VTException
@property (nonatomic, readonly) NSInteger signalSt; //信号异常编号
@end

//初始哈异常捕获
void vtInstallUncaughtExceptionHandler(void (^aHandler)(VTException *aException));