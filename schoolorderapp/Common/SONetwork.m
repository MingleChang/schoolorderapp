//
//  SONetwork.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SONetwork.h"
#import "SOCommon.h"
#import "MBProgressHUD+HUDSHOW.h"

#define TIME_OUT 30

@interface SONetwork()
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@end
@implementation SONetwork

+(SONetwork *)manager{
    static SONetwork *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SONetwork alloc]init];
    });
    return  sharedManager;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        self.manager=[AFHTTPRequestOperationManager manager];
        self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
        self.manager.requestSerializer.timeoutInterval=TIME_OUT;
        self.manager.operationQueue.maxConcurrentOperationCount=5;
        self.manager.securityPolicy.allowInvalidCertificates=YES;
        [self.manager.reachabilityManager startMonitoring];
    }
    return self;
}

+(void)postWithProtocol:(NSString *)protocol andParam:(NSDictionary *)param andProtocolID:(NSString *)protocolId success:(successBlock)successBlock failed:(failedBlock)failedBlock{
    NSURLRequest *lRequest=[self postRequestWithProtocol:protocol andParam:param andProtocolID:protocolId];
    [self httpWithRequest:lRequest success:successBlock failed:failedBlock];
}
+(void)getWithProtocol:(NSString *)protocol andParam:(NSDictionary *)param success:(successBlock)successBlock failed:(failedBlock)failedBlock{
    NSURLRequest *lRequest=[self getRequestWithProtocol:protocol andParam:param];
    [self httpWithRequest:lRequest success:successBlock failed:failedBlock];
}

+(void)httpWithRequest:(NSURLRequest *)request success:(successBlock)successBlock failed:(failedBlock)failedBlock{
    
    AFHTTPRequestOperation *lHTTPRequest=[[SONetwork manager].manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *lString=[SOCommon decodeFromData:responseObject];
        SOBaseModel *lBaseModel=[SOBaseModel mj_objectWithKeyValues:lString];
        if (lBaseModel==nil) {
            [MBProgressHUD show:@"操作异常" view:[UIApplication sharedApplication].keyWindow];
            if (failedBlock) {
                failedBlock();
            }
        }else if (lBaseModel.errorFlag==YES){
            [MBProgressHUD show:lBaseModel.errorMessage view:[UIApplication sharedApplication].keyWindow];
            if (failedBlock) {
                failedBlock();
            }
        }else{
            if (successBlock) {
                MCLOG(@"%@:%@",request.URL.absoluteString,lBaseModel.data);
                successBlock(lBaseModel.data);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD show:@"网络错误" view:[UIApplication sharedApplication].keyWindow];
        if (failedBlock) {
            failedBlock();
        }
    }];
    [lHTTPRequest start];
}

+(NSURLRequest *)postRequestWithProtocol:(NSString *)protocol andParam:(NSDictionary *)param andProtocolID:(NSString *)protocolId{
    
    SOBaseModel *lBaseModel=[[SOBaseModel alloc]initWithProtocolId:protocolId andData:param];
    NSDictionary *lDic=[lBaseModel mj_keyValuesWithIgnoredKeys:@[@"errorFlag"]];
    NSData *lData=[SOCommon encodeDataFromDictionary:lDic];
    
    NSString *lURLStr=[HTTP_URL stringByAppendingString:protocol];
    NSURL *lURL=[NSURL URLWithString:lURLStr];
    NSMutableURLRequest *lURLRequest=[NSMutableURLRequest requestWithURL:lURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT];
    [lURLRequest setHTTPBody:lData];
    
    //如果为空不传
    [self resetRequestHeader:lURLRequest];
    [lURLRequest setHTTPMethod:@"POST"];
    [lURLRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[lData length]] forHTTPHeaderField:@"Content-Length"];
    return lURLRequest;
}
+(NSURLRequest *)getRequestWithProtocol:(NSString *)protocol andParam:(NSDictionary *)param{
    NSString *lURLStr=[HTTP_URL stringByAppendingString:protocol];
    for (int i=0; i<param.count; i++) {
        NSString *key=[[param allKeys]objectAtIndex:i];
        NSString *value=[param objectForKey:key];
        if (i==0) {
            lURLStr=[lURLStr stringByAppendingFormat:@"?%@=%@",key,value];
        }else{
            lURLStr=[lURLStr stringByAppendingFormat:@"&%@=%@",key,value];
        }
    }
    NSURL *lURL=[NSURL URLWithString:lURLStr];
    NSMutableURLRequest *lURLRequest=[NSMutableURLRequest requestWithURL:lURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:TIME_OUT];
    [self resetRequestHeader:lURLRequest];
    return lURLRequest;
}
+(void)resetRequestHeader:(NSMutableURLRequest *)request{
    if ([SOManager manager].token.token.length>0) {
        [request setValue:[SOManager manager].token.token forHTTPHeaderField:@"SafeluckToken"];
    }
    if ([SOManager manager].user.student_id.length>0) {
        [request setValue:[SOManager manager].user.student_id forHTTPHeaderField:@"UserId"];
    }
    [request setValue:@"ios" forHTTPHeaderField:@"platform"];
    [request setValue:@"10" forHTTPHeaderField:@"version"];
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
}
@end
