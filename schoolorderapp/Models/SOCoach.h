//
//  SOCoach.h
//  schoolorderapp
//
//  Created by cjw on 16/1/15.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOCoach : NSObject
@property(nonatomic,copy)NSString *coach_id;
@property(nonatomic,copy)NSString *coach_name;
@property(nonatomic,copy)NSString *pic;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *attiude;
@property(nonatomic,copy)NSString *teaching_stardards;
@property(nonatomic,copy)NSString *teaching_quality;
@property(nonatomic,assign)NSInteger assess_cnt;
@property(nonatomic,assign)CGFloat high_rate;
@property(nonatomic,assign)NSInteger total_order_count;
@end
