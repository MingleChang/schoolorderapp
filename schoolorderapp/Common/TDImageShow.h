//
//  TDImageShow.h
//  showImage
//
//  Created by Todd on 15/5/13.
//  Copyright (c) 2015年 CEIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImgScrollView.h"
@interface TDImageShow : NSObject<UIScrollViewDelegate,ImgScrollViewDelegate>

/**
 *  设置本地图片
 *
 *  @param imageviews  imageviews的array
 *  @param index      被点击imageview在array中的index
 */
-(void)showImageWithImageViewArry:(NSArray*)imageviews indexOfArry:(NSInteger)index;

/**
 *  设置一组网络图片
 *
 *  @param imageviews imageviews的array
 *  @param urls       url数组，必须和array的大小一致
 *  @param index      被点击imageview在array中的index
 */
-(void)showUrlImageWithImageViewArry:(NSArray*)imageviews urls:(NSArray*)urls indexOfArry:(NSInteger)index;
@end
