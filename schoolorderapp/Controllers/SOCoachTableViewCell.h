//
//  SOCoachTableViewCell.h
//  schoolorderapp
//
//  Created by Todd on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOCoachTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *carLab;

-(void)setCellDetailWithObj:(id)obj;
@end
