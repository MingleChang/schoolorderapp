//
//  SOPayRecordCell.m
//  schoolorderapp
//
//  Created by cjw on 16/1/6.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOPayRecordCell.h"
#import "SOTrade.h"
#import "SOTradePayDetail.h"
#import "MCDateExtension.h"
#import "MCDevice.h"

@interface SOPayRecordCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeighConstraint;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;
@property (weak, nonatomic) IBOutlet UIButton *payButton;

- (IBAction)payButtonClick:(UIButton *)sender;
@property(nonatomic,strong)SOTrade *trade;
@end

@implementation SOPayRecordCell

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
    self.lineHeighConstraint.constant=ONE_PIXEL;
    self.payButton.layer.cornerRadius=4;
    self.payButton.layer.borderWidth=ONE_PIXEL;
    self.payButton.layer.borderColor=RGBColor(0, 162, 83, 1.0).CGColor;
}
-(void)configureData{
}

-(void)setupTrade:(SOTrade *)trade{
    self.trade=trade;
    
    self.bodyLabel.text=trade.body;
    self.subjectLabel.text=trade.subject;
    NSDate *lDate=[NSDate fromString:trade.order_date withFormat:@"yyyy-MM-dd HH:mm:ss" withTimeZone:nil];
    self.dateLabel.text=[lDate toStringWithFormat:@"yyyy-MM-dd" withTimeZone:nil];
    self.orderStatusLabel.text=[NSString stringWithFormat:@"订单状态：%@",trade.pay_status_name];
    self.schoolLabel.text=trade.school_name;
    self.priceLabel.text=[NSString stringWithFormat:@"合计：￥%@%@",trade.total_fee,trade.pay_status?[NSString stringWithFormat:@"(%@)",trade.trade_kind_name]:@""];
    if (trade.pay_status==0) {
        self.payButton.hidden=NO;
    }else{
        self.payButton.hidden=YES;
    }
}

+(CGFloat)getCellHeightWith:(SOTrade *)trade{
    NSString *lStr=trade.body;
    CGSize lSize=[lStr boundingRectWithSize:CGSizeMake([MCDevice screenWidth]-30, 200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    
    return lSize.height + 80+15;
}
- (IBAction)payButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(payRecordCell:buttonClickWith:)]) {
        [self.delegate payRecordCell:self buttonClickWith:self.trade];
    }
}
@end
