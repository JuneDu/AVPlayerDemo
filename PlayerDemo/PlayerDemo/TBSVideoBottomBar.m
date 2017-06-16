//
//  TBSVideoBottomBar.m
//  PlayerDemo
//
//  Created by DuJun on 2017/6/15.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//

#import "TBSVideoBottomBar.h"
#import <SDAutoLayout.h>
@implementation TBSVideoBottomBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.stopButton];
    [self addSubview:self.playSlider];
    [self addSubview:self.timeGuideLabel];
    
    self.stopButton.sd_layout.leftSpaceToView(self, 10).centerYEqualToView(self).widthIs(14).heightIs(16);
    self.playSlider.sd_layout.leftSpaceToView(self.stopButton, 10).centerYEqualToView(self).rightSpaceToView(self, 15).heightIs(34);
    self.timeGuideLabel.sd_layout.leftSpaceToView(self.stopButton, 10).rightSpaceToView(self, 100).bottomSpaceToView(self, 0).heightIs(11);
  }

- (UILabel *)timeGuideLabel {
    if(!_timeGuideLabel) {
        _timeGuideLabel = [[UILabel alloc] init];
        _timeGuideLabel.textColor = [UIColor colorWithRed:0/255.f green:76/255.f blue:70/255.f alpha:1];
        _timeGuideLabel.font = [UIFont systemFontOfSize:11];
        _timeGuideLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeGuideLabel;
}

- (UIButton*)stopButton {
    if(!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton addTarget:self action:@selector(resumeOrPause) forControlEvents:UIControlEventTouchUpInside];
        [_stopButton setImage:[UIImage imageNamed:@"icon_pause"] forState:UIControlStateNormal];
        [_stopButton setImage:[UIImage imageNamed:@"icon_pause_hl"] forState:UIControlStateHighlighted];
        [_stopButton setImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateSelected];
        _stopButton.selected = YES;
    }
    return _stopButton;
}

-(void)resumeOrPause {
    
     if(self.buttonClickBlock) {
        self.buttonClickBlock();
    }
 }

-(UISlider*)playSlider {
    if(!_playSlider){
        self.playSlider = [[UISlider alloc] init];
        [_playSlider setThumbImage:[UIImage imageNamed:@"slider_icon"] forState:UIControlStateNormal];
        _playSlider.minimumTrackTintColor = [UIColor colorWithRed:0/255.f green:76/255.f blue:70/255.f alpha:1];
        _playSlider.maximumTrackTintColor =  [UIColor colorWithRed:131/255.f green:131/255.f blue:131/255.f alpha:1];
        [_playSlider addTarget:self action:@selector(playSliderChange:) forControlEvents:UIControlEventValueChanged];
        [_playSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchUpInside];
        [_playSlider addTarget:self action:@selector(playSliderChangeEnd:) forControlEvents:UIControlEventTouchUpOutside];
        
        [_playSlider addTarget:self action:@selector(playSliderTouchBegin:) forControlEvents:UIControlEventTouchDown];
    }
    return _playSlider;
}

//手指正在拖动，播放器继续播放，但是停止滑竿的时间走动
- (void)playSliderChange:(UISlider *)slider{
    if(self.sliderChangeBlock) {
        self.sliderChangeBlock();
    }
}

//手指结束拖动，播放器从当前点开始播放，开启滑竿的时间走动
- (void)playSliderChangeEnd:(UISlider *)slider{
    [self playSliderChange:slider];
    if(self.startTimerBlock) {
        self.startTimerBlock();
     }
 }

//手指开始拖动，播放器暂停播放，挂起定时器
- (void)playSliderTouchBegin:(UISlider *)slider{
    if(self.suspendTimerBlock) {
        self.suspendTimerBlock();
    }
     [self playSliderChange:slider];
}

-(void)setSliderValue:(CGFloat)sliderValue{
    self.playSlider.value = sliderValue;
    
}
-(void)setTimeGuideText:(NSString *)timeGuideText {
    self.timeGuideLabel.text = timeGuideText;
}

- (void)setPlayState:(BOOL)playState {
    self.stopButton.selected = playState;
}
@end
