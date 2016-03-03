//
//  SOProgessView.m
//  schoolorderapp
//
//  Created by cjw on 16/1/21.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOProgessView.h"
#import <Masonry/Masonry.h>
#define CIRCLE_TAG 100
#define LINE_TAG 200
#define LABEL_TAG 300

@interface SOProgessView()
@property(nonatomic,strong)UIView *clearView;
@end

@implementation SOProgessView
-(void)setupStatus:(NSInteger)index{
    if (index<1||index>4) {
        self.clearView.hidden=YES;
    }else{
        self.clearView.hidden=NO;
    }
    for (int i=1; i<=4; i++) {
        UIView *lCircleView=[self viewWithTag:i+CIRCLE_TAG];
        UIView *lLineView=[self viewWithTag:i+LINE_TAG];
        UILabel *lLabel=(UILabel *)[self viewWithTag:i+LABEL_TAG];
        if (i<=index) {
            lCircleView.backgroundColor=GREEN_COLOR;
            lLineView.backgroundColor=GREEN_COLOR;
        }else{
            lCircleView.backgroundColor=[UIColor grayColor];
            lLineView.backgroundColor=[UIColor grayColor];
        }
        if (i==index) {
            lLabel.font=[UIFont italicSystemFontOfSize:12];
            [self.clearView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(lCircleView);
                make.width.and.height.mas_equalTo(20);
            }];
        }else{
            lLabel.font=[UIFont systemFontOfSize:12];
        }
    }
}
-(UIView *)clearView{
    if (_clearView) {
        return _clearView;
    }
    _clearView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    _clearView.backgroundColor=GREEN_COLOR;
    _clearView.alpha=0.2;
    _clearView.layer.cornerRadius=10;
    _clearView.hidden=YES;
    [self addSubview:_clearView];
    return _clearView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
