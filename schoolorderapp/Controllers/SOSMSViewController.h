//
//  SOSMSViewController.h
//  schoolorderapp
//
//  Created by cjw on 16/1/8.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOViewController.h"

typedef NS_ENUM(NSInteger,SMSType){
    SMSTypeForget=1,
    SMSTypeRegister=2,
    SMSTypeSign=3,
    SMSTypeSignout=4
};

@interface SOSMSViewController : SOViewController
@property(nonatomic,assign)SMSType type;
@end
