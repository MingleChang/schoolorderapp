//
//  SOCommentViewController.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOCommentViewController.h"
#import "SONetwork.h"
#import "SOMyBooking.h"
#import "SOCoach.h"
#import "SOCommentStarView.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SORatingInfo.h"
#import <IQKeyboardManager/KeyboardManager.h>
@interface SOCommentViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *coachImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet SOCommentStarView *attiudeView;
@property (weak, nonatomic) IBOutlet SOCommentStarView *stardardsView;
@property (weak, nonatomic) IBOutlet SOCommentStarView *qualityView;
@property (weak, nonatomic) IBOutlet IQTextView *textView;

@property(nonatomic,strong)SOCoach *coach;
@property(nonatomic,strong)SORatingInfo *ratingInfo;
- (IBAction)submitButtonClick:(UIButton *)sender;

@end

@implementation SOCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Motheds
-(void)resetCoachInfo{
    [self.coachImageView setImageWithURL:[NSURL URLWithString:self.coach.pic] placeholderImage:PhotoDefaultImage];
    self.nameLabel.text=[NSString stringWithFormat:@"姓名:%@",self.coach.coach_name];
    self.telephoneLabel.text=[NSString stringWithFormat:@"电话:%@",self.coach.phone];
    self.countLabel.text=[NSString stringWithFormat:@"培训:%i次",(int)self.coach.total_order_count];
    self.scoreLabel.text=[NSString stringWithFormat:@"平均:%0.1f分",self.coach.high_rate];
}
-(void)resetRatingInfo{
    if (self.ratingInfo==nil) {
        return;
    }
    self.attiudeView.score=self.ratingInfo.attiude;
    self.qualityView.score=self.ratingInfo.teaching_quality;
    self.stardardsView.score=self.ratingInfo.teaching_stardards;
    NSInteger index=self.ratingInfo.satisfaction.integerValue-1;
    if (index<0) {
        index=0;
    }else if (index>2){
        index=2;
    }
    self.segmentedControl.selectedSegmentIndex=index;
    self.textView.text=self.ratingInfo.msg;
}
#pragma mark - Event Response
- (IBAction)submitButtonClick:(UIButton *)sender {
    NSString *lMsg=[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (lMsg==nil) {
        lMsg=@"";
    }
    NSDictionary *lDic=@{@"attiude":@(self.attiudeView.score),@"teaching_stardards":@(self.stardardsView.score),@"teaching_quality":@(self.qualityView.score),@"msg":lMsg,@"reservation_id":self.myBooking.id,@"satisfaction":@(self.segmentedControl.selectedSegmentIndex+1)};
    [self sendRatingWith:lDic];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    self.lineHeightConstraint.constant=ONE_PIXEL;
    self.textView.placeholder=@"请写下你对教练的评价";
}
-(void)configureData{
    [self requestCoachInfo];
}
#pragma mark - override
-(void)resetNavigationBarItems{
    [super resetNavigationBarItems];
    self.title=@"安安学车";
}
#pragma mark - Network
-(void)requestCoachInfo{
    [MBProgressHUD showSimpleHudtoView:self.view];
    [SONetwork getWithProtocol:GET_COACH_INFO_PROTOCOL(self.myBooking.coach_id) andParam:nil success:^(id data) {
        self.coach=[SOCoach mj_objectWithKeyValues:data];
        [self resetCoachInfo];
        [self requestRating];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
-(void)requestRating{
    [SONetwork getWithProtocol:GET_RATING_PROTOCOL(self.myBooking.id) andParam:nil success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        self.ratingInfo=[SORatingInfo mj_objectWithKeyValues:data];
        [self resetRatingInfo];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
-(void)sendRatingWith:(NSDictionary *)dic{
    [MBProgressHUD showSimpleHudtoView:self.view];
    
    [SONetwork postWithProtocol:RATING_PROTOCOL andParam:dic andProtocolID:RATING_PROTOCOL_ID success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        [MBProgressHUD show:@"评论成功" view:[UIApplication sharedApplication].keyWindow];
        [[NSNotificationCenter defaultCenter]postNotificationName:COMMENT_SUCCESS_NOTICATION object:nil];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
@end
