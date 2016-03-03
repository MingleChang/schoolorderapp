//
//  SOSortView.h
//  schoolorderapp
//
//  Created by cjw on 16/1/12.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOSortView;

@protocol SOSortViewDelegate <NSObject>

-(void)sortViewSelectSort:(SOSortView *)view;

@end
@interface SOSortView : UIView
@property(nonatomic,assign)id<SOSortViewDelegate> delegate;
+(void)showWith:(id<SOSortViewDelegate>)delegate;
@end
