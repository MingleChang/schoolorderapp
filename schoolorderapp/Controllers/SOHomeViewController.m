//
//  SOHomeViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOHomeViewController.h"
#import "SONetwork.h"
#import <MJRefresh.h>
#import "MBProgressHUD+HUDSHOW.h"
#import "SOAreaSelectView.h"

@interface SOHomeViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mainWeb;
@property (weak, nonatomic) IBOutlet UILabel *aeraLab;
@end

@implementation SOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configuration];
}

-(void)configuration{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectAreaNotification:) name:SELECT_AREA_NOTIICATION object:nil];
    [self getData];
    self.mainWeb.scrollView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.mainWeb reload];
    }];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override
-(void)resetTabBarStatus{
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}
-(void)resetNavigationBarStatus{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)getData{
    [MBProgressHUD showSimpleHudtoView:self.view];
    NSString *code = [SOManager manager].selectedSubArea.area_code;
    [SONetwork getWithProtocol:GET_MAIN_WEB_PROTOCOL(code) andParam:nil success:^(id data) {
        NSURLRequest *quest = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:data]];
        [self.mainWeb loadRequest:quest];
    } failed:^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD show:@"加载失败,稍后重试" view:self.view];
    }];
    
}

- (IBAction)selectAreaAction:(UIButton *)sender {
     [SOAreaSelectView showWithViewController:self];
}

-(void)selectAreaNotification:(NSNotification*)notify{
    self.aeraLab.text = [SOManager manager].selectedSubArea.area_name;
    [self getData];
}

#pragma mark-UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.view];
    [self.mainWeb.scrollView.header endRefreshing];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [self.mainWeb.scrollView.header endRefreshing];
    [MBProgressHUD show:@"加载失败,稍后重试" view:self.view];
}


@end
