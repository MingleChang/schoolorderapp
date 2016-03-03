//
//  SOPayInforTableViewCell.h
//  schoolorderapp
//
//  Created by Todd on 16/1/15.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SOPayInforTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

-(void)setCellTitleLabWithDic:(NSDictionary*)item;
-(void)setCellContentLabWithObj:(NSString *)obj;
@end
