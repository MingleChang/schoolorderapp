//
//  SOClassModel.h
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOClassModel : NSObject

@property(nonatomic,strong)NSString *school_id;
@property(nonatomic,strong)NSString *schoolName;
@property(nonatomic,assign)int mPrice;
@property(nonatomic,assign)int price;
@property(nonatomic,strong)NSString *carClass;
@property(nonatomic,strong)NSString *courseName;
@property(nonatomic,strong)NSString *service;
@property(nonatomic,strong)NSString *courseTime;

@end
