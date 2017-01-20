//
//  AppDelegate.m
//  RecordCrashLogTest
//
//  Created by Yahui Duan on 16/12/6.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "AppDelegate.h"
#import "RHCrashLogHelp.h"
#import <AvoidCrash.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //注册消息处理函数的处理方法
//    InstallRHCrashUncaughtExceptionHandler();
    [AvoidCrash becomeEffective];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];


    NSDictionary *softwareDic=[[NSBundle mainBundle] infoDictionary];

    NSString *pathString =[NSString stringWithFormat:@"%@/Documents/CrashLog.log",NSHomeDirectory()];
    NSLog(@"crash log path = %@ \n %@",pathString ,softwareDic);
    
    return YES;
}

- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"%@",note.userInfo);
    //保存到本地  --  当然你可以在下次启动的时候，上传这个log
    NSString *exceptionInfo=[note.userInfo description];
    NSString *pathString =[self getDocumentFilePathString:@"CrashLog.log"];
    NSError *fileError;
    [exceptionInfo writeToFile:pathString atomically:YES encoding:NSUTF8StringEncoding error:&fileError];
}

-(NSString *)getDocumentFilePathString:(NSString *)fileName;
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
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
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
