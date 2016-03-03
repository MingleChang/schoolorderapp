//
//  SODateSelectCell.m
//  schoolorderapp
//
//  Created by cjw on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SODateSelectCell.h"
#import "MCDate.h"
@interface SODateSelectCell()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end
@implementation SODateSelectCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)setupDate:(MCDate *)date{
    self.date=date;
    self.dayLabel.text=[NSString stringWithFormat:@"%i",(int)date.day];
}
-(void)setupType:(SODateSelectCellType)type{
    self.type=type;
    switch (type) {
        case SODateSelectCellTypeNotThisMonth:
            self.backgroundColor=[UIColor lightGrayColor];
            self.dayLabel.textColor=[UIColor grayColor];
            break;
        case SODateSelectCellTypeInvalid:
            self.backgroundColor=[UIColor whiteColor];
            self.dayLabel.textColor=[UIColor grayColor];
            break;
        case SODateSelectCellTypeSelected:
            self.backgroundColor=[UIColor blueColor];
            self.dayLabel.textColor=[UIColor whiteColor];
            break;
        case SODateSelectCellTypeToday:
            self.backgroundColor=[UIColor grayColor];
            self.dayLabel.textColor=[UIColor whiteColor];
            break;
        default:
            self.backgroundColor=[UIColor whiteColor];
            self.dayLabel.textColor=[UIColor blackColor];
            break;
    }
}
@end
