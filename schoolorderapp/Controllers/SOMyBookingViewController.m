//
//  SOMyBookingViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOMyBookingViewController.h"
#import "SOMyBookingListViewController.h"
#import "SONetwork.h"
#import <Masonry/Masonry.h>

@interface SOMyBookingViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *allBookingView;
@property (weak, nonatomic) IBOutlet UIView *payBookingView;
@property (weak, nonatomic) IBOutlet UIView *discussBookingView;
@property (weak, nonatomic) IBOutlet UIView *discussedBookingView;
@property(nonatomic,strong)SOMyBookingListViewController *allBookingVC;
@property(nonatomic,strong)SOMyBookingListViewController *payBookingVC;
@property(nonatomic,strong)SOMyBookingListViewController *discussBookingVC;
@property(nonatomic,strong)SOMyBookingListViewController *discussedBookingVC;

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender;

@end

@implementation SOMyBookingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Motheds
#pragma mark - Set Sub VC
-(void)setSubViewConstroller{
    self.allBookingVC=[[SOMyBookingListViewController alloc]init];
    self.allBookingVC.type=SOMyBookingListTypeOrder;
    [self.allBookingView addSubview:self.allBookingVC.view];
    [self addChildViewController:self.allBookingVC];
    [self.allBookingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.allBookingView);
    }];
    
    self.payBookingVC=[[SOMyBookingListViewController alloc]init];
    self.payBookingVC.type=SOMyBookingListTypeCancel;
    [self.payBookingView addSubview:self.payBookingVC.view];
    [self addChildViewController:self.payBookingVC];
    [self.payBookingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.payBookingView);
    }];
    
    self.discussBookingVC=[[SOMyBookingListViewController alloc]init];
    self.discussBookingVC.type=SOMyBookingListTypeNotDiscuss;
    [self.discussBookingView addSubview:self.discussBookingVC.view];
    [self addChildViewController:self.discussBookingVC];
    [self.discussBookingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.discussBookingView);
    }];
    
    self.discussedBookingVC=[[SOMyBookingListViewController alloc]init];
    self.discussedBookingVC.type=SOMyBookingListTypeDiscussed;
    [self.discussedBookingView addSubview:self.discussedBookingVC.view];
    [self addChildViewController:self.discussedBookingVC];
    [self.discussedBookingVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.discussedBookingView);
    }];
}

#pragma mark - Event Response

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*sender.selectedSegmentIndex, 0) animated:YES];
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
    [self setSubViewConstroller];
}
-(void)configureData{
    
}
#pragma mark - override
-(void)resetTabBarStatus{
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}
-(void)resetNavigationBarStatus{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)resetNavigationBarItems{
    [super resetNavigationBarItems];
    self.title=@"我的预约";
}
@end
