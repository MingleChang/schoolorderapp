//
//  SOCommentStarView.m
//  schoolorderapp
//
//  Created by cjw on 16/1/15.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import "SOCommentStarView.h"

@implementation SOCommentStarView
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
    [self configureAllImageTap];
}
-(void)configureData{
    
}
-(void)configureAllImageTap{
    for (int i=100; i<105; i++) {
        UIImageView *lImageView=[self viewWithTag:i];
        UITapGestureRecognizer *lTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(starTapGestureEvent:)];
        [lImageView addGestureRecognizer:lTap];
    }
}
-(void)starTapGestureEvent:(UITapGestureRecognizer *)sender{
    UIImageView *lImageView=(UIImageView *)sender.view;
    CGPoint lPoint=[sender locationInView:lImageView];
    if (lPoint.x>lImageView.frame.size.width/2) {
        self.score=lImageView.tag-100+1.0;
    }else{
        self.score=lImageView.tag-100+0.5;
    }
}
-(void)setScore:(CGFloat)score{
    _score=score;
    for (int i=100; i<105; i++) {
        UIImageView *lImageView=[self viewWithTag:i];
        NSInteger index=lImageView.tag-100;
        if (_score-index>=1) {
            lImageView.image=[UIImage imageNamed:@"comment_all.png"];
        }else if(_score-index>=0.5){
            lImageView.image=[UIImage imageNamed:@"comment_half.png"];
        }else{
            lImageView.image=[UIImage imageNamed:@"comment_empty.png"];
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
