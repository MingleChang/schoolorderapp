//
//  SOPlanCell.m
//  schoolorderapp
//
//  Created by cjw on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOPlanCell.h"
#import "SOPlan.h"

@interface SOPlanCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@property(nonatomic,strong)SOPlan *plan;

@end

@implementation SOPlanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}
#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    self.layer.borderWidth=1;
}
-(void)configureData{
    
}
#pragma mark - 
-(void)setupPlan:(SOPlan *)plan{
    self.plan=plan;
    self.timeLabel.text=[NSString stringWithFormat:@"%@-%@",plan.start_time,plan.end_time];
    NSString *price=plan.actual_fee==0?@"免费":[NSString stringWithFormat:@"%i",(int)plan.actual_fee];
    self.typeLabel.text=[NSString stringWithFormat:@"%@(%@)",plan.subject_name,price];
    self.orderLabel.text=plan.caution_message.length==0?[NSString stringWithFormat:@"已约%i人,可约%i人",(int)(plan.count-plan.reservation_count),(int)plan.reservation_count]:plan.caution_message;
    if (plan.can_order==NO) {
        self.backgroundColor=[UIColor lightGrayColor];
    }else{
        self.backgroundColor=[UIColor whiteColor];
    }
}
-(void)setupSelected:(BOOL)isSelect{
    if (isSelect) {
        self.layer.borderColor=GREEN_COLOR.CGColor;
    }else{
        self.layer.borderColor=[UIColor clearColor].CGColor;
    }
}
@end
