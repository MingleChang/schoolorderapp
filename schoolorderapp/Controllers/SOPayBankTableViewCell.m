//
//  SOPayBankTableViewCell.m
//  schoolorderapp
//
//  Created by Todd on 16/1/15.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOPayBankTableViewCell.h"
#import "SOPayMethod.h"

@interface SOPayBankTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *mothedImageView;
@property (weak, nonatomic) IBOutlet UILabel *mothedNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mothedDetailLabel;

@end
@implementation SOPayBankTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setPayMethod:(SOPayMethod *)payMethod{
    _payMethod=payMethod;
    self.mothedImageView.image=[UIImage imageNamed:payMethod.image];
    self.mothedNameLabel.text=payMethod.name;
    self.mothedDetailLabel.text=payMethod.detail;
}
@end
