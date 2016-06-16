//
//  WJLoadingView.h
//  WJLoading
//
//  Created by wangjin on 16/6/15.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WJLoadingView : UIView

@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

@property(nonatomic,assign,readonly) BOOL isAnimating;

/**
 *  show/hide loading -method
 */
- (void)showLoading;
- (BOOL)hideLoading;

- (void)showLoadingWithView:(UIView *)view;

/**
 *  show/hide loading +method
 *
 *  @return  YES/NO
 */
+ (instancetype)showLoading;
+ (BOOL)hideLoading;

+ (instancetype)showLoadingWithView:(UIView *)view;
+ (BOOL)hideLoadingWithView:(UIView *)view;


/**
 *  setting property
 *
 *  @param color line color
 *  @param width line width
 *  @param image center image
 */
- (void)setColor:(UIColor *)color andWidth:(CGFloat)width andImage:(UIImage *)image;

+ (void)setColor:(UIColor *)color andWidth:(CGFloat)width andImage:(UIImage *)image;

+ (void)setColor:(UIColor *)color andWidth:(CGFloat)width andImage:(UIImage *)image withView:(UIView *)view;
@end


