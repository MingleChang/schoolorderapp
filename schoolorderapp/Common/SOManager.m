//
//  SOManager.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOManager.h"
#import "SONetwork.h"
#import "MCCacheManager.h"
#import "SOCommon.h"

@interface SOManager()

@end

@implementation SOManager

+(SOManager *)manager{
    static SOManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SOManager alloc]init];
    });
    return  sharedManager;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    return self;
}

-(void)launchUpdateSuccess:(successBlock)successBlock andFailed:(failedBlock)failedBlock{
    [self updateConfigureSuccess:^(id data) {
        [self updateTokenSuccess:^(id data) {
            [self updateTopAreaListSuccess:^(id data) {
                if (successBlock) {
                    successBlock(nil);
                }
            } andFailed:^{
                MCLOG(@"Area Failed!");
                if (failedBlock) {
                    failedBlock();
                }
            }];
        } andFailed:^{
            MCLOG(@"Token Failed!");
            if (failedBlock) {
                failedBlock();
            }
        }];
    } andFailed:^{
        MCLOG(@"Configure Failed!");
        if (failedBlock) {
            failedBlock();
        }
    }];
}

-(void)updateConfigureSuccess:(successBlock)successBlock andFailed:(failedBlock)failedBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *lConfigureStr=[NSString stringWithContentsOfURL:[NSURL URLWithString:CONFIGURE_URL] encoding:NSUTF8StringEncoding error:nil];
        self.configure=[SOConfigure mj_objectWithKeyValues:lConfigureStr];
        if (self.configure.defaultService.length==0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failedBlock) {
                    failedBlock();
                }
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock(nil);
            }
        });
    });
}
-(void)updateTokenSuccess:(successBlock)successBlock andFailed:(failedBlock)failedBlock{
    [SONetwork postWithProtocol:TOKEN_PROTOCOL andParam:[self tokenParam] andProtocolID:TOKEN_PROTOCOL_ID success:^(id data) {
        self.token=[SOToken mj_objectWithKeyValues:data];
        if (self.token.token.length==0) {
            if (failedBlock) {
                failedBlock();
            }
        }else{
            if (successBlock) {
                successBlock(self.token);
            }
        }
        
    } failed:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (failedBlock) {
                failedBlock();
            }
        });
        return;
    }];
}
-(NSDictionary *)tokenParam{
    NSString *lDeviceId=[UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *lModel=[NSString stringWithFormat:@"apple@%@@%@",[UIDevice currentDevice].model,[UIDevice currentDevice].systemVersion];
    NSString *lVersion=[[NSBundle mainBundle]objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSInteger version=(NSInteger)lVersion.doubleValue*10;
    NSDictionary *lDic=@{@"deviceId": lDeviceId,
                         @"model": lModel,
                         @"version": @(version),
                         @"network": [SOCommon getNetWorkStates],
                         @"platform": @"ios",
                         @"imsi":@"12345678",
                         @"login_type":@"student",
                         };
    return lDic;
}

#pragma mark - User Info
-(BOOL)isLogin{
    if (self.user) {
        return YES;
    }
    return NO;
}
-(void)logout{
    self.user=nil;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERDEFAULT_USER_LOGIN];
}
-(void)autoLogin{
    NSDictionary *lDic=[[NSUserDefaults standardUserDefaults]dictionaryForKey:USERDEFAULT_USER_LOGIN];
    if (lDic.count!=2) {
        return;
    }
    [SONetwork postWithProtocol:LOGIN_PROTOCOL andParam:lDic andProtocolID:LOGIN_PROTOCOL_ID success:^(id data) {
        SOUser *lUser=[SOUser mj_objectWithKeyValues:data];
        [SOManager manager].user=lUser;
    } failed:^{
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERDEFAULT_USER_LOGIN];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }];
}

