//
//  SOPayMethod.h
//  schoolorderapp
//
//  Created by cjw on 16/1/21.
//  Copyright © 2016年 MingleChang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SOPayMethodType){
    SOPayMethodTypeAccount=1,
    SOPayMethodTypeUnionpay=2,
    SOPayMethodTypeAlipay=3
};

@interface SOPayMethod : NSObject
@property(nonatomic,assign)NSInteger payType;
@property(nonatomic,copy)NSString *payMethod;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *detail;
@property(nonatomic,copy)NSString *image;

@end
