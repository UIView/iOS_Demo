//
//  RHUploadCrashFileter.h
//  RecordCrashLogTest
//
//  Created by Yahui Duan on 17/2/7.
//  Copyright © 2017年 Yahui.Duan. All rights reserved.
//  

#import <Foundation/Foundation.h>
#import "KSCrashReportFilter.h"

@interface RHUploadCrashFileter : NSObject <KSCrashReportFilter>

- (id <KSCrashReportFilter>) defaultCrashReportFilterSet;

@end
