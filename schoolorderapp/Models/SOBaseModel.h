//
//  SOBaseModel.h
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@interface SOBaseModel : NSObject

@property(nonatomic,copy)NSString *messageId;
@property(nonatomic,copy)NSString *messageTime;
@property(nonatomic,assign)NSInteger messageNo;
@property(nonatomic,assign)NSInteger resMessageNo;
@property(nonatomic,copy)NSString *errorMessage;
@property(nonatomic,assign)BOOL errorFlag;
@property(nonatomic,strong)id data;

-(instancetype)initWithProtocolId:(NSString *)protocolId andData:(id)data;

@end
