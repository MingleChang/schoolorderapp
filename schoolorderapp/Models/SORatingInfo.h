//
//  SORatingInfo.h
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/22.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SORatingInfo : NSObject
@property(nonatomic,assign)CGFloat attiude;
@property(nonatomic,assign)CGFloat teaching_quality;
@property(nonatomic,assign)CGFloat teaching_stardards;
@property(nonatomic,copy)NSString *satisfaction;
@property(nonatomic,copy)NSString *msg;
@property(nonatomic,copy)NSString *reservation_id;
@end
