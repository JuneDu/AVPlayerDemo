//
//  UIView+convenience.m
//  daShu
//
//  Created by 付朋华 on 15/11/3.
//  Copyright © 2015年 付朋华. All rights reserved.
//

#import "UIView+convenience.h"
#import <objc/runtime.h>
//#import "UIColor+Tools.h"
@interface UIView()
@property (nonatomic,strong) UIImageView * suspendImageView;
@end
static void *userDataKey;
static void *suspendImageViewKey;
static char touchHander;
@implementation UIView (convenience)


-(BOOL) containsSubView:(UIView *)subView
{
    for (UIView *view in [self subviews]) {
        if ([view isEqual:subView]) {
            
            return YES;
        }
    }
    return NO;
}

-(BOOL) containsSubViewOfClassType:(Class)aclass {
    for (UIView *view in [self subviews]) {
        if ([view isMemberOfClass:aclass]) {
            return YES;
        }
    }
    return NO;
}

- (CGPoint)frameOrigin {
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)newOrigin {
    self.frame = CGRectMake(newOrigin.x, newOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)frameSize {
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)newSize {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newSize.width, newSize.height);
}

- (CGFloat)frameX {
    return self.frame.origin.x;
}

- (void)setFrameX:(CGFloat)newX {
    self.frame = CGRectMake(newX, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameY {
    return self.frame.origin.y;
}

- (void)setFrameY:(CGFloat)newY {
    self.frame = CGRectMake(self.frame.origin.x, newY,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setFrameRight:(CGFloat)newRight {
    self.frame = CGRectMake(newRight - self.frame.size.width, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setFrameBottom:(CGFloat)newBottom {
    self.frame = CGRectMake(self.frame.origin.x, newBottom - self.frame.size.height,
                            self.frame.size.width, self.frame.size.height);
}

- (CGFloat)frameWidth {
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)newWidth {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            newWidth, self.frame.size.height);
}

- (CGFloat)frameHeight {
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)newHeight {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, newHeight);
}
- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)showViewAnimate:(BOOL)animate WithDuration:(CGFloat)duration frameY:(CGFloat)frameY {
    self.hidden = NO;
    if (animate) {
        [UIView animateWithDuration:duration animations:^{
            self.frameY = frameY;
        } completion:^(BOOL finished) {
            
        }];
    }else{
        self.frameY = frameY;
    }
    
}

- (void)showViewAnimate:(BOOL)animate WithDuration:(CGFloat)duration {
    [self showViewAnimate:animate WithDuration:duration frameY:0];
    
}

- (void)HidViewAnimate:(BOOL)animate WithDuration:(CGFloat)duration frameY:(CGFloat)frameY {
    if (animate) {
        [UIView animateWithDuration:duration animations:^{
            self.frameY = frameY;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }else{
        self.frameY = frameY;
        self.hidden = YES;
    }
    
}

- (void)HidViewAnimate:(BOOL)animate WithDuration:(CGFloat)duration{
//    [self HidViewAnimate:animate WithDuration:duration frameY:ScreenHeight];
}

#pragma mark user data

- (id)userData {
    id result = objc_getAssociatedObject(self, &userDataKey);
    return result;
}

- (void)setUserData:(id)userData {
    objc_setAssociatedObject(self, &userDataKey, userData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView*)suspendImageView {
    id result = objc_getAssociatedObject(self, &suspendImageViewKey);
    return result;
}

-(void)setSuspendImageView:(UIImageView *)suspendImageView {
    objc_setAssociatedObject(self, &suspendImageViewKey, suspendImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)setShowLineBorder:(BOOL)show {
    if (show) {
//        self.layer.borderColor = [UIColor colorWithHexString:@"#e3e3e3"].CGColor;
        self.layer.borderWidth = 0.5;
    }
}

- (void)setCorner:(NSInteger)width {
    self.layer.cornerRadius = width;
    self.layer.masksToBounds = YES;
}

- (void)addShadowWithColor:(NSString *)color shadowOffset:(CGSize)offset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowWidth:(CGFloat)shadowWidth {
    [self addShadowWithRect:self.bounds color:color shadowOffset:offset shadowOpacity:shadowOpacity shadowRadius:shadowRadius shadowWidth:shadowWidth];
}

- (void)addShadowWithRect:(CGRect)rect
                    color:(NSString *)color
             shadowOffset:(CGSize)offset
            shadowOpacity:(CGFloat)shadowOpacity
             shadowRadius:(CGFloat)shadowRadius
              shadowWidth:(CGFloat)shadowWidth {
//    self.layer.shadowColor = [UIColor colorWithHexString:color alpha:0.2].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = offset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = shadowOpacity;//阴影透明度，默认0
    self.layer.shadowRadius = shadowRadius;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = rect.size.width;
    float height = rect.size.height;
    float x = rect.origin.x;
    float y = rect.origin.y;
    
    CGPoint topLeft      = CGPointMake(0 - shadowWidth, 0 - shadowWidth);
    CGPoint topMiddle = CGPointMake(x+(width/2),y - shadowWidth);
    CGPoint topRight     = CGPointMake(x+width + shadowWidth,y - shadowWidth);
    
    CGPoint rightMiddle = CGPointMake(x+width+shadowWidth,y+(height/2));
    
    CGPoint bottomRight  = CGPointMake(x+width+shadowWidth,y+height + shadowWidth);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+shadowWidth);
    CGPoint bottomLeft   = CGPointMake(x - shadowWidth,y+height + shadowWidth);
    
    
    CGPoint leftMiddle = CGPointMake(x - shadowWidth,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;
}


- (void)addTopShadowWithColor:(NSString *)color shadowOffset:(CGSize)offset shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowWidth:(CGFloat)shadowWidth {
//    self.layer.shadowColor = [UIColor colorWithHexString:color].CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = offset;//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = shadowOpacity;//阴影透明度，默认0
    self.layer.shadowRadius = shadowRadius;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float x = self.bounds.origin.x;
    float y = self.bounds.origin.y;
    
    CGPoint topLeft      = CGPointMake(0 - shadowWidth, 0 - shadowWidth);
    CGPoint topMiddle = CGPointMake(x+(width/2),y - shadowWidth);
    CGPoint topRight     = CGPointMake(x+width + shadowWidth,y - shadowWidth);
    
    CGPoint leftMiddle = CGPointMake(x - shadowWidth,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];

    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;
}

-(void)setLayerWithCornerRadius:(CGFloat)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds  = YES;
}

- (void)setViewCornerRadius:(CGFloat)radius byRoundingCorners:(UIRectCorner)corners bounds:(CGRect)bounds {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addTouchEvent:(ViewTouchHandler)block {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
    [self addGestureRecognizer:tap];
    objc_setAssociatedObject(self, &touchHander, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)actionTap{
    ViewTouchHandler handler = objc_getAssociatedObject(self, &touchHander);
    if (handler) handler(self);
}

- (void)addSuspendImage{
    self.suspendImageView = [[UIImageView alloc]init];
    self.suspendImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.suspendImageView];

    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:self.suspendImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.suspendImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:50];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:self.suspendImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self.suspendImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [self.suspendImageView addConstraint:widthConstraint];
    [self.suspendImageView addConstraint:heightConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:rightConstraint];
    
    self.suspendImageView.image = [UIImage imageNamed:@"susppend_icon"];

}

@end
