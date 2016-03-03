//
//  Tools.h
//  CEIC
//
//  Created by Todd on 15/6/1.
//  Copyright (c) 2015年 CEIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject
/**
 *  获取字符串的高度和宽度
 *
 *  @param string 字符串
 *  @param font   字体
 *  @param width  换行宽度（高度）
 *
 *  @return 高度/宽度
 */
+(CGFloat)getStringHeight:(NSString*)string Font:(UIFont*)font andWidth:(CGFloat)width;

+(CGFloat)getStringWidth:(NSString*)string Font:(UIFont*)font andHeight:(CGFloat)height;
/**
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (CGFloat) heightForString:(UITextView *)textView andWidth:(float)width;
/**
 *  自动适配UILable的高度/宽度
 *
 *  @param lab
 */

+(void)autoLableHeightWithLab:(UILabel*)lab;
+(CGRect)autoLableWidthWithLab:(UILabel*)lab;
/**
 *  自动适配UITextView的高度/宽度
 *
 *  @param textview
 */
+(void)autoTextViewHeightWithView:(UITextView*)textview;
+(void)autoTextViewWidthWithView:(UITextView*)textview;

@end
