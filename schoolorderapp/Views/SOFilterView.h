//
//  SOFilterView.h
//  schoolorderapp
//
//  Created by cjw on 16/1/12.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOFilterView;

@protocol SOFilterViewDelegate <NSObject>

-(void)fileViewOkClick:(SOFilterView *)view;

@end

@interface SOFilterView : UIView
@property(nonatomic,assign)id<SOFilterViewDelegate> delegate;
+(void)showWith:(id<SOFilterViewDelegate>)delegate;
@end
