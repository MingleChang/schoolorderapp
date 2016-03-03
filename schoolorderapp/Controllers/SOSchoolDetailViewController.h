//
//  SOSchoolDetailViewController.h
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOViewController.h"
#import "MCChooseView.h"
#import "SOSchoolListModel.h"

@interface SOSchoolDetailViewController : SOViewController
@property (weak, nonatomic) IBOutlet MCChooseView *chooseView;
@property(strong,nonatomic) SOSchoolListModel *schoolModel;

@end
