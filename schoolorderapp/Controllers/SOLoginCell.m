//
//  SOLoginCell.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOLoginCell.h"

@interface SOLoginCell ()

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)loginButtonClick:(UIButton *)sender;

@end

@implementation SOLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configure];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Event Response
- (IBAction)loginButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(loginCellLoginClick:)]) {
        [self.delegate loginCellLoginClick:self];
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
