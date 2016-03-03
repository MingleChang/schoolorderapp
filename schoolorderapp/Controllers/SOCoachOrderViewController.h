//
//  SOCoachOrderViewController.h
//  schoolorderapp
//
//  Created by cjw on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOViewController.h"
@class MCDate;
@class SOCoachPlan;
@interface SOCoachOrderViewController : SOViewController
@property(nonatomic,strong)MCDate *selectDate;
@property(nonatomic,strong)SOCoachPlan *coachPlan;
@end
