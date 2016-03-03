//
//  SOPayRecordCell.h
//  schoolorderapp
//
//  Created by cjw on 16/1/6.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOTrade;
@class SOPayRecordCell;
@protocol SOPayRecordCellDelegate <NSObject>

-(void)payRecordCell:(SOPayRecordCell *)cell buttonClickWith:(SOTrade *)trade;

@end
@interface SOPayRecordCell : UITableViewCell
@property(nonatomic,assign)id<SOPayRecordCellDelegate> delegate;
+(CGFloat)getCellHeightWith:(SOTrade *)trade;
-(void)setupTrade:(SOTrade *)trade;
@end
