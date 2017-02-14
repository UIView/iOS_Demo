//
//  RHUploadCrashStandard.h
//  RecordCrashLogTest
//
//  Created by Yahui Duan on 17/2/7.
//  Copyright © 2017年 Yahui.Duan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCrashInstallation.h"

@interface RHUploadCrashStandard : KSCrashInstallation
// 标示含义
@property(nonatomic,readwrite,retain) NSString *typeString;

+ (instancetype) sharedInstance;

@end
