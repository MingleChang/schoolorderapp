//
//  SOPlan.h
//  schoolorderapp
//
//  Created by cjw on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOPlan : NSObject

@property(nonatomic,copy)NSString *plan_id;//计划ID
@property(nonatomic,copy)NSString *school_name;//驾校名称
@property(nonatomic,copy)NSString *coach_id;//教练ID
@property(nonatomic,copy)NSString *school_id;//驾校ID
@property(nonatomic,copy)NSString *license_plate_number;//车牌
@property(nonatomic,copy)NSString *start_time;//开始时间
@property(nonatomic,copy)NSString *end_time;//结束时间
@property(nonatomic,assign)NSInteger minutes;//分钟数
@property(nonatomic,assign)NSInteger actual_fee;//优惠金额
@property(nonatomic,assign)NSInteger count;//计划人数
@property(nonatomic,assign)NSInteger reservation_count;//已约人数
@property(nonatomic,copy)NSString *vehicle_type;//车型
@property(nonatomic,copy)NSString *subject_name;//科目
@property(nonatomic,assign)BOOL can_order;//是否可以预约
@property(nonatomic,copy)NSString *caution_message;

@end
