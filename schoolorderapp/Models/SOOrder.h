//
//  SOOrder.h
//  schoolorderapp
//
//  Created by cjw on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SOOrder : NSObject
@property(nonatomic,assign)NSInteger fee_type;
@property(nonatomic,assign)NSInteger pay_type;
@property(nonatomic,assign)CGFloat fee;
@property(nonatomic,copy)NSString *res_id;
@end
