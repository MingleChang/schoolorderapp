//
//  SOOrderCell.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/12.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOOrderCell.h"
#import "SOCoachPlan.h"
@interface SOOrderCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startRightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *coachImageView;
@property (weak, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *classTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookingLabel;
@property (weak, nonatomic) IBOutlet UILabel *planOrderLabel;
@property (weak, nonatomic) IBOutlet UIView *planOrderView;
@property (weak, nonatomic) IBOutlet UILabel *orderedLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;
@property(nonatomic,strong)SOCoachPlan *coachPlan;

@end
@implementation SOOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    self.lineHeightConstraint.constant=ONE_PIXEL;
    self.planOrderView.layer.borderWidth=ONE_PIXEL;
}
-(void)configureData{
    
}

-(void)setupCoachPlan:(SOCoachPlan *)plan{
    self.coachPlan=plan;
    [self.coachImageView setImageWithURL:[NSURL URLWithString:plan.coach_pic] placeholderImage:PhotoDefaultImage];
    self.coachNameLabel.text=[NSString stringWithFormat:@"教练:%@",plan.coach_name];
    self.schoolInfoLabel.text=[NSString stringWithFormat:@"%@(%@)",plan.school_name,plan.coach_phone];
    self.classTypeLabel.text=[NSString stringWithFormat:@"课程类型:%@",plan.subject?[NSString stringWithFormat:@"%@(%@)",plan.subject,plan.plan_vehicle_type]:@"无"];
    self.bookingLabel.text=[NSString stringWithFormat:@"累计预约:%i人",(int)plan.total_order_num];
    if (plan.plan_nums==0) {
        self.planOrderView.layer.borderColor=[UIColor redColor].CGColor;
        self.planOrderLabel.textColor=[UIColor redColor];
        self.planOrderLabel.text=@"无教学计划";
    }else{
        self.planOrderView.layer.borderColor=GREEN_COLOR.CGColor;
        self.planOrderLabel.textColor=GREEN_COLOR;
        self.planOrderLabel.text=[NSString stringWithFormat:@"计划%i人,已约%i人",(int)plan.plan_nums,(int)plan.res_count];
    }
    if([plan.is_dj isEqualToString:@"T"]){
        self.orderedLabel.text=@"(定教)";
    }else if(plan.sort_num==0){
        self.orderedLabel.text=@"";
    }else{
        self.orderedLabel.text=[NSString stringWithFormat:@"(约过%i次)",(int)plan.sort_num];
    }
    float ratio = plan.coach_hrate/100;
    float space = 85-85*ratio;
    self.startRightConstraint.constant = space;
}
@end
