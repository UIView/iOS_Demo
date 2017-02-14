//
//  ViewController.m
//  RecordCrashLogTest
//
//  Created by Yahui Duan on 16/12/6.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

#import "ViewController.h"
#import <KSCrash/KSCrash.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *crashLogText;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *pathString =[NSString stringWithFormat:@"%@/Documents/CrashLog.log",NSHomeDirectory()];
    NSString *crashText = [NSString stringWithContentsOfFile:pathString encoding:NSUTF8StringEncoding error:nil];
    self.crashLogText.text = crashText;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)crashTestAction:(id)sender {
    [self crashLogTest];
}
- (IBAction)cleanCrashLogAction:(id)sender {
    self.crashLogText.text =@"";
}
#pragma mark - crash test
-(void)crashLogTest{
    NSInteger type=arc4random()%4;
    
    NSLog(@"[arc4random type］ = %@",@(type));
    
    
    switch (type) {
        case 0:
        {
            NSString *testString= @"";
            NSString *testString11= nil;
            
            NSDictionary *testDic = @{@"1":@""};
            testString11=testDic[@"key"];
            NSArray *testArray=@[testString,testString11];
            NSLog(@"testArray %@",testArray);

        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            // c++ 指针
//            [[KSCrash sharedInstance] deleteAllReports];
        }
            break;
        case 3:
        {
            UIImageView *subCrashView =[self.view viewWithTag:100];
            subCrashView.image =[UIImage imageNamed:@"没有这个对象"];
        }
            break;
            
        default:
            break;
    }
    
}
@end
