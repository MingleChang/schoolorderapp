//
//  SOViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOViewController.h"
#import <Masonry/Masonry.h>

@interface SOViewController ()
@property(nonatomic,strong)UILabel *emptyLabel;
@end

@implementation SOViewController
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmptyLabel];
    self.navigationController.navigationBar.translucent=NO;
    [self resetNavigationBarItems];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self resetNavigationBarStatus];
    [self resetTabBarStatus];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 
-(void)setEmptyLabelHidden:(BOOL)isHidden{
    self.emptyLabel.hidden=isHidden;
    if (isHidden) {
        [self.view sendSubviewToBack:self.emptyLabel];
    }else{
        [self.view bringSubviewToFront:self.emptyLabel];
    }
}
-(void)setupEmptyLabel{
    self.emptyLabel=[[UILabel alloc]init];
    self.emptyLabel.text=@"无数据";
    [self.view addSubview:self.emptyLabel];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    self.emptyLabel.hidden=YES;
}
-(void)resetTabBarStatus{
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}
-(void)resetNavigationBarStatus{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)resetNavigationBarItems{
    UIBarButtonItem *lBackBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemClick:)];
    self.navigationItem.leftBarButtonItem=lBackBarButtonItem;
}

#pragma mark - Events Response
-(void)backBarButtonItemClick:(UIBarButtonItem *)sender{
    if (self.navigationController.viewControllers.count<2) {
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
