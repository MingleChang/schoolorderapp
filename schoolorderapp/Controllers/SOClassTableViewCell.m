//
//  SOClassTableViewCell.m
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOClassTableViewCell.h"
#import "SOClassModel.h"

@implementation SOClassTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithObj:(id)obj{
    SOClassModel *model = obj;
    self.nameLab.text = model.courseName;
    self.priceLab.text = [NSString stringWithFormat:@"%d元",model.mPrice];
}

@end
