//
//  SchoolListTableViewCell.h
//  schoolorderapp
//
//  Created by Todd on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOSchoolListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *schoolImage;
@property (weak, nonatomic) IBOutlet UILabel *schoolName;
@property (weak, nonatomic) IBOutlet UILabel *schoolDes;
@property (weak, nonatomic) IBOutlet UILabel *schoolMoblie;
@property (weak, nonatomic) IBOutlet UILabel *schoolAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starSpace;

-(void)setCellDetailWithObj:(id)obj;
+(float)getCellHeightWithObj:(id)obj;
@end
