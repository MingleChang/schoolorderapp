//
//  SOPlanCell.h
//  schoolorderapp
//
//  Created by cjw on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOPlan;
@interface SOPlanCell : UICollectionViewCell
-(void)setupPlan:(SOPlan *)plan;
-(void)setupSelected:(BOOL)isSelect;
@end
