//
//  SOMyBookingCell.h
//  schoolorderapp
//
//  Created by cjw on 16/1/6.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOMyBooking;
@class SOMyBookingCell;
@protocol SOMyBookingCellDelegate <NSObject>

-(void)myBookingCell:(SOMyBookingCell *)cell payButtonClick:(SOMyBooking *)myBooking;
-(void)myBookingCell:(SOMyBookingCell *)cell discussButtonClick:(SOMyBooking *)myBooking;
-(void)myBookingCell:(SOMyBookingCell *)cell cancelButtonClick:(SOMyBooking *)myBooking;

@end
@interface SOMyBookingCell : UITableViewCell
@property(nonatomic,assign)id<SOMyBookingCellDelegate> delegate;
-(void)setupMyBooking:(SOMyBooking *)booking;
@end
