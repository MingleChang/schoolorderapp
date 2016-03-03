//
//  SOOrderCell.h
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/12.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOCoachPlan;
@interface SOOrderCell : UITableViewCell
-(void)setupCoachPlan:(SOCoachPlan *)plan;
@end
