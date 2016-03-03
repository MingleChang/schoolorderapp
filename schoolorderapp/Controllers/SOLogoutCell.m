//
//  SOLogoutCell.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOLogoutCell.h"

@interface SOLogoutCell ()

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
- (IBAction)logoutButtonClick:(UIButton *)sender;

@end

@implementation SOLogoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Event Response
- (IBAction)logoutButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(logoutCellLogoutClick:)]) {
        [self.delegate logoutCellLogoutClick:self];
    }
}

#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    
}
-(void)configureData{
    
}
@end
