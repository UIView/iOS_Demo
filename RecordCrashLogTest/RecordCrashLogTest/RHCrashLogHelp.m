//
//  RHCrashLogHelp.m
//  RecordCrashLogTest
//
//  Created by Yahui Duan on 16/12/7.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "RHCrashLogHelp.h"
#import <UIKit/UIKit.h>
#include <libkern/OSAtomic.h>
#include <signal.h>
#include <execinfo.h>

#define CrashRHCrashLogHelpSignalExceptionName    @"CrashExceptionHandlerSignalExceptionName"
#define CrashRHCrashLogHelpSignalKey              @"CrashExceptionHandlerSignalKey"
#define CrashRHCrashLogHelpAddressesKey           @"CrashExceptionHandlerAddressesKey"
#define CrashRHCrashLogHelpCallStackSymbolsKey    @"CrashExceptionHandlerCallStackSymbolsKey"
#define RHCrashLogNameKey                         @"CrashLog.log"


volatile int32_t UncaughtExceptionCount = 0;
const int32_t UncaughtExceptionMaximum = 10;

const NSInteger UncaughtExceptionHandlerSkipAddressCount = 1;
const NSInteger UncaughtExceptionHandlerReportAddressCount = 8;

@interface RHCrashLogHelp (){
    BOOL dismissed;
}

@end
@implementation RHCrashLogHelp

/*
 * register crash handler
 */
void InstallRHCrashUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&RHCrashSignalHandlerHandleException);
    signal(SIGABRT, RHCrashSignalHandler);
    signal(SIGILL, RHCrashSignalHandler);
    signal(SIGSEGV, RHCrashSignalHandler);
    signal(SIGFPE, RHCrashSignalHandler);
    signal(SIGBUS, RHCrashSignalHandler);
    signal(SIGPIPE, RHCrashSignalHandler);
}

+ (NSArray *)backtrace
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

/*
 * Get Devices Info
 */
+ (NSString *)validateAndSaveHardwareDevicesInfo{
    UIDevice *currentDevice=[UIDevice currentDevice];
    NSDictionary *softwareDic=[[NSBundle mainBundle] infoDictionary];
    NSString *bundleName=softwareDic[@"CFBundleName"];
    NSString *softwareVersion=softwareDic[@"CFBundleShortVersionString"];
    NSString *codeType=[softwareDic[@"UIRequiredDeviceCapabilities"] description];

    NSString *devicesInfo=[NSString stringWithFormat:@" Model: %@ \n System: %@ ( %@ ) \n Version: %@ ( %@ ) \n Code Type: %@ \n",currentDevice.model,currentDevice.systemName,currentDevice.systemVersion,bundleName,softwareVersion,codeType];
    return devicesInfo;
}
/*
 * save exception to file
 */
- (void)validateAndSaveCriticalApplicationData:(NSException *)exception
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString *reason = [exception reason];
    // 异常名称
    NSString *name = [exception name];
    
    NSDate *curDate=[NSDate date];
    NSDateFormatter *dateForma=[[NSDateFormatter alloc] init];
    dateForma.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSString *tempDateString=[dateForma stringFromDate:curDate];
    
    NSString *devicesInfo=[RHCrashLogHelp validateAndSaveHardwareDevicesInfo];
    
    NSString *mainLastThrowString = [NSString stringWithFormat:@"\n Last Thread Throw: %@ \n",[NSThread callStackSymbols]];
    NSString *exceptionInfo = [NSString stringWithFormat:@"%@\nCrash Date: %@ \nException reason：%@\nException name：%@\nException stack：%@ \n\n%@ \n\n%@",devicesInfo,tempDateString, reason,name, stackArray,[exception userInfo],mainLastThrowString];
    
    //保存到本地  --  当然你可以在下次启动的时候，上传这个log
    NSString *pathString =[RHCrashLogHelp getDocumentFilePathString:RHCrashLogNameKey];
    NSError *fileError;
    [exceptionInfo writeToFile:pathString atomically:YES encoding:NSUTF8StringEncoding error:&fileError];
    if (fileError) {
        NSLog(@"\n[Log write To File Error] =%@", fileError);
    }
    NSLog(@"\n[Log Error] callStackSymbols=\n %@ \n [callStackReturnAddresses]=\n %@", exception.callStackSymbols,exception.callStackReturnAddresses);

    //    NSLog(@"\nwriteToFile =%@ \n\n", @(isSave));
}


- (void)handleException:(NSException *)exception
{
    if (!exception) {
        return;
    }
    [self validateAndSaveCriticalApplicationData:exception];
    
    dismissed = YES;
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((CFStringRef)mode, 0.001, false);
        }
    }
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    
    if ([[exception name] isEqual:CrashRHCrashLogHelpSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:CrashRHCrashLogHelpSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}

void RHCrashSignalHandlerHandleException(NSException *exception)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSArray *callStack = [RHCrashLogHelp backtrace];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];
    [userInfo setObject:callStack forKey:CrashRHCrashLogHelpAddressesKey];
    if (exception.callStackSymbols.count>0) {
        [userInfo setObject:exception.callStackSymbols forKey:CrashRHCrashLogHelpCallStackSymbolsKey];
    }
    
    [[[RHCrashLogHelp alloc]init]performSelectorOnMainThread:@selector(handleException:) withObject: [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo] waitUntilDone:YES];
}

void RHCrashSignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&UncaughtExceptionCount);
    if (exceptionCount > UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:CrashRHCrashLogHelpSignalKey];
    
    NSArray *callStack = [RHCrashLogHelp backtrace];
    [userInfo setObject:callStack forKey:CrashRHCrashLogHelpAddressesKey];
    
    [[[RHCrashLogHelp alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject: [NSException exceptionWithName:CrashRHCrashLogHelpSignalExceptionName reason: [NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.", nil), signal] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:CrashRHCrashLogHelpSignalKey]] waitUntilDone:YES];
}

#pragma mark - File
+(NSString *)getDocumentFilePathString:(NSString *)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(void)deleteCrashLog{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *pathString =[RHCrashLogHelp getDocumentFilePathString:RHCrashLogNameKey];
    if ([fileManager isExecutableFileAtPath:pathString]) {
        NSError *fileError;
        [fileManager removeItemAtPath:pathString error:&fileError];
    }
}

#pragma mark - Upload
+(void)uploadRHLocalCrashLog{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *pathString =[RHCrashLogHelp getDocumentFilePathString:RHCrashLogNameKey];
    if ([fileManager isExecutableFileAtPath:pathString]) {
    // 上传操作
        
        // 上传操作完成后，删除本地crash log
        
    }
}
@end
