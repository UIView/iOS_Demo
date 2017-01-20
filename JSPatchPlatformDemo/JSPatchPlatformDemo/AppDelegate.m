//
//  AppDelegate.m
//  JSPatchPlatformDemo
//
//  Created by Yahui Duan on 17/1/20.
//  Copyright © 2017年 Yahui.Duan. All rights reserved.
//

#import "AppDelegate.h"
#import <JSPatchPlatform/JSPatch.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
/*

 文件格式 main.js（ 项目中 main.js 仅做测试使用 ）
 公钥生成方式 参考文档。
 
 文档参考：
 http://jspatch.com/Docs/intro
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [JSPatch startWithAppKey:@"d5a400775967c3c7"];
    NSString *jsRsaPubKey =@"\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDIkBI1SUhRL3fPF6/A+0lNrlDU\n0R76w5zCkXcL2/0HRLQAj3VWdRJfwcEQ3RvoZSMaLDBkhlBr8WKrNCF0+ILxwdZl\nOjC9z9JJYsU212IvEFitWGdq0bBRNumNPYrDwc8LtXkVjDxzXMPpQYOTKBrHmYv5\nsLJZXsQUDYsgKhP9SQIDAQAB\n";
    [JSPatch setupRSAPublicKey:jsRsaPubKey];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
#ifdef DEBUG
    [JSPatch setupDevelopment];
#endif
    [JSPatch sync];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
