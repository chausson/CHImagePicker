//
//  ViewController.m
//  CHPickImageDemo
//
//  Created by Chausson on 16/3/17.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "ViewController.h"
#import "CHImagePicker.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (IBAction)photo:(UIButton *)sender {
    [[CHImagePicker shareInstance]showWithController:self finish:^(UIImage *image) {
        NSLog(@"image=%@",image);
    } animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
