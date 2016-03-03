//
//  SOManager.h
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOToken.h"
#import "SOConfigure.h"
#import "SOUser.h"
#import "SOArea.h"
#import "SOSortRule.h"
#import "SOSchoolListModel.h"
#import "SOCallPay.h"

typedef void (^successBlock)(id data);
typedef void (^failedBlock)();

@interface SOManager : NSObject
+(SOManager *)manager;

@property(nonatomic,strong)SOConfigure *configure;
@property(nonatomic,strong)SOToken *token;
@property(nonatomic,strong)SOUser *user;//登录的用户，如果未登录则为nil

@property(nonatomic,copy)NSArray *schoolArray;//驾校列表

@property(nonatomic,copy)NSArray *topAreaArray;//一级区域列表

@property(nonatomic,strong)SOArea *selectedTopArea;//选择的一级区域

@property(nonatomic,strong)SOArea *selectedSubArea;//选择的二级区域

@property(nonatomic,strong)SOSortRule *selectSort;

@property(nonatomic,copy)NSString *filterTeacherName;
@property(nonatomic,strong)SOSchoolListModel *filterSchool;
@property(nonatomic,copy)NSString *filterKemu;
@property(nonatomic,copy)NSString *filterType;

@property(nonatomic,assign)NSInteger messageNo;

@property(nonatomic,strong)SOCallPay *callPay;

@property(nonatomic,copy)successBlock paySuccessBlock;

-(void)launchUpdateSuccess:(successBlock)successBlock andFailed:(failedBlock)failedBlock;

-(BOOL)isLogin;
-(void)logout;
-(void)autoLogin;

-(void)selectTopAreaWith:(SOArea *)area;
-(void)selectSubAreaWith:(SOArea *)area;
-(void)updateSubAreaListSuccess:(successBlock)successBlock andFailed:(failedBlock)failedBlock;
-(void)getAreaListWithAreaId:(NSString *)areaId success:(successBlock)successBlock andFailed:(failedBlock)failedBlock;

-(void)updateSchoolComplete:(failedBlock)block;
-(void)updateSchoolSuccess:(successBlock)successBlock andFailed:(failedBlock)failedBlock;

-(void)payCallBackWith:(NSInteger)status;
@end
