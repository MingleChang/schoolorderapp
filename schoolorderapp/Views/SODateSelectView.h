//
//  SODateSelectView.h
//  schoolorderapp
//
//  Created by cjw on 16/1/14.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SODateSelectView;
@class MCDate;
@protocol SODateSelectViewDelegate <NSObject>

-(void)dateSelectView:(SODateSelectView *)view selectDate:(MCDate *)date;

@end
@interface SODateSelectView : UIView
@property(nonatomic,assign)id<SODateSelectViewDelegate> delegate;
+(void)show;
+(void)showWith:(id<SODateSelectViewDelegate>)delegate andSelectDate:(MCDate *)date;
@end
