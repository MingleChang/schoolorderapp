//
//  SOCommon.h
//  schoolorderapp
//
//  Created by cjw on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOCommon : NSObject


+(NSData *)encodeDataFromDictionary:(NSDictionary *)dic;
+(NSData *)encodeDataFromString:(NSString *)string;
+(NSString *)encodeFromDictionary:(NSDictionary *)dic;
+(NSString *)encodeFromString:(NSString *)string;
+(NSString *)decodeFromString:(NSString *)string;
+(NSString *)decodeFromData:(NSData *)data;
//汉字首字母
+(NSString *)getHeaderAlphabet:(NSString*)hanzi;
+(NSString *)getNetWorkStates;
@end
