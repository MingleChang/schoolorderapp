//
//  SOToken.h
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@interface SOToken : NSObject
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *deviceId;
@property(nonatomic,copy)NSArray *sortRules;
@end
