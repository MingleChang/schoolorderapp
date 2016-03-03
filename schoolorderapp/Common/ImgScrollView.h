//
//  ImgScrollView.h
//  TestLayerImage
//
//  Created by lcc on 14-8-1.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImgScrollViewDelegate <NSObject>

- (void) tapImageViewTappedWithObject:(id) sender;

@end

@interface ImgScrollView : UIScrollView

@property (strong,nonatomic) id<ImgScrollViewDelegate> i_delegate;

/**
 *  记录最初的大小0
 *
 *  @param rect
 */
- (void) setContentWithFrame:(CGRect) rect;

/**
 *  设置本地图片
 *
 *  @param image
 */
- (void) setImage:(UIImage *) image;


/**
 *  设置网络图片
 *
 *  @param image     url地址
 *  @param imageView 图片所在的imageview
 */
- (void) setImageUrl:(NSString *) image inImageView:(UIImageView*)imageView;


/**
 *  设置缩放后的大小
 */
- (void) setAnimationRect;


/**
 *  设置imageview最初的大小
 */
- (void) setAnimationinitRect;


/**
 *  恢复到最初的大小
 */
- (void) rechangeInitRdct;


/**
 *  获取imageview最初的大小
 *
 *  @return rect
 */
- (CGRect) getInitRdct;


/**
 *  显示等待指示器
 */
-(void)showActivityIndicatorView;


/**
 *  关闭等待指示器
 */
-(void)closeActivityIndicatorView;


/**
 *  设置网络图片加载失败的后的显示图片
 */
-(void)showErrorUrlImage:(UIImage*)image;
@end
