//
//  TDImageShow.m
//  showImage
//
//  Created by Todd on 15/5/13.
//  Copyright (c) 2015年 CEIC. All rights reserved.
//

#import "TDImageShow.h"

@implementation TDImageShow{
    UIView *scrollPanel;
    UIView *markView;
    UIScrollView *myScrollView;
    NSInteger currentIndex;
}

-(void)showImageWithImageViewArry:(NSArray*)imageviews indexOfArry:(NSInteger)index{
    [self showUrlImageWithImageViewArry:imageviews urls:nil indexOfArry:index];
}


-(void)showUrlImageWithImageViewArry:(NSArray*)imageviews urls:(NSArray*)urls indexOfArry:(NSInteger)index{
    [self setShowScrollViewWithImageViews:imageviews];
    UIImageView *tmpView = [imageviews objectAtIndex:index];
    currentIndex = index;
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:[UIApplication sharedApplication].keyWindow];
    convertRect.origin.y = 64;
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex * myScrollView.bounds.size.width;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgViewWithImageViews:imageviews urls:urls];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    
    if (urls!=nil||urls.count!=0) {
        [UIView animateWithDuration:0.4 animations:^{
            markView.alpha = 1.0;
        }];
        [tmpImgScrollView setImageUrl:[urls objectAtIndex:index] inImageView:tmpView];
    }else{
        [tmpImgScrollView setImage:tmpView.image];
        [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
    }
    
    
    
}

-(void)setShowScrollViewWithImageViews:(NSArray*)imageviews{
    scrollPanel = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 1.0;
    [[UIApplication sharedApplication].keyWindow addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [scrollPanel addSubview:myScrollView];
    
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = [UIScreen mainScreen].bounds.size.height;
    contentSize.width = myScrollView.bounds.size.width * imageviews.count;
    myScrollView.contentSize = contentSize;
}

#pragma mark - custom method
- (void) addSubImgViewWithImageViews:(NSArray*)imageviews
{
    
    [self addSubImgViewWithImageViews:imageviews urls:nil];
}

- (void) addSubImgViewWithImageViews:(NSArray*)imageviews urls:(NSArray*)urls{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    for (int i = 0; i < imageviews.count; i ++)
    {
        
        if (i == currentIndex)
        {
            continue;
        }
        UIImageView *tmpView = [imageviews objectAtIndex:i];
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:[UIApplication sharedApplication].keyWindow];
        convertRect.origin.y = 64;
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        if (urls!=nil||urls.count!=0) {
            [tmpImgScrollView setImageUrl:[urls objectAtIndex:i] inImageView:tmpView];
        }else{
            [tmpImgScrollView setImage:tmpView.image];
            [tmpImgScrollView setAnimationRect];
        }
        
    }
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark -
#pragma mark - custom delegate
- (void) tapImageViewTappedWithObject:(id)sender
{
    
    ImgScrollView *tmpImgView = sender;
    CGRect cellRect = [tmpImgView getInitRdct];
    if (cellRect.origin.x<0&cellRect.origin.y<0||
        cellRect.origin.x>[UIScreen mainScreen].bounds.size.width&cellRect.origin.y>[UIScreen mainScreen].bounds.size.height) {
        [UIView animateWithDuration:0.5 animations:^{
            markView.alpha = 0;
            scrollPanel.alpha = 0;
        }completion:^(BOOL finished) {
            [scrollPanel removeFromSuperview];
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            markView.alpha = 0;
            [tmpImgView rechangeInitRdct];
        } completion:^(BOOL finished) {
            [scrollPanel removeFromSuperview];
        }];
    }
    
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}
@end
