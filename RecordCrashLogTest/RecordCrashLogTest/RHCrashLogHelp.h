//
//  RHCrashLogHelp.h
//  RecordCrashLogTest
//
//  Created by Yahui Duan on 16/12/7.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHCrashLogHelp : NSObject
/// crash 日志 回调
void RHCrashSignalHandlerHandleException(NSException *exception);

void RHCrashSignalHandler(int signal);

/// 注册通知
void InstallRHCrashUncaughtExceptionHandler(void);

/// 上传 crash 日志
+(void)uploadRHLocalCrashLog;

@end
