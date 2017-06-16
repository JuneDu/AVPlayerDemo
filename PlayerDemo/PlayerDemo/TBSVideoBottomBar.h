//
//  TBSVideoBottomBar.h
//  PlayerDemo
//
//  Created by DuJun on 2017/6/15.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBSVideoBottomBar : UIView
@property (nonatomic, strong) UISlider       *playSlider;  //滑竿
@property (nonatomic, strong) UILabel        *timeGuideLabel;
@property (nonatomic, strong) UIButton       *stopButton;//播放暂停按钮
@property (nonatomic, copy) dispatch_block_t  buttonClickBlock;//播放暂停按钮
@property (nonatomic, copy) dispatch_block_t  sliderChangeBlock;//播放暂停按钮
@property (nonatomic, copy) dispatch_block_t  startTimerBlock;//播放暂停按钮
@property (nonatomic, copy) dispatch_block_t  suspendTimerBlock;//播放暂停按钮
@property (nonatomic, copy) NSString*  timeGuideText;
@property (nonatomic, assign) CGFloat   sliderValue;
@property (nonatomic, assign) BOOL   playState;

 @end
