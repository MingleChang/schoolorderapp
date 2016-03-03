//
//  MCCacheManager.h
//  Tools
//
//  Created by 常峻玮 on 15/11/9.
//  Copyright © 2015年 Mingle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCCache : NSObject
@property(nonatomic,strong)id object;
@property(nonatomic,assign,readonly)BOOL expire;
@end

@interface MCCacheManager : NSObject
+(void)cacheObject:(id)object toFile:(NSString *)fileName expireTime:(NSTimeInterval)expireTime;
+(MCCache *)getCacheByFile:(NSString *)fileName;
@end
