//
//  ViewController.m
//  JSPatchPlatformDemo
//
//  Created by Yahui Duan on 17/1/20.
//  Copyright © 2017年 Yahui.Duan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     ！
     程序第一运行时，下载 js 脚本时，系统已经调用了 viewDidLoad ，后面 js 脚本下载成功后，界面已经生成，
     新的正确的ViewDidLoad并不会再次执行，效果就是 “我的viewDidLoad为啥不能修改啊？“。
     
     JSPatch所有动态替换的函数，都必须在JS执行完了之后，第二次再执行，才会全面以新替换的js代码进行工作。
     仅当程序第二次运行时，才会执行 ViewController 中的 viewDidLoad 方法。
     ！
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
