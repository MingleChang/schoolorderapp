//
//  SOSortView.m
//  schoolorderapp
//
//  Created by cjw on 16/1/12.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOSortView.h"
#import "MCDevice.h"
#import "SOSortRule.h"

#define SORT_CELL_ID @"SortCell"

@interface SOSortView()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)IBOutlet UITableView *tableView;

-(IBAction)dismissButtonClick:(UIButton *)sender;
@end
@implementation SOSortView
+(void)showWith:(id<SOSortViewDelegate>)delegate{
    SOSortView *lView=[[NSBundle mainBundle]loadNibNamed:@"SOSortView" owner:nil options:nil][0];
    lView.delegate=delegate;
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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SORT_CELL_ID];
}
-(void)configureData{
    
}
#pragma mark - Delegate
#pragma mark - UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [SOManager manager].token.sortRules.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row=[indexPath row];
    SOSortRule *lSortRule=[SOManager manager].token.sortRules[row];
    UITableViewCell *lCell=[tableView dequeueReusableCellWithIdentifier:SORT_CELL_ID forIndexPath:indexPath];
    if (lSortRule.sort_code == [SOManager manager].selectSort.sort_code) {
        [lCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    lCell.textLabel.font=[UIFont systemFontOfSize:14];
    lCell.backgroundColor=[UIColor clearColor];
    lCell.textLabel.text=lSortRule.sort_name;
    return lCell;
}
#pragma mark - UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row=[indexPath row];
    SOSortRule *lSortRule=[SOManager manager].token.sortRules[row];
    [SOManager manager].selectSort=lSortRule;
    if ([self.delegate respondsToSelector:@selector(sortViewSelectSort:)]) {
        [self.delegate sortViewSelectSort:self];
    }
    [self dismiss];
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
@end
