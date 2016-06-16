//
//  WJLoadingView.m
//  WJLoading
//
//  Created by wangjin on 16/6/15.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import "WJLoadingView.h"
#define SCREEN [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface WJLoadingView ()
@property(nonatomic,strong) CAShapeLayer *progressLayer;
@property(nonatomic,strong) CALayer *imageLayer;
@property(nonatomic,strong) UIColor *loadingColor;
@property(nonatomic,assign) CGFloat lineWidth;
@property(nonatomic,strong) UIImage *centerImage;


@end
@implementation WJLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize{
    
    CGFloat width = SCREEN_WIDTH*0.2;
    CGFloat height = SCREEN_WIDTH*0.2;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.frame = CGRectMake(SCREEN_WIDTH/2.0-(width/2.0), SCREEN_HEIGHT/2.0-(height/2.0), width, height);
    self.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self setColor:nil andWidth:0 andImage:nil];
}

- (void)setColor:(UIColor *)color andWidth:(CGFloat)width andImage:(UIImage *)image{

    self.loadingColor = color;
    self.lineWidth = width;
    self.centerImage = image;
    if (color==nil) {
        
        self.loadingColor = [UIColor blueColor];
    }
    if (width==0) {
        
        self.lineWidth = 2.5f;
    }
    
    if (image ==nil) {
        self.centerImage = [UIImage imageNamed:@"loading"];
    }
    
}



+ (void)setColor:(UIColor *)color andWidth:(CGFloat)width andImage:(UIImage *)image{

    WJLoadingView *loading = [self getLoadingView];
    loading.loadingColor = color;
    loading.lineWidth = width;
    loading.centerImage = image;
}

+ (void)setColor:(UIColor *)color andWidth:(CGFloat)width andImage:(UIImage *)image withView:(UIView *)view{

    WJLoadingView *loading = [self getLoadingViewFromView:view];
    loading.loadingColor = color;
    loading.lineWidth = width;
    loading.centerImage = image;
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    self.imageLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)*0.8, CGRectGetHeight(self.bounds)*0.8);
    
    self.imageLayer.position = self.progressLayer.position;
    
    [self updatePath];
}

- (void)updatePath{

    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2;
    CGFloat startAngle = (CGFloat)(0);
    CGFloat endAngle = (CGFloat)(2*M_PI);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.path = path.CGPath;
    
    self.progressLayer.strokeStart = 0.f;
    self.progressLayer.strokeEnd = 0.f;
    
}

#pragma mark show/hidden Loading
- (void)showLoading{
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    [self startAnimating];
    [window addSubview:self];
}

- (void)showLoadingWithView:(UIView *)view{

    [self startAnimating];
    [view addSubview:self];

}


- (BOOL)hideLoading{
    
    [self stopAnimating];
    
    if (!_isAnimating) {
        
        [self removeFromSuperview];
        
        return YES;
    }
    return NO;
}

+ (instancetype)showLoading{

    WJLoadingView *loading = [[self alloc]initWithFrame:CGRectZero];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    [loading startAnimating];
    [window addSubview:loading];
    
    return loading;
}


+ (instancetype)showLoadingWithView:(UIView *)view{

    WJLoadingView *loading = [[self alloc]initWithFrame:CGRectZero];
    [loading startAnimating];
    [view addSubview:loading];
    
    return loading;

}

+ (BOOL)hideLoadingWithView:(UIView *)view{
    
    WJLoadingView *loading = [self getLoadingViewFromView:view];
    
    if (loading !=nil) {
        
        [loading stopAnimating];
        
        [loading removeFromSuperview];
        
        return YES;
    }
    return NO;
}

+ (BOOL)hideLoading{

    WJLoadingView *loading = [self getLoadingView];
    
    if (loading !=nil) {
        
        [loading stopAnimating];
        
        [loading removeFromSuperview];
        
        return YES;
    }
    return NO;
}

+ (instancetype)getLoadingView{

  UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
  NSEnumerator *subviewsEnum = [keyWindow.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (WJLoadingView *)subview;
        }
    }
    return nil;
}

+ (instancetype)getLoadingViewFromView:(UIView *)view{

    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (WJLoadingView *)subview;
        }
    }
    return nil;
}


#pragma mark start/stop Animating
- (void)startAnimating{
   
    if (_isAnimating) {
        return;
    }
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = 1.f;
    headAnimation.fromValue = @(0.f);
    headAnimation.toValue = @(0.25f);
    headAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = 1.f;
    tailAnimation.fromValue = @(0.f);
    tailAnimation.toValue = @(1.f);
    tailAnimation.timingFunction = self.timingFunction;
    
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = 1.f;
    endHeadAnimation.duration = 0.5f;
    endHeadAnimation.fromValue = @(0.25f);
    endHeadAnimation.toValue = @(1.f);
    endHeadAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = 1.f;
    endTailAnimation.duration = 0.5f;
    endTailAnimation.fromValue = @(1.f);
    endTailAnimation.toValue = @(1.f);
    endTailAnimation.timingFunction = self.timingFunction;

    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animation];
    rotationAnimation.keyPath = @"transform.rotation";
    rotationAnimation.byValue = @(M_PI * 2);
    rotationAnimation.timingFunction = self.timingFunction;
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.duration = 1.5;
    [animations setAnimations:@[rotationAnimation,headAnimation,tailAnimation,endHeadAnimation,endTailAnimation]];
    animations.repeatCount = INFINITY;
    [self.progressLayer addAnimation:animations forKey:@"strokeEndAnimation"];

    _isAnimating = YES;
}

- (void)stopAnimating{

    if (!_isAnimating) {
        return;
    }
    [self.progressLayer removeAllAnimations];
    
    _isAnimating = NO;
}



#pragma mark set/get
- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.fillColor = nil;
    }
    return _progressLayer;
}

- (CALayer *)imageLayer{

    if (!_imageLayer) {
        
        _imageLayer = [CALayer layer];
        _imageLayer.contentsGravity = kCAGravityResizeAspect;
    }
    
    return _imageLayer;
}

- (void)setCenterImage:(UIImage *)centerImage{
    
    _imageLayer.contents = (__bridge id)centerImage.CGImage;
    
    [self.layer addSublayer:self.imageLayer];
}

- (void)setLoadingColor:(UIColor *)loadingColor{
    
    _loadingColor = loadingColor;
    self.progressLayer.strokeColor = loadingColor.CGColor;
}
- (void)setLineWidth:(CGFloat)lineWidth{
    
    _lineWidth = lineWidth;
    self.progressLayer.lineWidth = lineWidth;
    
    [self.layer addSublayer:self.progressLayer];
}



@end
