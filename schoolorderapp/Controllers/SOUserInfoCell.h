//
//  SOUserInfoCell.h
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOUserInfoCell;
@protocol SOUserInfoCellDelegate <NSObject>

-(void)userInfoCellTapQRCodeImage:(SOUserInfoCell *)cell;

@end

@interface SOUserInfoCell : UITableViewCell
@property(nonatomic,assign)id<SOUserInfoCellDelegate> delegate;
-(void)updateUserView;
@end
