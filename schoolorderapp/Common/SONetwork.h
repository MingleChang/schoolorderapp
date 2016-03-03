//
//  SONetwork.h
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "SOBaseModel.h"

@interface SONetwork : NSObject
+(void)postWithProtocol:(NSString *)protocol andParam:(NSDictionary *)param andProtocolID:(NSString *)protocolId success:(successBlock)successBlock failed:(failedBlock)failedBlock;

+(void)getWithProtocol:(NSString *)protocol andParam:(NSDictionary *)param success:(successBlock)successBlock failed:(failedBlock)failedBlock;
@end
