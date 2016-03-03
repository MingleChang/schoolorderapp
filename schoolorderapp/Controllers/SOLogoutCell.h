//
//  SOLogoutCell.h
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SOLogoutCell;
@protocol SOLogoutCellDelegate <NSObject>

-(void)logoutCellLogoutClick:(SOLogoutCell *)cell;

@end

@interface SOLogoutCell : UITableViewCell
@property(nonatomic,assign)id<SOLogoutCellDelegate> delegate;
@end
