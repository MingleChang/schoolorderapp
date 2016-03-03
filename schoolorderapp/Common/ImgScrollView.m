//
//  ImgScrollView.m
//  TestLayerImage
//
//  Created by lcc on 14-8-1.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "ImgScrollView.h"
#import "UIImageView+AFNetworking.h"
#define defaultsImage [UIImage imageNamed:@"user_header.png"]
#define defaultsImage_Loading [UIImage imageNamed:@"defaultsImage_Loading"]
#define defaultsImage_Error [UIImage imageNamed:@"user_header"]

@interface ImgScrollView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    
    //记录自己的位置
    CGRect scaleOriginRect;
    
    //图片的大小
    CGSize imgSize;
    
    //缩放前大小
    CGRect initRect;
    UIImage *errorImage;
    
}
@property(nonatomic,strong)UIImageView *imgView;
@end

@implementation ImgScrollView

- (void)dealloc
{
    _i_delegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.minimumZoomScale = 1.0;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imgView];
        self.userInteractionEnabled = YES;

    }
    return self;
}

- (void) setContentWithFrame:(CGRect) rect
{
    _imgView.frame = rect;
    initRect = rect;
}

- (void) setAnimationRect
{
    _imgView.frame = scaleOriginRect;
}

- (void) setAnimationinitRect
{
    _imgView.frame = initRect;
    _imgView.center = self.center;
}

- (CGRect)getInitRdct{
    return initRect;
}

- (void) rechangeInitRdct
{
    self.zoomScale = 1.0;
    _imgView.frame = initRect;
}


- (void) setImage:(UIImage *) image{
    if (image)
    {
        self.imgView.image = image;
        [self setImageSizeWithImage:image];
    }
}


- (void) setImageUrl:(NSString *) image inImageView:(UIImageView*)imageView
{
    if (image!=nil||image.length!=0)
    {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:image]];
        __weak ImgScrollView *bself = self;
        
        UIImage *cachedImage = [[UIImageView sharedImageCache] cachedImageForRequest:request];
        if (cachedImage) {
            self.imgView.image = cachedImage;
            [self setImageSizeWithImage:_imgView.image];
            [UIView animateWithDuration:0.4 animations:^{
                [bself setAnimationRect];
            }];
        }else{
            UIActivityIndicatorView *indi = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            indi.color = [UIColor grayColor];
            indi.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height/2.0);
            indi.tag = 200;
            [self addSubview:indi];
            [indi startAnimating];
            [self showErrorUrlImage:defaultsImage_Error];
            __weak UIImage* errorimg = errorImage;
            [_imgView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                if (!image) {
                    image = defaultsImage;
                }
                bself.imgView.image = image;
                [indi removeFromSuperview];
                [bself setImageSizeWithImage:image];
                [bself setAnimationRect];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                if (errorimg!=nil) {
                    bself.imgView.image = errorimg;
                }
                [indi removeFromSuperview];
            }];
        }
    }
}

-(void)showErrorUrlImage:(UIImage*)image{
    errorImage = image;
}

-(void)showActivityIndicatorView{
    UIView *view = [self viewWithTag:200];
    view.hidden = NO;
}

-(void)closeActivityIndicatorView{
    UIView *view = [self viewWithTag:200];
    view.hidden = YES;
}

-(void)setImageSizeWithImage:(UIImage*)image{
    imgSize = image.size;
    
    //判断首先缩放的值
    float scaleX = self.frame.size.width/imgSize.width;
    float scaleY = self.frame.size.height/imgSize.height;
    
    //倍数小的，先到边缘
    
    if (scaleX > scaleY)
    {
        //Y方向先到边缘
        float imgViewWidth = imgSize.width*scaleY;
        self.maximumZoomScale = self.frame.size.width/imgViewWidth;
        
        scaleOriginRect = (CGRect){self.frame.size.width/2-imgViewWidth/2,0,imgViewWidth,self.frame.size.height};
    }
    else
    {
        //X先到边缘
        float imgViewHeight = imgSize.height*scaleX;
        self.maximumZoomScale = self.frame.size.height/imgViewHeight;
        
        scaleOriginRect = (CGRect){0,self.frame.size.height/2-imgViewHeight/2,self.frame.size.width,imgViewHeight};
    }
}

#pragma mark -
#pragma mark - scroll delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imgView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    CGSize boundsSize = scrollView.bounds.size;
    CGRect imgFrame = _imgView.frame;
    CGSize contentSize = scrollView.contentSize;
    
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // center horizontally
    if (imgFrame.size.width <= boundsSize.width)
    {
        centerPoint.x = boundsSize.width/2;
    }
    
    // center vertically
    if (imgFrame.size.height <= boundsSize.height)
    {
        centerPoint.y = boundsSize.height/2;
    }
    
    _imgView.center = centerPoint;
}

#pragma mark -
#pragma mark - touch
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.i_delegate respondsToSelector:@selector(tapImageViewTappedWithObject:)])
    {
        UIView *view = [self viewWithTag:200];
        [view removeFromSuperview];
        [self.i_delegate tapImageViewTappedWithObject:self];
    }
}


@end
