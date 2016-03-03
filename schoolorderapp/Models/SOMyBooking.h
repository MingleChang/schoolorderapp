//
//  SOMyBooking.h
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/9.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOMyBooking : NSObject
@property(nonatomic,copy)NSString *id;//预约ID
@property(nonatomic,copy)NSString *coach_id;//教练ID
@property(nonatomic,copy)NSString *coach_name;//教练姓名
@property(nonatomic,copy)NSString *coach_phone;//教练电话
@property(nonatomic,copy)NSString *start_time;//开始时间
@property(nonatomic,copy)NSString *end_time;//结束时间
@property(nonatomic,copy)NSString *vehicle_type;//车型
@property(nonatomic,copy)NSString *license_plate_number;//车牌号
@property(nonatomic,copy)NSString *school_name;
@property(nonatomic,copy)NSString *student_name;//学员名称
@property(nonatomic,copy)NSString *verify_code;//验证码
@property(nonatomic,copy)NSString *subject;//科目
@property(nonatomic,copy)NSString *plan_date;//计划日期
@property(nonatomic,assign)CGFloat fee;//金额
@property(nonatomic,copy)NSString *pay_type;
@property(nonatomic,assign)BOOL can_cancel;
@property(nonatomic,assign)BOOL can_pay;
@property(nonatomic,copy)NSString *res_message;//文本信息 交易成功之类的
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,assign)NSInteger study_phrase;//阶段 1 预约成功 2 正在学车 3 学车完成 4 评价完成
@property(nonatomic,copy)NSString *class_name;//班级
@property(nonatomic,copy)NSString *student_phone;
@property(nonatomic,copy)NSString *res_status;
@property(nonatomic,copy)NSString *sign_status;
@property(nonatomic,copy)NSString *tc_status;
@property(nonatomic,copy)NSString *pay_status;//00 未付款 10 已付款
@property(nonatomic,assign)NSInteger fee_type;
@property(nonatomic,copy)NSString *order_id;

@end