#pragma mark - Area
-(void)selectTopAreaWith:(SOArea *)area{
    self.selectedTopArea=area;
    [self selectSubAreaWith:area];
}
-(void)selectSubAreaWith:(SOArea *)area{
    self.selectedSubArea=area;
    [[NSUserDefaults standardUserDefaults]setObject:[self.selectedTopArea mj_JSONObject] forKey:USERDEFAULT_TOP_AREA];
    [[NSUserDefaults standardUserDefaults]setObject:[area mj_JSONObject] forKey:USERDEFAULT_SUB_AREA];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(void)setDefaultSelectedAreaWithDefaultCode:(NSString *)code{
    if (self.selectedTopArea) {
        if (!self.selectedSubArea) {
            self.selectedSubArea=self.selectedTopArea;
        }
        return;
    }
    SOArea *lDefaultArea=nil;
    for (SOArea *lArea in self.topAreaArray) {
        if ([lArea.area_code isEqualToString:code]) {
            lDefaultArea=lArea;
            break;
        }
    }
    if (lDefaultArea) {
        self.selectedTopArea=lDefaultArea;
        self.selectedSubArea=lDefaultArea;
    }else{
        self.selectedTopArea=self.topAreaArray.firstObject;
        self.selectedSubArea=self.topAreaArray.firstObject;
    }
}
-(void)updateTopAreaListSuccess:(successBlock)successBlock andFailed:(failedBlock)failedBlock{
    [self getAreaListWithAreaId:nil success:^(id data) {
        self.topAreaArray=data;
        [self requestDefaultCityCode:^(id data) {
            [self setDefaultSelectedAreaWithDefaultCode:data];
            if (self.selectedTopArea&&self.selectedSubArea) {
                if (successBlock) {
                    successBlock(nil);
                }
            }else{
                if (failedBlock) {
                    failedBlock();
                }
            }
        }];
    } andFailed:^{
        if (failedBlock) {
            failedBlock();
        }
    }];
}
-(void)updateSubAreaListSuccess:(successBlock)successBlock andFailed:(failedBlock)failedBlock{
    [self getAreaListWithAreaId:self.selectedTopArea.area_code success:^(id data) {
        if (successBlock) {
            successBlock(data);
        }
    } andFailed:^{
        if (failedBlock) {
            failedBlock();
        }
    }];
}
-(void)getAreaListWithAreaId:(NSString *)areaId success:(successBlock)successBlock andFailed:(failedBlock)failedBlock{
    NSDictionary *lParam=nil;
    if (areaId.length>0) {
        MCCache *lCache=[MCCacheManager getCacheByFile:areaId];
        if (lCache&&lCache.expire==NO&&((NSString *)(lCache.object)).length>0) {
            NSArray *lAreaList=[SOArea mj_objectArrayWithKeyValuesArray:lCache.object];
            if (successBlock) {
                successBlock(lAreaList);
            }
            return;
        }
        lParam=@{@"area_code":areaId};
    }
    
    [SONetwork getWithProtocol:AREA_PROTOCOL andParam:lParam success:^(id data) {
        NSArray *lAreaList=[SOArea mj_objectArrayWithKeyValuesArray:data];
        if (areaId.length>0) {
            [MCCacheManager cacheObject:[data mj_JSONString] toFile:areaId expireTime:60*10];
        }
        if (successBlock) {
            successBlock(lAreaList);
        }
    } failed:^{
        if (failedBlock) {
            failedBlock();
        }
    }];
}

#pragma mark - School
-(void)updateSchoolComplete:(failedBlock)block{
    [SONetwork postWithProtocol:SCHOOL_LIST_PROTOCOL andParam:@{@"pageSize":@(1000),@"pageNo":@(1),@"areaCode":self.selectedSubArea.area_code} andProtocolID:SCHOOL_LIST_PROTOCOL_ID success:^(id data) {
        self.schoolArray=[SOSchoolListModel mj_objectArrayWithKeyValuesArray:data];
        if (block) {
            block();
        }
    } failed:^{
        self.schoolArray=nil;
        if (block) {
            block();
        }
    }];
}
-(void)updateSchoolSuccess:(successBlock)successBlock andFailed:(failedBlock)failedBlock{
    [SONetwork postWithProtocol:SCHOOL_LIST_PROTOCOL andParam:@{@"pageSize":@(1000),@"pageNo":@(1),@"areaCode":self.selectedSubArea.area_code} andProtocolID:SCHOOL_LIST_PROTOCOL_ID success:^(id data) {
        self.schoolArray=[SOSchoolListModel mj_objectArrayWithKeyValuesArray:data];
        if (successBlock) {
            successBlock(nil);
        }
    } failed:^{
        self.schoolArray=nil;
        if (failedBlock) {
            failedBlock();
        }
    }];
}
-(void)payCallBackWith:(NSInteger)status{
    if (self.callPay==nil) {
        return;
    }
    NSDictionary *lDic=@{@"status":@(status),@"order_id":self.callPay.order_id,@"pay_method":self.callPay.pay_method};
    [SONetwork postWithProtocol:PAY_CALLBACK_PROTOCOL andParam:lDic andProtocolID:PAY_CALLBACK_PROTOCOL_ID success:nil failed:nil];
    [SOManager manager].callPay=nil;
    [[NSNotificationCenter defaultCenter]postNotificationName:PAY_SUCCESS_NOTICATION object:nil];
}
-(void)requestDefaultCityCode:(successBlock)block{
    [SONetwork getWithProtocol:GET_DEFAULT_CITY_PROTOCOL andParam:nil success:^(id data) {
        block(data);
    } failed:^{
        block(@"500000");
    }];
}
#pragma mark - Setter And Getter
-(SOArea *)selectedTopArea{
    if (_selectedTopArea) {
        return _selectedTopArea;
    }
    _selectedTopArea=[SOArea mj_objectWithKeyValues:[[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_TOP_AREA]];
    return _selectedTopArea;
}
-(SOArea *)selectedSubArea{
    if (_selectedSubArea) {
        return _selectedSubArea;
    }
    _selectedSubArea=[SOArea mj_objectWithKeyValues:[[NSUserDefaults standardUserDefaults]objectForKey:USERDEFAULT_SUB_AREA]];
    return _selectedSubArea;
}
-(SOSortRule *)selectSort{
    if (_selectSort) {
        return _selectSort;
    }
    if (self.token.sortRules.count>0) {
        _selectSort=self.token.sortRules[0];
        return _selectSort;
    }
    return nil;
}
@end
