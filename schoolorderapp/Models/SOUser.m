//
//  SOUser.m
//  schoolorderapp
//
//  Created by cjw on 16/1/8.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOUser.h"

@implementation SOUser
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"area_code" :     @"student_info.area_code",
             @"ayid" :          @"student_info.ayid",
             @"city_code" :     @"student_info.city_code",
             @"class_id" :      @"student_info.class_id",
             @"class_name" :    @"student_info.class_name",
             @"cost_type" :     @"student_info.cost_type",
             @"entry_date" :    @"student_info.entry_date",
             @"name" :          @"student_info.name",
             @"nickname" :      @"student_info.nickname",
             @"phone" :         @"student_info.phone",
             @"pic" :           @"student_info.pic",
             @"schoolName" :    @"student_info.schoolName",
             @"school_id" :     @"student_info.school_id",
             @"sex" :           @"student_info.sex",
             @"sfz_no" :        @"student_info.sfz_no",
             @"student_id" :    @"student_info.student_id",
             @"train_subject" : @"student_info.train_subject",
             @"vehicle_type" :  @"student_info.vehicle_type"
             };
}
@end
