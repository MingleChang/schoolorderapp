//
//  MCDateExtension.m
//  Tools
//
//  Created by cjw on 15/10/29.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "MCDateExtension.h"

@implementation NSDate(Extension)
-(NSString *)toStringWithFormat:(NSString *)format withTimeZone:(NSTimeZone *)timeZone{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    if (timeZone) {
        [dateFormatter setTimeZone:timeZone];
    }
    NSString *lString=[dateFormatter stringFromDate:self];
    return lString;
}
+(NSDate *)fromString:(NSString *)string withFormat:(NSString *)format withTimeZone:(NSTimeZone *)timeZone{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    if (timeZone) {
        [dateFormatter setTimeZone:timeZone];
    }
    NSDate *lDate=[dateFormatter dateFromString:string];
    return lDate;
}
@end
