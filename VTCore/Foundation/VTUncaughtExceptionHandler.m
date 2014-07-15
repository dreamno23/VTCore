//
//  VTUncaughtExceptionHandler.m
//  VTCore
//
//  Created by zhangyu on 14-4-8.
//  Copyright (c) 2014年 Raxtone. All rights reserved.
//

#import "VTUncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
static void (^globolHandler)(VTException *aException);
void HandleException(NSException *exception);
void SignalHandler(int signal);
NSArray *getCurrentBacktrace (void);


volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 4;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 5;

NSArray *getCurrentBacktrace()
{
    void* callstack[128];
    int frames = backtrace(callstack, 128);
    char **strs = backtrace_symbols(callstack, frames);
    
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (
         i = UncaughtExceptionHandlerSkipAddressCount;
         i < UncaughtExceptionHandlerSkipAddressCount +
         UncaughtExceptionHandlerReportAddressCount;
         i++)
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    
    return backtrace;
}
@interface VTException()
@property (nonatomic, strong) NSArray *backtraces;
@end
@implementation VTException
+ (VTException *)exceptionWithName:(NSString *)name reason:(NSString *)reason userInfo:(NSDictionary *)userInfo backtrace:(NSArray *)abt
{
    return [[self alloc]initWithName:name reason:reason userInfo:userInfo backtrace:abt];
}
- (id)initWithName:(NSString *)aName reason:(NSString *)aReason userInfo:(NSDictionary *)aUserInfo backtrace:(NSArray *)abt
{
    self = [super initWithName:aName reason:aReason userInfo:aUserInfo];
    if (self) {
        self.backtraces = abt;
    }
    return self;
}
@end
@interface VTSignalException()
@property (nonatomic, assign) NSInteger signalSt;
@end
@implementation VTSignalException

@end
void HandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    NSArray *callStack = getCurrentBacktrace();
    VTException *abe = [VTException exceptionWithName:exception.name reason:exception.reason userInfo:exception.userInfo backtrace:callStack];
    if (globolHandler != NULL) {
        globolHandler(abe);
    }
    [exception raise];
}

void SignalHandler(int asignal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSArray *callStack = getCurrentBacktrace();
    VTSignalException *abe = (VTSignalException *)[VTSignalException exceptionWithName:@"UncaughtExceptionHandlerSignalExceptionName"
                                               reason:[NSString stringWithFormat:@"Signal %d was raised.",asignal]
                                                   userInfo:nil
                                            backtrace:callStack];
    abe.signalSt = asignal;
    if (globolHandler != NULL) {
        globolHandler(abe);
    }
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    kill(getpid(), asignal);
}

void vtInstallUncaughtExceptionHandler(void (^aHandler)(VTException *aException))
{
    globolHandler = aHandler;
    NSSetUncaughtExceptionHandler(&HandleException);
    for (int sigSerial = 0;sigSerial < __DARWIN_NSIG; sigSerial ++) {
        signal(sigSerial, SignalHandler);
    }
}


