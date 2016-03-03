//
//  SODateSelectHeaderView.m
//  schoolorderapp
//
//  Created by cjw on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SODateSelectHeaderView.h"
#import "MCDate.h"
@interface SODateSelectHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *monthYearLabel;

@end
@implementation SODateSelectHeaderView

- (void)awakeFromNib {
    // Initialization code
}
-(void)setupDate:(MCDate *)date{
    NSArray *lArray=@[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"十一月",@"十二月"];
    self.monthYearLabel.text=[NSString stringWithFormat:@"%@ %i",[lArray objectAtIndex:date.month-1],(int)date.year];
}
@end
