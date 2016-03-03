//
//  SODateSelectView.m
//  schoolorderapp
//
//  Created by cjw on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SODateSelectView.h"
#import "SODateSelectCell.h"
#import "SODateSelectHeaderView.h"
#import "MCDate.h"

#define DATE_SELECT_CELL_ID @"SODateSelectCell"
#define DATE_SELECT_HEADER_ID @"SODateSelectHeaderView"

@interface SODateSelectView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(nonatomic,strong)MCDate *selectDate;
@property(nonatomic,strong)MCDate *nowDate;
@property(nonatomic,strong)MCDate *nextMonthDate;

-(IBAction)dismissButtonClick:(UIButton *)sender;

@end
@implementation SODateSelectView

+(void)showWith:(id<SODateSelectViewDelegate>)delegate andSelectDate:(MCDate *)date{
    SODateSelectView *lView=[[NSBundle mainBundle]loadNibNamed:@"SODateSelectView" owner:nil options:nil][0];
    lView.delegate=delegate;
    lView.selectDate=date;
    lView.frame=[MCDevice screenBounds];
    [lView show];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self configure];
}
#pragma mark - Init Methods
-(void)configure{
    [self configureView];
    [self configureData];
}
-(void)configureView{
    [self.collectionView registerNib:[UINib nibWithNibName:DATE_SELECT_CELL_ID bundle:nil] forCellWithReuseIdentifier:DATE_SELECT_CELL_ID];
    [self.collectionView registerNib:[UINib nibWithNibName:DATE_SELECT_HEADER_ID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:DATE_SELECT_HEADER_ID];
}
-(void)configureData{
    
}
-(MCDate *)getDateWithIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    NSInteger section=[indexPath section];
    MCDate *lDate=nil;
    if (section==0) {
        lDate=self.nowDate;
    }else{
        lDate=self.nextMonthDate;
    }
    MCDate *lFirstDate=[lDate dateByAddDays:-lDate.day+1];
    lFirstDate=[lFirstDate dateByAddDays:-lFirstDate.weekday+1];
    return [lFirstDate dateByAddDays:row];
}
-(SODateSelectCellType)getTypeWithDate:(MCDate *)date withIndexPath:(NSIndexPath *)indexPath{
    NSInteger section=[indexPath section];
    MCDate *lDate=nil;
    if (section==0) {
        lDate=self.nowDate;
    }else{
        lDate=self.nextMonthDate;
    }
    if (![date isSameMonth:lDate]) {
        return SODateSelectCellTypeNotThisMonth;
    }else if ([date isEarlierThan:self.nowDate]||[date isLaterThan:[self.nextMonthDate dateBySubDays:1]]){
        return SODateSelectCellTypeInvalid;
    }else if([date isSameDay:self.selectDate]){
        return SODateSelectCellTypeSelected;
    }else if([date isSameDay:self.nowDate]){
        return SODateSelectCellTypeToday;
    }else{
        return SODateSelectCellTypeNormal;
    }
}
#pragma mark - Delegate
#pragma mark - UICollectionView DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section==0) {
        return self.nowDate.weeksInMonth*7;
    }else{
        return self.nextMonthDate.weeksInMonth*7;
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MCDate *lDate=[self getDateWithIndexPath:indexPath];
    SODateSelectCell *lCell=[collectionView dequeueReusableCellWithReuseIdentifier:DATE_SELECT_CELL_ID forIndexPath:indexPath];
    [lCell setupDate:lDate];
    [lCell setupType:[self getTypeWithDate:lDate withIndexPath:indexPath]];
    return lCell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSInteger section=[indexPath section];
        SODateSelectHeaderView *lHeaderView=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:DATE_SELECT_HEADER_ID forIndexPath:indexPath];
        if (section==0) {
            [lHeaderView setupDate:self.nowDate];
        }else{
            [lHeaderView setupDate:self.nextMonthDate];
        }
        return lHeaderView;
    }else{
        return nil;
    }
}
#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SODateSelectCell *lCell=(SODateSelectCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (lCell.type==SODateSelectCellTypeNotThisMonth||lCell.type==SODateSelectCellTypeInvalid) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(dateSelectView:selectDate:)]) {
        [self.delegate dateSelectView:self selectDate:lCell.date];
    }
    [self dismiss];
}

#pragma mark - UICollectionView Delegate FlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat lScreenWidth=[MCDevice screenWidth];
    CGFloat lWidth=(lScreenWidth-20-7)/7;
    return CGSizeMake(lWidth, lWidth);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake([MCDevice screenWidth], 50);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - Getter
-(MCDate *)nowDate{
    if (_nowDate) {
        return _nowDate;
    }
    _nowDate=[MCDate date];
    return _nowDate;
}
-(MCDate *)nextMonthDate{
    if (_nextMonthDate) {
        return _nextMonthDate;
    }
    _nextMonthDate=[self.nowDate dateByAddMonths:1];
    return _nextMonthDate;
}
-(MCDate *)selectDate{
    if (_selectDate) {
        return _selectDate;
    }
    _selectDate=self.nowDate;
    return _selectDate;
}
#pragma mark - Private Motheds
-(void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
-(void)dismiss{
    [self removeFromSuperview];
}
#pragma mark - Event Response
-(IBAction)dismissButtonClick:(UIButton *)sender{
    [self dismiss];
}
@end
