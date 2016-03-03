//
//  SOVerificationCode.h
//  schoolorderapp
//
//  Created by cjw on 16/1/8.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOVerificationCode : NSObject
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,strong)NSNumber *ver_no;
@property(nonatomic,copy)NSString *verification;
@end
