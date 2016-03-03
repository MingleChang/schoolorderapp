//
//  SOPayOrder.h
//  schoolorderapp
//
//  Created by cjw on 16/1/21.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOPayOrder : NSObject
@property(nonatomic,copy)NSString *body;
@property(nonatomic,copy)NSString *pay_status;
@property(nonatomic,copy)NSString *school_id;
@property(nonatomic,copy)NSString *status_text;
@property(nonatomic,copy)NSString *student_id;
@property(nonatomic,copy)NSString *subject;
@property(nonatomic,strong)NSNumber *total_fee;
@end
