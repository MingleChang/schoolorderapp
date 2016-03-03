//
//  SOGroundModel.h
//  schoolorderapp
//
//  Created by Todd on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOGroundModel : NSObject

@property(nonatomic,assign)double atitude;
@property(nonatomic,assign)double longitude;
@property(nonatomic,strong)NSString *placeAddr;
@property(nonatomic,strong)NSString *schoolName;
@property(nonatomic,strong)NSString *school_id;


@end
