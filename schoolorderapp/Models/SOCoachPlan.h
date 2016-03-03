//
//  SOCoachPlan.h
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOCoachPlan : NSObject
@property(nonatomic,copy)NSString *school_id;
@property(nonatomic,copy)NSString *school_name;
@property(nonatomic,copy)NSString *coach_id;
@property(nonatomic,copy)NSString *coach_name;
@property(nonatomic,copy)NSString *coach_pic;
@property(nonatomic,copy)NSString *coach_phone;
@property(nonatomic,assign)CGFloat coach_hrate;//教练评分
@property(nonatomic,assign)NSInteger plan_nums;
@property(nonatomic,assign)NSInteger res_count;
@property(nonatomic,assign)BOOL can_order;
@property(nonatomic,copy)NSString *caution_message;
@property(nonatomic,copy)NSString *plan_vehicle_type;
@property(nonatomic,copy)NSString *coach_vehicle_type;
@property(nonatomic,copy)NSString *plan_date;
@property(nonatomic,copy)NSString *is_dj;//“T”定教  其他不显示
@property(nonatomic,assign)NSInteger total_order_num;//总共预约数
@property(nonatomic,copy)NSString *subject;//科目
@property(nonatomic,assign)NSInteger sort_num;//约过次数
@end
