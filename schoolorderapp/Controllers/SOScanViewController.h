//
//  SOScanViewController.h
//  schoolorderapp
//
//  Created by 常峻玮 on 16/1/9.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOViewController.h"
@class SOScanViewController;
@protocol SOScanViewControllerDelegate <NSObject>

-(void)scanViewController:(SOScanViewController *)vc sannerQRCode:(NSString *)result;

@end

@interface SOScanViewController : SOViewController
@property(nonatomic,assign)id<SOScanViewControllerDelegate> delegate;
@end
