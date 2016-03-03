//
//  SODateSelectCell.h
//  schoolorderapp
//
//  Created by cjw on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCDate;

typedef NS_ENUM(NSInteger,SODateSelectCellType){
    SODateSelectCellTypeNotThisMonth,
    SODateSelectCellTypeInvalid,
    SODateSelectCellTypeToday,
    SODateSelectCellTypeSelected,
    SODateSelectCellTypeNormal
};
@interface SODateSelectCell : UICollectionViewCell
@property(nonatomic,strong)MCDate *date;
@property(nonatomic,assign)SODateSelectCellType type;
-(void)setupDate:(MCDate *)date;
-(void)setupType:(SODateSelectCellType)type;
@end
