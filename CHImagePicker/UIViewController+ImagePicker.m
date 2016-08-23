//
//  UIViewController+ImagePicker.m
//  CHPickImageDemo
//
//  Created by Chausson on 16/8/17.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "UIViewController+ImagePicker.h"
#import "CHImagePicker.h"   
@implementation UIViewController (ImagePicker)
- (void)showPicker:(BOOL)animated
        completion:(void(^)(UIImage *image))callback{
    [CHImagePicker show:animated picker:self completion:callback];
}
- (void)showPickerList:(BOOL)animated{
    NSAssert([self conformsToProtocol:@protocol(CHDownSheetDelegate)], @"Must ConformsToProtocol CHDownSheetDelegate");
    [CHImagePicker show:animated picker:(UIViewController <CHDownSheetDelegate> *)self];


}
@end
