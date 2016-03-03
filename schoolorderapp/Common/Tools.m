//
//  Tools.m
//  CEIC
//
//  Created by Todd on 15/6/1.
//  Copyright (c) 2015年 CEIC. All rights reserved.
//

#import "Tools.h"

#define tableTag 1900

@implementation Tools{
    UIImageView *nullImageView;
}

+(CGFloat)getStringWidth:(NSString*)string Font:(UIFont*)font andHeight:(CGFloat)height{
    CGFloat width = [string boundingRectWithSize:CGSizeMake(MAXFLOAT,height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}  context:nil].size.width;
    return width;
}

+(CGFloat)getStringHeight:(NSString*)string Font:(UIFont*)font andWidth:(CGFloat)width{
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGFloat height = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}   context:nil].size.height;
    return height;
}



+ (CGFloat) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}


+(void)autoLableHeightWithLab:(UILabel*)lab{
    CGFloat stringHeight = [Tools getStringHeight:lab.text Font:lab.font andWidth:lab.frame.size.width];
    CGRect rect = lab.frame;
    rect.size.height = stringHeight;
    [lab setFrame:rect];
}

+(CGRect)autoLableWidthWithLab:(UILabel*)lab{
    CGFloat stringWidth = [Tools getStringWidth:lab.text Font:lab.font andHeight:lab.frame.size.height];
    CGRect rect = lab.frame;
    rect.size.width = stringWidth;
    [lab setFrame:rect];
    return rect;
}

+(void)autoTextViewHeightWithView:(UITextView*)textview{
    CGFloat stringHeight = [textview sizeThatFits:CGSizeMake(textview.frame.size.width, MAXFLOAT)].height;
    CGRect rect = textview.frame;
    rect.size.height = stringHeight;
    [textview setFrame:rect];
}

+(void)autoTextViewWidthWithView:(UITextView*)textview{
    CGFloat stringWidth = [textview sizeThatFits:CGSizeMake(MAXFLOAT, textview.frame.size.height)].width;
    CGRect rect = textview.frame;
    rect.size.width = stringWidth;
    [textview setFrame:rect];
}


@end
