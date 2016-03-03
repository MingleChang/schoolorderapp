//
//  SOCoachTableViewCell.m
//  schoolorderapp
//
//  Created by Todd on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOCoachTableViewCell.h"
#import "SOCoachModel.h"

@implementation SOCoachTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellDetailWithObj:(id)obj{
    SOCoachModel *model = obj;
    [self.photoImage setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:PhotoDefaultImage];
    self.nameLab.text = [NSString stringWithFormat:@"教练:%@",model.coach_name];
    self.phoneLab.text = [NSString stringWithFormat:@"电话:%@",model.phone];
    self.numberLab.text = [NSString stringWithFormat:@"教练证:%d",model.assess_cnt];
    self.carLab.text = [NSString stringWithFormat:@"准教车型:%@",model.vehicle_type];
}

@end
