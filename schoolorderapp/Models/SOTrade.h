//
//  SOTrade.h
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/9.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOTrade : NSObject
@property(nonatomic,copy)NSString *order_id;//预约ID
@property(nonatomic,copy)NSString *order_date;//预约日期
@property(nonatomic,copy)NSString *order_complete_date;//预约完成日期
@property(nonatomic,strong)NSNumber *total_fee;//总消费
@property(nonatomic,copy)NSString *body;
@property(nonatomic,copy)NSString *subject;//科目
@property(nonatomic,assign)NSInteger pay_status;//00未付款 10已付款 15 待退款 20已退款
@property(nonatomic,copy)NSString *data_type;
@property(nonatomic,copy)NSString *data_id;
@property(nonatomic,copy)NSString *ip;
@property(nonatomic,copy)NSString *trade_kind;
@property(nonatomic,copy)NSString *trade_kind_name;
@property(nonatomic,copy)NSString *sign;
@property(nonatomic,copy)NSString *coach_id;//教练ID
@property(nonatomic,copy)NSString *student_id;//学员ID
@property(nonatomic,copy)NSString *coach_school_id;
@property(nonatomic,copy)NSString *ayid;//安运ID
@property(nonatomic,copy)NSString *platform;//来源
@property(nonatomic,copy)NSString *ori_order_id;
@property(nonatomic,copy)NSString *pay_status_name;
@property(nonatomic,copy)NSString *pay_name;
@property(nonatomic,copy)NSString *school_name;

//@property(nonatomic,copy)NSString *refund_flag;
//@property(nonatomic,copy)NSArray *pay_list;
@end
