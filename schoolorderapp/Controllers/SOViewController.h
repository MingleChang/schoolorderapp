//
//  SOViewController.h
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVTabBarController.h"

@interface SOViewController : UIViewController
-(void)setEmptyLabelHidden:(BOOL)isHidden;
-(void)resetTabBarStatus;
-(void)resetNavigationBarStatus;
-(void)resetNavigationBarItems;
@end
