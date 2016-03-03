//
//  SOCoachModel.h
//  schoolorderapp
//
//  Created by Todd on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOCoachModel : NSObject
@property(nonatomic,strong)NSString *coach_id;
@property(nonatomic,strong)NSString *coach_name;
@property(nonatomic,strong)NSString *pic;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *attiude;
@property(nonatomic,strong)NSString *teaching_stardards;
@property(nonatomic,strong)NSString *teaching_quality;
@property(nonatomic,assign)int assess_cnt;
@property(nonatomic,strong)NSString *area_code;
@property(nonatomic,strong)NSString *coach_credentials_no;
@property(nonatomic,strong)NSString *vehicle_type;
@property(nonatomic,assign)int drive_age;
@property(nonatomic,assign)double high_rate;
@property(nonatomic,strong)NSString *school_id;
@property(nonatomic,strong)NSString *credentials_no;
@property(nonatomic,strong)NSString *school_name;
@property(nonatomic,strong)NSString *car_type;
@property(nonatomic,assign)int is_school_edit_plan;
@end
