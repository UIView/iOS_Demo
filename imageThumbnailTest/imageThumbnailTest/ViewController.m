//
//  ViewController.m
//  imageThumbnailTest
//
//  Created by Yahui Duan on 17/3/21.
//  Copyright © 2017年 Yahui.Duan. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIImagePickerController.h>
#import "UIImage+DJResize.h"


@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *eidtImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveDisplayImageView:(id)sender {
    BOOL isCanUseImagePicker =[UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if (isCanUseImagePicker) {
        UIImagePickerController *imagePickVC =[[UIImagePickerController alloc] init];
        imagePickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickVC.delegate=self;
        [self presentViewController:imagePickVC animated:YES completion:^{
            
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *testImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"\n [压缩之前]： %@ \n",testImage);
   UIImage *thubImage = [self startThumbnailImage:testImage];
    self.eidtImageView.image=thubImage;
    self.eidtImageView.contentMode=UIViewContentModeScaleAspectFill;
    NSLog(@"\n [压缩之后]： %@ ",thubImage);
    for (NSLayoutConstraint *layout in self.eidtImageView.constraints) {
        if ([layout.firstItem isEqual:self.eidtImageView]&&(layout.firstAttribute ==NSLayoutAttributeWidth)) {
            layout.constant=thubImage.size.width/2;
        }
        if ([layout.firstItem isEqual:self.eidtImageView]&&(layout.firstAttribute ==NSLayoutAttributeHeight)) {
            layout.constant=thubImage.size.height/2;
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(UIImage *)startThumbnailImage:(UIImage *)bigImage{
    UIImage *thubImage = nil;
    float screenW = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    float screenH = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    float screenScale = [[UIScreen mainScreen] scale];
    
    float maxHigh = screenH/6;  //  最大高度为屏幕的六分之一
    float maxWidth = screenW/3; // 最大宽度为屏幕的三分之一
    float minWidth = screenW/5; // 最小宽度为屏幕的五分之一

    CGSize  thubSize = CGSizeMake(maxWidth, maxHigh);

    CGFloat imgWidth = bigImage.size.width;
    CGFloat imgHeight = bigImage.size.height;
    //
    if (imgWidth>maxWidth) {
        float thubScale = maxWidth/imgWidth;
        float thubHigh = thubScale*imgHeight;
        if (thubHigh>maxHigh) {
            thubScale = maxHigh/thubHigh;
            maxWidth=maxWidth*thubScale;
            // 宽度最小值
            if (maxWidth<minWidth) {
                 thubScale = minWidth/maxWidth;
                 thubHigh = thubScale*maxHigh;
                thubSize=CGSizeMake(minWidth*screenScale, thubHigh*screenScale);
            }else{
                thubSize=CGSizeMake(maxWidth*screenScale, maxHigh*screenScale);
            }

        }else{
            thubSize=CGSizeMake(maxWidth*screenScale, thubHigh*screenScale);
        }
        thubImage =[bigImage resizedImage:thubSize interpolationQuality:kCGInterpolationDefault];
        
    }else{
        // other 不缩放
        thubImage=bigImage;
    }
    
    return thubImage;
}

@end
