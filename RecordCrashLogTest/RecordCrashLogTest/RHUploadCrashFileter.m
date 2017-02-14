//
//  RHUploadCrashFileter.m
//  RecordCrashLogTest
//
//  Created by Yahui Duan on 17/2/7.
//  Copyright © 2017年 Yahui.Duan. All rights reserved.
//

#import "RHUploadCrashFileter.h"
#import "NSData+GZip.h"
#import "KSJSONCodecObjC.h"
#import "KSCrashInstallation+Private.h"
#import "KSCrashReportFilterBasic.h"
#import "KSCrashReportFilterAppleFmt.h"
#import "KSCrashReportFilterGZip.h"
#import "KSCrashReportFilterJSON.h"
#import "NSError+SimpleConstructor.h"
#import "KSSystemCapabilities.h"

@implementation RHUploadCrashFileter

- (id <KSCrashReportFilter>) defaultCrashReportFilterSet
{
    return [KSCrashReportFilterPipeline filterWithFilters:
                       [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicatedSideBySide],
                       [KSCrashReportFilterStringToData filter],
                       [KSCrashReportFilterGZipCompress filterWithCompressionLevel:-1],
                       self,
                       nil];
}


- (void) filterReports:(NSArray*) reports
          onCompletion:(KSCrashReportFilterCompletion) onCompletion
{
    NSError* error = nil;
//    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:self.url
//                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                       timeoutInterval:15];
//    KSHTTPMultipartPostBody* body = [KSHTTPMultipartPostBody body];
//    for(NSData* reportData in reports)
//    {
    NSError *zipError;
        NSData* reportData=[reports lastObject];
        NSString* report = [[NSString alloc] initWithData:[reportData gunzippedWithError:&zipError] encoding:NSUTF8StringEncoding];
        NSLog(@"Report\n%@", report);
    if (zipError) {
        
    }
//    }
    
    
    
    NSLog(@"");
//    [body appendData:jsonData
//                name:@"reports"
//         contentType:@"application/json"
//            filename:@"reports.json"];
    
    
    
    // TODO: Disabled gzip compression until support is added server side,
    // and I've fixed a bug in appendUTF8String.
    //    [body appendUTF8String:@"json"
    //                      name:@"encoding"
    //               contentType:@"string"
    //                  filename:nil];
    
//    request.HTTPMethod = @"POST";
//    request.HTTPBody = [body data];
//    [request setValue:body.contentType forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"KSCrashReporter" forHTTPHeaderField:@"User-Agent"];
//    
//    //    [request setHTTPBody:[[body data] gzippedWithError:nil]];
//    //    [request setValue:@"gzip" forHTTPHeaderField:@"Content-Encoding"];
//    
//    self.reachableOperation = [KSReachableOperationKSCrash operationWithHost:[self.url host]
//                                                                   allowWWAN:YES
//                                                                       block:^
//                               {
//                                   [[KSHTTPRequestSender sender] sendRequest:request
//                                                                   onSuccess:^(__unused NSHTTPURLResponse* response, __unused NSData* data)
//                                    {
//                                        kscrash_callCompletion(onCompletion, reports, YES, nil);
//                                    } onFailure:^(NSHTTPURLResponse* response, NSData* data)
//                                    {
//                                        NSString* text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                        kscrash_callCompletion(onCompletion, reports, NO,
//                                                               [NSError errorWithDomain:[[self class] description]
//                                                                                   code:response.statusCode
//                                                                            description:text]);
//                                    } onError:^(NSError* error2)
//                                    {
//                                        kscrash_callCompletion(onCompletion, reports, NO, error2);
//                                    }];
//                               }];
}

@end
