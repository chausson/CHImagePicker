//
//  CHDownSheet.h
//
//
//  Created by Chausson on 14-7-19.
//  Copyright (c) 2014年 Chausson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHDownSheetCell.h"
@protocol CHDownSheetDelegate <NSObject>
@optional
-(void)didSelectIndex:(NSInteger)index;
@end

@interface CHDownSheet : UIView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
   
}

-(id)initWithList:(NSArray *)list height:(CGFloat)height;
- (void)showInView:(UIViewController *)Sview;
@property (nonatomic ,weak) id <CHDownSheetDelegate> delegate;
@property (nonatomic ,strong) UITableView *view;
@end


