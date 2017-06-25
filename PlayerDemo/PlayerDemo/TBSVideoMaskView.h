//
//  TBSVideoMaskView.h
//  PlayerDemo
//
//  Created by DuJun on 2017/6/23.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBSVideoMaskView : UIView
@property (nonatomic, strong) UIButton * playBtn;
@property (nonatomic, copy) void(^playBtnClick)(UIButton * btn);
@property (nonatomic, copy) void(^sliderBeginDragBlock)(UISlider * slider);
@property (nonatomic, copy) void(^sliderValueChangeBlock)(UISlider * slider);
@property (nonatomic, copy) void(^sliderEndDragBlock)(UISlider * slider);
@property (nonatomic, copy) void(^fullScreenClick)(UIButton* btn);
@property (nonatomic, strong) UIImageView *placeHolderImageView;
@property (nonatomic, assign) float progressValue;
@property (nonatomic, assign) float slidelValue;
@property (nonatomic, copy) NSString * currentTimeLabelText;
@property (nonatomic, copy) NSString * totalTimeLabelText;
@property (nonatomic, strong) UIView * bottomBackgroundView;


- (void)addTargetOnSlider;
- (void)activityViewStartAnimation;
- (void)activityViewStopAnimation;

@end
