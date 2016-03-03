//
//  SOUserSelectCell.h
//  schoolorderapp
//
//  Created by cjw on 16/1/5.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USER_SELECT_TYPE_KEY @"type"
#define USER_SELECT_IMAGE_KEY @"image"
#define USER_SELECT_TITLE_KEY @"title"

typedef NS_ENUM(NSUInteger, UserSelectType) {
    UserSelectTypeBooking=100,
    UserSelectTypeAccounts=101,
    UserSelectTypeChangepwd=102,
    UserSelectTypeScan=103,
    UserSelectTypeSystem=104,
};;

@interface SOUserSelectCell : UITableViewCell
-(void)setupInfo:(NSDictionary *)info showOneLine:(BOOL)isYes;
@end
