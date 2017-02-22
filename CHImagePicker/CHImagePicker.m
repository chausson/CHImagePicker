//
//  CHImagePicker.m
//  CHPickImageDemo
//
//  Created by Chausson on 16/3/17.
//  Copyright © 2016年 Chausson. All rights reserved.
//

#import "CHImagePicker.h"
#import "CHDownSheet.h"
#import "LMSTakePhotoController.h"
typedef void (^PickCallback)(UIImage* image);
static CHImagePicker *picker = nil;
@interface CHImagePicker()<CHDownSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,LMSTakePhotoControllerDelegate>
@end
@implementation CHImagePicker{
    __weak UIViewController *_screenController;
    PickCallback _callback;
    BOOL _animated;
}


+ (void)show:(BOOL)animated
      picker:(UIViewController *)controller
  completion:(void(^)(UIImage *image))callback{
    
    picker = [[[self class]alloc ]init];
    picker->_callback  = callback;
    picker->_screenController = controller;
    CHDownSheet *sheet = [[CHDownSheet alloc]initWithList:[CHImagePicker avaiablePickerSheetModel] height:330];
    sheet.delegate = picker;
    [sheet showInView:controller];
}
+ (void)show:(BOOL)animated
      picker:(UIViewController <CHDownSheetDelegate>*)controller{
    NSAssert([controller conformsToProtocol:@protocol(CHDownSheetDelegate)], @"controller Must ConformsToProtocol CHDownSheetDelegate");
    CHDownSheet *sheet = [[CHDownSheet alloc]initWithList:[CHImagePicker avaiablePickerSheetModel] height:330];
    sheet.delegate = controller;
    [sheet showInView:controller];

}
+ (void)show:(BOOL)animated
      picker:(UIViewController *)controller
     handler:(NSObject <CHDownSheetDelegate>*)handler{
    NSAssert([handler conformsToProtocol:@protocol(CHDownSheetDelegate)], @"handler Must ConformsToProtocol CHDownSheetDelegate");
    CHDownSheet *sheet = [[CHDownSheet alloc]initWithList:[CHImagePicker avaiablePickerSheetModel] height:330];
    sheet.delegate = handler;
    [sheet showInView:controller];
}
+ (NSArray *)avaiablePickerSheetModel{
    CHDownSheetModel *pick = [[CHDownSheetModel alloc]init];
    pick.title = @"拍照";
    CHDownSheetModel *select = [[CHDownSheetModel alloc]init];
    select.title = @"从手机相册选择";
    CHDownSheetModel *cancel = [[CHDownSheetModel alloc]init];
    cancel.title = @"取消";
    
    return   @[pick,select,cancel];
}
- (void)ch_sheetDidSelectIndex:(NSInteger)index{
    if (index == 0) {
        //拍照[self openCamera:self];
        [self openCamera:_screenController completion:_callback];
    }else if (index == 1){
        //相册 [self openPhotoLibrary:self];
        [self openPhotoLibrary:_screenController completion:_callback];
    }else if (index == 2){
        
    }
}
#pragma mark 打开照相机
- (void)openCamera:(UIViewController *)controller
        completion:(void(^)(UIImage *image))callback{
    NSAssert(controller != nil, @"必须设置相机打开的控制器");

    LMSTakePhotoController *p = [[LMSTakePhotoController alloc] init];
    if (!p.isAuthorizedCamera || !p.isCameraAvailable) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该设备不支持拍照，请重新设置后打开。" preferredStyle:UIAlertControllerStyleAlert];
        [_screenController presentViewController:alert animated:YES completion:NULL];
        NSLog(@"设备不支持拍照");
        return;
    }
    self->_callback = callback;
    p.position = TakePhotoPositionBack;
    p.delegate = self;
    [controller presentViewController:p animated:YES completion:NULL];
}
#pragma mark 打开相册
- (void)openPhotoLibrary:(UIViewController *)controller
              completion:(void(^)(UIImage *image))callback{
    NSAssert(controller != nil, @"必须设置相册打开的控制器");
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    self -> _callback = callback;
    pickerImage.sourceType = sourceType;
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [controller presentViewController:pickerImage animated:_animated completion:^{}];
    
}
#pragma mark - Imagepicker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:_animated completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (_callback) {
            _callback(image);
        }
  
    }];
    
}

#pragma LMSTakePhotoControllerDelegate
-(void)didFinishPickingImage:(UIImage *)image{
    if (image) {
        if (_callback) {
            _callback(image);
        }
    }

}




@end
