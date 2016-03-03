//
//  SOQRCodeShowView.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/10.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOQRCodeShowView.h"
#import "MCDevice.h"

@interface SOQRCodeShowView()
@property(nonatomic,strong)UIButton *qrBgView;
@property(nonatomic,strong)UILabel *hintLabel;
@property(nonatomic,strong)UIImageView *qrImageView;

@property(nonatomic,strong)NSTimer *timer;

@property(nonatomic,assign)NSInteger count;
@end

@implementation SOQRCodeShowView
-(instancetype)initWithQRImage:(UIImage *)image{
    self=[super initWithFrame:[MCDevice screenBounds]];
    if (self) {
        self.count=59;
        [self setupSubViewsWith:image];
    }
    return self;
}
-(void)setupSubViewsWith:(UIImage *)image{
    self.backgroundColor=RGBColor(0, 0, 0, 0.2);
    CGSize lBgSize=CGSizeMake(280, 320);
    CGSize lSize=self.frame.size;
    self.qrBgView=[[UIButton alloc]initWithFrame:CGRectMake(lSize.width/2-lBgSize.width/2, lSize.height/2-lBgSize.height/2, lBgSize.width, lBgSize.height)];
    self.qrBgView.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.qrBgView];
    
    self.qrImageView=[[UIImageView alloc]initWithFrame:CGRectMake(lBgSize.width/2-QR_CODE_IMAGE_SIDE/2, lBgSize.width/2-QR_CODE_IMAGE_SIDE/2, QR_CODE_IMAGE_SIDE, QR_CODE_IMAGE_SIDE)];
    self.qrImageView.image=image;
    [self.qrBgView addSubview:self.qrImageView];
    
    self.hintLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, lBgSize.width/2+QR_CODE_IMAGE_SIDE/2+10, lBgSize.width, 40)];
    self.hintLabel.text=[NSString stringWithFormat:@"当前二维码在%i秒内有效",(int)self.count];
    self.hintLabel.textColor=[UIColor redColor];
    self.hintLabel.textAlignment=NSTextAlignmentCenter;
    [self.qrBgView addSubview:self.hintLabel];
    UITapGestureRecognizer *lTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent:)];
    [self addGestureRecognizer:lTap];
}
#pragma mark - Event Response
-(void)tapEvent:(UITapGestureRecognizer *)sender{
    [self dismiss];
}
#pragma mark - Timer
-(void)startTimer{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
}
-(void)updateTimer:(NSTimer *)timer{
    self.count=self.count-1;
    if (self.count==0) {
        [self dismiss];
    }
    self.hintLabel.text=[NSString stringWithFormat:@"当前二维码在%i秒内有效",(int)self.count];
}
#pragma mark - Show And Dismiss
-(void)show{
    [self startTimer];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)dismiss{
    [self.timer invalidate];
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
