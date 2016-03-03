//
//  MCDateExtension.h
//  Tools
//
//  Created by cjw on 15/10/29.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Extension)
-(NSString *)toStringWithFormat:(NSString *)format withTimeZone:(NSTimeZone *)timeZone;
+(NSDate *)fromString:(NSString *)string withFormat:(NSString *)format withTimeZone:(NSTimeZone *)timeZone;
@end
