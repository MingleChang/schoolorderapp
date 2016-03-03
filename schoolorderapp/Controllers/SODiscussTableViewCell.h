//
//  SODiscussTableViewCell.h
//  schoolorderapp
//
//  Created by Todd on 16/1/13.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SODiscussTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starSpace;

-(void)setCellWithObj:(id)obj;
+(float)getCellHeight:(id)obj;
@end
