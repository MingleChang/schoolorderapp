//
//  SOMoreDiscussViewController.m
//  schoolorderapp
//
//  Created by Todd on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOMoreDiscussViewController.h"
#import "SODiscussViewController.h"
#import <Masonry.h>
#import "SONetwork.h"

@interface SOMoreDiscussViewController ()<UIScrollViewDelegate>{
    UIButton *oldBtn;
}
@property (weak, nonatomic) IBOutlet UIView *allDisView;
@property (weak, nonatomic) IBOutlet UIView *goodDisView;
@property (weak, nonatomic) IBOutlet UIView *normalDisView;
@property (weak, nonatomic) IBOutlet UIView *badDisView;

@property (weak, nonatomic) IBOutlet UIButton *allDisBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodDisBtn;
@property (weak, nonatomic) IBOutlet UIButton *normalDisBtn;
@property (weak, nonatomic) IBOutlet UIButton *badDisBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrool;


@end

@implementation SOMoreDiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configuration];
}

-(void)configuration{
    SODiscussViewController *alldis = [SODiscussViewController new];
    alldis.schoolModel = self.schoolModel;
    alldis.isHideTopView = YES;
    alldis.discussType = @"0";
    [self.allDisView addSubview:alldis.view];
    [self addChildViewController:alldis];
    [alldis.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.allDisView);
    }];
    
    SODiscussViewController *gooddis = [SODiscussViewController new];
    gooddis.schoolModel = self.schoolModel;
    gooddis.isHideTopView = YES;
    gooddis.discussType = @"1";
    [self.goodDisView addSubview:gooddis.view];
    [self addChildViewController:gooddis];
    [gooddis.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.goodDisView);
    }];
    
    SODiscussViewController *normaldis = [SODiscussViewController new];
    normaldis.schoolModel = self.schoolModel;
    normaldis.isHideTopView = YES;
    normaldis.discussType = @"2";
    [self.normalDisView addSubview:normaldis.view];
    [self addChildViewController:normaldis];
    [normaldis.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.normalDisView);
    }];
    
    SODiscussViewController *baddis = [SODiscussViewController new];
    baddis.schoolModel = self.schoolModel;
    baddis.isHideTopView = YES;
    baddis.discussType = @"3";
    [self.badDisView addSubview:baddis.view];
    [self addChildViewController:baddis];
    [baddis.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.badDisView);
    }];
    
    self.navigationItem.title = @"评论";
    [self.allDisBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    oldBtn = self.allDisBtn;
    [self getData];
}

-(void)getData{
    NSString *str = [NSString stringWithFormat:@"school/commentary/%@",self.schoolModel.school_id];
   [SONetwork getWithProtocol:str andParam:nil success:^(id data) {
       NSDictionary *item = data;
       [self.allDisBtn setTitle:[NSString stringWithFormat:@"全部评论(%@)",[item objectForKey:@"commentNum"]] forState:UIControlStateNormal];
       [self.goodDisBtn setTitle:[NSString stringWithFormat:@"好评(%@)",[item objectForKey:@"goodNum"]] forState:UIControlStateNormal];
       [self.normalDisBtn setTitle:[NSString stringWithFormat:@"中评(%@)",[item objectForKey:@"mediumNum"]] forState:UIControlStateNormal];
       [self.badDisBtn setTitle:[NSString stringWithFormat:@"差评(%@)",[item objectForKey:@"badNum"]] forState:UIControlStateNormal];
   } failed:^{
       
   }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int tag = scrollView.contentOffset.x/scrollView.frame.size.width + 10;
    UIButton *btn = (UIButton*)[self.view viewWithTag:tag];
    if (![oldBtn isEqual:btn]) {
        [oldBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        oldBtn = btn;
    }
}

- (IBAction)selectDiscussAction:(UIButton *)sender {
    if (![oldBtn isEqual:sender]) {
        [oldBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        oldBtn = sender;
        float with = (sender.tag-10) * self.mainScrool.frame.size.width;
        [self.mainScrool setContentOffset:CGPointMake(with, 0) animated:YES];
    }

}


@end
