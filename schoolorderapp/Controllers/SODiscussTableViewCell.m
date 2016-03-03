//
//  SODiscussTableViewCell.m
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SODiscussTableViewCell.h"
#import "SODiscussModel.h"
#import "Tools.h"

@implementation SODiscussTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellWithObj:(id)obj{
    SODiscussModel *model = obj;
    self.nameLab.text = model.studentName;
    self.timeLab.text = model.createTime;
    self.contentLab.text = model.evaluate;
    float space = 85 - model.totalScore*85/5;
    self.starSpace.constant = space;
}

+(float)getCellHeight:(id)obj{
    SODiscussModel *model = obj;
    float cellHeight = 53;
    float strH = [Tools getStringHeight:model.evaluate Font:[UIFont systemFontOfSize:14] andWidth:SCREEN_WIDTH-123];
    if (strH>17) {
        cellHeight = cellHeight - 17 + strH;
    }
    return cellHeight;
}
@end
