//
//  SOTabBarViewController.m
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOTabBarViewController.h"

#import "RDVTabBarItem.h"

#import "SOHomeViewController.h"
#import "SOSchoolViewController.h"
#import "SOOrderViewController.h"
#import "SOUserViewController.h"

@interface SOTabBarViewController ()

@end

@implementation SOTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SOHomeViewController *firstViewController = [[SOHomeViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
    SOSchoolViewController *secondViewController = [[SOSchoolViewController alloc] init];
    UIViewController *secondNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:secondViewController];
    
    SOOrderViewController *thirdViewController = [[SOOrderViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    SOUserViewController *fourthViewController = [[SOUserViewController alloc] init];
    UIViewController *fourthNavigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:fourthViewController];
    
    [self setViewControllers:@[firstNavigationController, secondNavigationController,thirdNavigationController,fourthNavigationController]];
    
    [self customizeTabBarForController:self];
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIColor *bgClolor = TABBAR_BG_COLOR;
    NSArray *tabBarItemImages = @[@"first", @"second",@"third",@"fourth"];
    NSArray *tabBarItemTitles=@[@"首页", @"驾校",@"预约",@"我"];
    NSInteger index = 0;
    
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundColor:bgClolor];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_s",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_n",
                                                        [tabBarItemImages objectAtIndex:index]]];
        item.title=tabBarItemTitles[index];
        item.selectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:TABBAR_ITEM_SELECTED_COLOR};
        item.unselectedTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11],NSForegroundColorAttributeName:TABBAR_ITEM_NORMAL_COLOR};
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        index++;
    }
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
