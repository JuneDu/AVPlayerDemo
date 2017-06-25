//
//  UIView+convenience.h
//  daShu
//
//  Created by 付朋华 on 15/11/3.
//  Copyright © 2015年 付朋华. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ViewTouchHandler) (UIView *touchView);
@interface UIView (convenience)

@property(nonatomic, strong) id userData;


@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat frameX;
@property (nonatomic) CGFloat frameY;

@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;
@property(nonatomic) CGFloat centerX;
@property(nonatomic) CGFloat centerY;

-(BOOL) containsSubView:(UIView *)subView;
-(BOOL) containsSubViewOfClassType:(Class)aclass;


- (void)HidViewAnimate:(BOOL)animate WithDuration:(CGFloat)duration;
- (void)HidViewAnimate:(BOOL)animate WithDuration:(CGFloat)duration frameY:(CGFloat)frameY;

- (void)showViewAnimate:(BOOL)animate WithDuration:(CGFloat)duration;
- (void)showViewAnimate:(BOOL)animate WithDuration:(CGFloat)duration frameY:(CGFloat)frameY;

- (void)setShowLineBorder:(BOOL)lineBorder;
- (void)setCorner:(NSInteger)width;

- (void)addShadowWithColor:(NSString *)color
              shadowOffset:(CGSize)offset
             shadowOpacity:(CGFloat)shadowOpacity
              shadowRadius:(CGFloat)shadowRadius
               shadowWidth:(CGFloat)shadowWidth;

- (void)addTopShadowWithColor:(NSString *)color
                 shadowOffset:(CGSize)offset
                shadowOpacity:(CGFloat)shadowOpacity
                 shadowRadius:(CGFloat)shadowRadius
                  shadowWidth:(CGFloat)shadowWidth;

- (void)addShadowWithRect:(CGRect)rect
                    color:(NSString *)color
             shadowOffset:(CGSize)offset
            shadowOpacity:(CGFloat)shadowOpacity
             shadowRadius:(CGFloat)shadowRadius
              shadowWidth:(CGFloat)shadowWidth;

-(void)setLayerWithCornerRadius:(CGFloat)cornerRadius;

/**
 设置圆角

 @param radius 圆角半径
 @param corners 圆角位置
 */
- (void)setViewCornerRadius:(CGFloat)radius
          byRoundingCorners:(UIRectCorner)corners
                     bounds:(CGRect)bounds;


- (void)addTouchEvent:(ViewTouchHandler)block;

/**
 设置添加播放imageView
 */
- (void)addSuspendImage;

@end
