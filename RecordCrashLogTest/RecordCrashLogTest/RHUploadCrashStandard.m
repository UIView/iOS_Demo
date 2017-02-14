//
//  RHUploadCrashStandard.m
//  RecordCrashLogTest
//
//  Created by Yahui Duan on 17/2/7.
//  Copyright © 2017年 Yahui.Duan. All rights reserved.
//

#import "RHUploadCrashStandard.h"
#import "KSCrashInstallation+Private.h"
#import "KSCrashReportFilterBasic.h"
#import "RHUploadCrashFileter.h"

@implementation RHUploadCrashStandard
+ (instancetype) sharedInstance
{
    static RHUploadCrashStandard *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RHUploadCrashStandard alloc] init];
    });
    return sharedInstance;
}

- (id) init
{
    return [super initWithRequiredProperties:[NSArray arrayWithObjects: @"typeString", nil]];
}

- (id<KSCrashReportFilter>) sink
{
    RHUploadCrashFileter* sink = [[RHUploadCrashFileter alloc] init];
    return [sink defaultCrashReportFilterSet];
}
@end
