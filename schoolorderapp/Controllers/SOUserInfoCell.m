//
//  SOUserInfoCell.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOUserInfoCell.h"
@interface SOUserInfoCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userSchoolName;

- (IBAction)qrCodeButtonClick:(UIButton *)sender;

@end
@implementation SOUserInfoCell

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
    
}
-(void)configureData{
    
}
#pragma mark - Event Response
- (IBAction)qrCodeButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(userInfoCellTapQRCodeImage:)]) {
        [self.delegate userInfoCellTapQRCodeImage:self];
    }
}
#pragma mark
-(void)updateUserView{
    [self.userImageView setImageWithURL:[NSURL URLWithString:[SOManager manager].user.pic] placeholderImage:PhotoDefaultImage];
    self.userNameLabel.text=[SOManager manager].user.name;
    self.userNickNameLabel.text=[NSString stringWithFormat:@"昵称：%@",[SOManager manager].user.nickname?[SOManager manager].user.nickname:@"未设置"];
    self.userSchoolName.text=[NSString stringWithFormat:@"驾校：%@",[SOManager manager].user.schoolName];
}
@end
