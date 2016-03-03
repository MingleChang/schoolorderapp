//
//  SORootViewController.m
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/7.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SORootViewController.h"
#import "SOTabBarViewController.h"

@interface SORootViewController ()

@end

@implementation SORootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[SOManager manager]launchUpdateSuccess:^(id data) {
        [[SOManager manager]autoLogin];
        [[SOManager manager]updateSchoolComplete:nil];
        SOTabBarViewController *lTabBarViewController=[[SOTabBarViewController alloc]init];
        [self presentViewController:lTabBarViewController animated:YES completion:nil];
        NSLog(@"Launch  Success");
    } andFailed:^{
        NSLog(@"Launch Failed");
    }];
    
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
