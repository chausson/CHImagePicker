//
//  CHDownSheetCell.h
//
//
//  Created by Chausson on 14-7-19.
//  Copyright (c) 2014年 Chausson. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//获取设备的物理高度
#define IScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define IScreenWidth [UIScreen mainScreen].bounds.size.width
#import "CHDownSheetModel.h"
@interface CHDownSheetCell : UITableViewCell{
    UIImageView *leftView;
    UILabel *InfoLabel;
    CHDownSheetModel *cellData;
    UIView *backgroundView;
}
+ (NSString *)identifier;
- (void)setData:(CHDownSheetModel *)dicdata;
@end

