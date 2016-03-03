//
//  SOLoginCell.h
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SOLoginCell;
@protocol SOLoginCellDelegate <NSObject>

-(void)loginCellLoginClick:(SOLoginCell *)cell;

@end

@interface SOLoginCell : UITableViewCell
@property(nonatomic,assign)id<SOLoginCellDelegate> delegate;
@end
