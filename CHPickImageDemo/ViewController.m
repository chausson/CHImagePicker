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
@interface ViewController ()<CHDownSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-30, 100, 60,60)];
    [self.view addSubview:self.imageView];
}
- (IBAction)photo:(UIButton *)sender {

    __weak typeof(self)weakSelf = self;

    [self showPicker:YES completion:^(UIImage *image) {
            weakSelf.imageView.image = image;
    }];
    

}
- (IBAction)showList:(UIButton *)sender {
      [self showPickerList:YES];
}
-(void)ch_sheetDidSelectIndex:(NSInteger)index{
    switch (index) {
        case 0:
            NSLog(@"拍照");
            break;
        case 1:
            NSLog(@"从手机选择");
            break;
            
        default:
            break;
    }
}

- (void)dealloc{
    
}

@end
