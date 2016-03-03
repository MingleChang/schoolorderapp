//
//  MCCacheManager.m
//  Tools
//
//  Created by 常峻玮 on 15/11/9.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import "MCCacheManager.h"

#import "MCFilePath.h"


@interface MCCache()
@property(nonatomic,strong)NSDate *expireDate;
@end
@implementation MCCache
-(instancetype)initWithObject:(id)object andExpireDate:(NSDate *)expireDate{
    self=[super init];
    if (self) {
        self.object=object;
        self.expireDate=expireDate;
    }
    return self;
}
-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self=[super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"timestamp"]&&[value isKindOfClass:[NSNumber class]]) {
        NSNumber *lNumber=(NSNumber *)value;
        self.expireDate=[NSDate dateWithTimeIntervalSince1970:lNumber.doubleValue];
    }
}
-(id)valueForUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"timestamp"]) {
        return @([self.expireDate timeIntervalSince1970]);
    }
    return nil;
}
-(NSDictionary *)toDictionary{
    return [self dictionaryWithValuesForKeys:@[@"object",@"timestamp"]];
}
-(NSData *)toJsonData{
    NSDictionary *lDic=[self toDictionary];
    NSData *lData=[NSJSONSerialization dataWithJSONObject:lDic options:NSJSONWritingPrettyPrinted error:nil];
    return lData;
}
-(BOOL)expire{
    NSDate *lNowDate=[NSDate date];
    if ([self.expireDate compare:lNowDate]==NSOrderedAscending) {
        return YES;
    }else{
        return NO;
    }
}
@end

@implementation MCCacheManager
+(void)cacheObject:(id)object toFile:(NSString *)fileName expireTime:(NSTimeInterval)expireTime{
    NSString *lFilePath=[MCFilePath pathInCacheWithFileName:fileName];
    NSDate *lDate=[NSDate dateWithTimeIntervalSinceNow:expireTime];
    MCCache *lCache=[[MCCache alloc]initWithObject:object andExpireDate:lDate];
    NSData *lData=[lCache toJsonData];
    [lData writeToFile:lFilePath atomically:YES];
}
+(MCCache *)getCacheByFile:(NSString *)fileName{
    NSString *lFilePath=[MCFilePath pathInCacheWithFileName:fileName];
    NSData *lData=[NSData dataWithContentsOfFile:lFilePath];
    if (lData==nil) {
        return nil;
    }
    NSDictionary *lDic=[NSJSONSerialization JSONObjectWithData:lData options:NSJSONReadingAllowFragments error:nil];
    if (![lDic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    MCCache *lCache=[[MCCache alloc]initWithDictionary:lDic];
    return lCache;
}
@end
