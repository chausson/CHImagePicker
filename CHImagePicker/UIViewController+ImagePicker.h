//
//  UIViewController+ImagePicker.h
//  CHPickImageDemo
//
//  Created by Chausson on 16/8/17.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ImagePicker)
- (void)showPicker:(BOOL)animated
        completion:(void(^)(UIImage *image))callback;

- (void)showPickerList:(BOOL)animated;

@end
