//
//  SOAreaSelectView.m
//  schoolorderapp
//
//  Created by cjw on 16/1/11.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOAreaSelectView.h"
#import "SOSubAreaCell.h"
#import "MCDevice.h"
#import "MBProgressHUD+HUDSHOW.h"
#import "SOTopAreaViewController.h"

#define SUB_AREA_CELL_ID @"SOSubAreaCell"

@interface SOAreaSelectView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,weak)UIViewController *viewController;

@property(nonatomic,strong)IBOutlet NSLayoutConstraint *lineHeightConstraint;
@property(nonatomic,strong)IBOutlet UICollectionView *collectionView;

@property(nonatomic,strong)IBOutlet UIView *nowSelectView;
@property(nonatomic,strong)IBOutlet UILabel *nowSelectLabel;

@property(nonatomic,copy)NSArray *subAreaArray;

-(IBAction)dismissButtonClick:(UIButton *)sender;
-(IBAction)nowSelectButtonClick:(UIButton *)sender;

@end
@implementation SOAreaSelectView
+(void)showWithViewController:(UIViewController *)vc{
    UIView *lOldView=[[UIApplication sharedApplication].keyWindow viewWithTag:9999];
    if (lOldView) {
        [lOldView removeFromSuperview];
    }
    SOAreaSelectView *lView=[[NSBundle mainBundle]loadNibNamed:@"SOAreaSelectView" owner:nil options:nil][0];
    lView.tag=99999;
    lView.frame=[MCDevice screenBounds];
    lView.viewController=vc;
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
    self.lineHeightConstraint.constant=ONE_PIXEL;
    self.nowSelectView.layer.borderColor=RGBColor(0, 0, 0, 0.2).CGColor;
    self.nowSelectView.layer.borderWidth=ONE_PIXEL;
    [self.collectionView registerNib:[UINib nibWithNibName:SUB_AREA_CELL_ID bundle:nil] forCellWithReuseIdentifier:SUB_AREA_CELL_ID];
}
-(void)configureData{
    self.nowSelectLabel.text=[NSString stringWithFormat:@"当前城市:%@",[SOManager manager].selectedSubArea.area_name];
    self.subAreaArray=@[[SOManager manager].selectedTopArea];
    [self updateSubArea];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
-(IBAction)nowSelectButtonClick:(UIButton *)sender{
    [self dismiss];
    SOTopAreaViewController *lViewController=[[SOTopAreaViewController alloc]init];
    [self.viewController.navigationController pushViewController:lViewController animated:YES];
}

#pragma mark - Update
-(void)updateSubArea{
    [MBProgressHUD showSimpleHudtoView:self];
    [[SOManager manager]updateSubAreaListSuccess:^(id data) {
        [MBProgressHUD hideHUDForView:self];
        NSMutableArray *lArray=[SOArea mj_objectArrayWithKeyValuesArray:data];
        self.subAreaArray=[self.subAreaArray arrayByAddingObjectsFromArray:lArray];
        [self.collectionView reloadData];
    } andFailed:^{
        [MBProgressHUD hideHUDForView:self];
    }];
}
#pragma mark - Delegate
#pragma mark - UICollectionView DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.subAreaArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOArea *lArea=[self.subAreaArray objectAtIndex:row];
    SOSubAreaCell *lCell=[collectionView dequeueReusableCellWithReuseIdentifier:SUB_AREA_CELL_ID forIndexPath:indexPath];
    [lCell setupArea:lArea];
    return lCell;
}
#pragma mark - UICollectionView Delegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOArea *lArea=[self.subAreaArray objectAtIndex:row];
    if ([lArea.area_code isEqualToString:[SOManager manager].selectedSubArea.area_code]) {
        return;
    }
    [[SOManager manager]selectSubAreaWith:lArea];
    [MBProgressHUD showSimpleHudtoView:self];
    [[SOManager manager]updateSchoolComplete:^{
        [MBProgressHUD hideHUDForView:self];
        [[NSNotificationCenter defaultCenter]postNotificationName:SELECT_AREA_NOTIICATION object:nil];
        [self dismiss];
    }];
}
#pragma mark - UICollectionView Delegate FlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat lScreenWidth=[MCDevice screenWidth];
    CGFloat lWidth=(lScreenWidth-20-20)/3;
    return CGSizeMake(lWidth, lWidth/3);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 9;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
@end
