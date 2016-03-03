//
//  SOMyBookingListViewController.h
//  schoolorderapp
//
//  Created by cjw on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOViewController.h"

typedef NS_ENUM(NSInteger, SOMyBookingListType) {
    SOMyBookingListTypeOrder=1,
    SOMyBookingListTypeCancel=2,
    SOMyBookingListTypeNotDiscuss=3,
    SOMyBookingListTypeDiscussed=4
};

@interface SOMyBookingListViewController : SOViewController
@property(nonatomic,assign)SOMyBookingListType type;
@end
