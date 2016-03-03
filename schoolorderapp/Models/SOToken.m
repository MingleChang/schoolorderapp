//
//  SOToken.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOToken.h"
#import "SOSortRule.h"

@implementation SOToken
+(NSDictionary *)mj_objectClassInArray{
    return @{ @"sortRules" : [SOSortRule class] };
}
@end
