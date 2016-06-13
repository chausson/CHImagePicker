//
//  CHImagePicker.h
//  CHPickImageDemo
//
//  Created by Chausson on 16/3/17.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PickCallback)(UIImage* image);

@interface CHImagePicker : NSObject

+ (instancetype) new __unavailable;
- (instancetype) init __unavailable;

+ (CHImagePicker *)shareInstance;

- (void)showWithController:(UIViewController *)controller
                    finish:(PickCallback)callback
                  animated:(BOOL)animated;


@end
