//
//  SODiscussModel.h
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SODiscussModel : NSObject

@property(nonatomic,strong)NSString *school_id;
@property(nonatomic,strong)NSString *schoolName;
@property(nonatomic,strong)NSString *student_id;
@property(nonatomic,assign)double totalScore;
@property(nonatomic,strong)NSString *studentName;
@property(nonatomic,strong)NSString *evaluate;
@property(nonatomic,strong)NSString *commentary;
@property(nonatomic,strong)NSString *createTime;

@end
