//
//  SOMyBookingCell.m
//  schoolorderapp
//
//  Created by cjw on 16/1/6.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOMyBookingCell.h"
#import "SOMyBooking.h"
#import "MCDateExtension.h"
@interface SOMyBookingCell ()
@property (weak, nonatomic) IBOutlet UILabel *coachNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *kemuLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *discussOrPayButton;
- (IBAction)discussOrPayButtonClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;

@property(nonatomic,strong)SOMyBooking *myBooking;

@end

@implementation SOMyBookingCell

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
    self.lineHeightConstraint.constant=ONE_PIXEL;
    self.discussOrPayButton.layer.cornerRadius=4;
    self.discussOrPayButton.layer.borderWidth=ONE_PIXEL;
    self.discussOrPayButton.layer.borderColor=RGBColor(0, 162, 83, 1.0).CGColor;
}
-(void)configureData{
    
}
-(void)setupMyBooking:(SOMyBooking *)booking{
    self.myBooking=booking;
    self.coachNameLabel.text=[NSString stringWithFormat:@"教练:%@",booking.coach_name];
    self.messageLabel.text=booking.res_message;
    NSDate *lCreateDate=[NSDate fromString:booking.create_time withFormat:@"yyyy-MM-dd HH:mm:ss" withTimeZone:nil];
    self.dateLabel.text=[lCreateDate toStringWithFormat:@"yy-MM-dd HH:mm" withTimeZone:nil];
    NSString *lKemu=nil;
    if ([booking.subject isEqualToString:@"km1"]) {
        lKemu=@"科目一";
    }else if ([booking.subject isEqualToString:@"km2"]) {
        lKemu=@"科目二";
    }else if ([booking.subject isEqualToString:@"km3"]) {
        lKemu=@"科目三";
    }else{
        lKemu=@"科目四";
    }
    self.kemuLabel.text=[NSString stringWithFormat:@"科目:%@(%@)",lKemu,booking.vehicle_type];
    self.codeLabel.text=[NSString stringWithFormat:@"动态码:%@",booking.verify_code];
    self.priceLabel.text=[NSString stringWithFormat:@"费用:%@(%0.1f元)-%@",booking.pay_type,booking.fee,[booking.pay_status isEqualToString:@"10"]?@"交易完成":@"待付款"];
    
    NSDate *lPlanDate=[NSDate fromString:booking.plan_date withFormat:@"yyyy-MM-dd HH:mm:ss" withTimeZone:nil];
    self.classDateLabel.text=[NSString stringWithFormat:@"时间:%@ %@-%@",[lPlanDate toStringWithFormat:@"yy-MM-dd" withTimeZone:nil],booking.start_time,booking.end_time];
    if (booking.study_phrase>=3&&booking.study_phrase<=4&&[booking.pay_status isEqualToString:@"10"]) {
        [self.discussOrPayButton setTitle:@"评价" forState:UIControlStateNormal];
        self.discussOrPayButton.hidden=NO;
    }else if(booking.can_pay){
        [self.discussOrPayButton setTitle:@"付款" forState:UIControlStateNormal];
        self.discussOrPayButton.hidden=NO;
    }else{
        self.discussOrPayButton.hidden=YES;
    }
    
}

- (IBAction)discussOrPayButtonClick:(UIButton *)sender {
    if (self.myBooking.study_phrase>=3&&self.myBooking.study_phrase<=4&&[self.myBooking.pay_status isEqualToString:@"10"]) {
        if ([self.delegate respondsToSelector:@selector(myBookingCell:discussButtonClick:)]) {
            [self.delegate myBookingCell:self discussButtonClick:self.myBooking];
        }
    }else if(self.myBooking.can_pay){
        if ([self.delegate respondsToSelector:@selector(myBookingCell:payButtonClick:)]) {
            [self.delegate myBookingCell:self payButtonClick:self.myBooking];
        }
    }else{
    }
}
@end
