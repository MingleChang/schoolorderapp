//
//  SOSchoolListModel.h
//  schoolorderapp
//
//  Created by Todd on 16/1/12.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOSchoolListModel : NSObject
@property(nonatomic,strong)NSString *Price;
@property(nonatomic,strong)NSString *carClassName;
@property(nonatomic,assign)int carNum;
@property(nonatomic,assign)int coach_num;
@property(nonatomic,assign)int courseNum;
@property(nonatomic,assign)int followNum;
@property(nonatomic,assign)float highRate;
@property(nonatomic,assign)int imgShowNum;
@property(nonatomic,strong)NSString *imgUrl;
@property(nonatomic,assign)double latitude;
@property(nonatomic,assign)double longitude;
@property(nonatomic,strong)NSString *orderNo;
@property(nonatomic,assign)int placeNum;
@property(nonatomic,strong)NSString *schoolAddr;
@property(nonatomic,strong)NSString *schoolAreaCode;
@property(nonatomic,strong)NSString *schoolAreaName;
@property(nonatomic,strong)NSString *schoolName;
@property(nonatomic,strong)NSString *school_id;
@property(nonatomic,strong)NSString *tel;

@end
