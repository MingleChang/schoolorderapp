//
//  SchoolListTableViewCell.m
//  schoolorderapp
//
//  Created by Todd on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOSchoolListTableViewCell.h"
#import "SOSchoolListModel.h"
#import "Tools.h"

@implementation SOSchoolListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellDetailWithObj:(id)obj{
    SOSchoolListModel *model = obj;
    [self.schoolImage setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:DefaultImage];
    self.schoolName.text = model.schoolName;
    
    
    NSString *des = [NSString stringWithFormat:@"教练车辆(%d辆),教练人数(%d人)",model.carNum,model.coach_num];
    self.schoolDes.text = des;
    self.schoolMoblie.text = [NSString stringWithFormat:@"电话:%@",model.tel];
    self.schoolAddress.text = model.schoolAddr;
    
    float ratio = model.highRate/100;
    float space = 85-85*ratio;
    self.starSpace.constant = space;
}

+(float)getCellHeightWithObj:(id)obj{
    SOSchoolListModel *model = obj;
    float cellHeight = 100;
    float addressHeight = [Tools getStringHeight:model.schoolAddr Font:[UIFont systemFontOfSize:12] andWidth:SCREEN_WIDTH-108];
    if (addressHeight>20) {
        cellHeight = cellHeight - 20 + addressHeight+5;
    }
    return cellHeight;
}

@end
