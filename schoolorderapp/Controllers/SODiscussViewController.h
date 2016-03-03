//
//  SODiscussViewController.h
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOViewController.h"

@interface SODiscussViewController : SOViewController

@property(nonatomic,strong) SOSchoolListModel *schoolModel;
@property(nonatomic,strong) NSString *discussType;
@property(nonatomic,assign) BOOL isHideTopView;
@end
