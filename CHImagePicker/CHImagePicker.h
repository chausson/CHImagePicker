//
//  CHImagePicker.h
//  CHPickImageDemo
//
//  Created by Chausson on 16/3/17.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+ImagePicker.h"
#import "CHDownSheet.h"

@interface CHImagePicker : NSObject

+ (instancetype) new __unavailable;
- (instancetype) init __unavailable;


+ (void)show:(BOOL)animated
      picker:(UIViewController *)controller
  completion:(void(^)(UIImage *image))callback;

+ (void)show:(BOOL)animated
      picker:(UIViewController <CHDownSheetDelegate>*)controller;
@end
