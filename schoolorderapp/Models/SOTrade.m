//
//  SOTrade.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/9.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOTrade.h"
#import "SOTradePayDetail.h"
@implementation SOTrade
+(NSDictionary *)mj_objectClassInArray{
    return @{@"pay_list":[SOTradePayDetail class]};
}
@end
