//
//  SOPayInforTableViewCell.m
//  schoolorderapp
//
//  Created by Todd on 16/1/15.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOPayInforTableViewCell.h"

@implementation SOPayInforTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellTitleLabWithDic:(NSDictionary*)item{
    self.titleLab.text = [item objectForKey:@"title"];
}

-(void)setCellContentLabWithObj:(NSString *)obj{
    self.contentLab.text=obj;
}


@end
