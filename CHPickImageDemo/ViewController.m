//
//  ViewController.m
//  CHPickImageDemo
//
//  Created by Chausson on 16/3/17.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "ViewController.h"
#import "CHImagePicker.h"
#import "UIViewController+ImagePicker.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 100, 60,60)];
    [self.view addSubview:self.imageView];
}
- (IBAction)photo:(UIButton *)sender {
//    [[CHImagePicker shareInstance]showWithController:self finish:^(UIImage *image) {
//        NSLog(@"image=%@",image);
//    } animated:YES];
    __weak typeof(self)weakSelf = self;
//    [CHImagePicker show:YES picker:self completion:^(UIImage *image) {
//        weakSelf.imageView.image = image;
//    }];
    [self showPicker:YES completion:^(UIImage *image) {
            weakSelf.imageView.image = image;
    }];

}


- (void)dealloc{
    
}

@end
