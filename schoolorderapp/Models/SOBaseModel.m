//
//  SOBaseModel.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOBaseModel.h"
#import "MCDateExtension.h"

@implementation SOBaseModel

-(instancetype)initWithProtocolId:(NSString *)protocolId andData:(id)data{
    self=[super init];
    if (self) {
        
        self.messageTime=[[NSDate date]toStringWithFormat:@"yyyy-MM-dd hh:mm:ss" withTimeZone:nil];
        self.messageNo=[SOManager manager].messageNo++;
        self.resMessageNo=2;
        self.errorFlag=NO;
        self.messageId=protocolId;
        self.data=data;
    }
    return self;
}

@end
