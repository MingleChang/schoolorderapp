//
//  MCQRCode.h
//  QRCode_OC
//
//  Created by 常峻玮 on 16/1/6.
//  Copyright © 2016年 Mingle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCQRCode;
@protocol MCQRCodeDelegate <NSObject>
-(void)qrCodeFinishedSanningQRCode:(NSString *)result;

@end

@interface MCQRCode : UIView
@property(nonatomic,assign)id<MCQRCodeDelegate> delegate;
@property(nonatomic,strong)UIColor *maskColor;

@end
