//
//  SOUserSelectCell.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOUserSelectCell.h"
@interface SOUserSelectCell()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *selectTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;

@end
@implementation SOUserSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setupInfo:(NSDictionary *)info showOneLine:(BOOL)isYes{
    self.selectImageView.image=[UIImage imageNamed:info[USER_SELECT_IMAGE_KEY]];
    self.selectTitleLabel.text=info[USER_SELECT_TITLE_KEY];
    if (isYes) {
        self.topLineView.hidden=YES;
        self.bottomLineView.hidden=NO;
    }else{
        self.topLineView.hidden=NO;
        self.bottomLineView.hidden=NO;
    }
}
#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    self.lineHeightConstraint.constant=ONE_PIXEL;
}
-(void)configureData{
    
}
@end
