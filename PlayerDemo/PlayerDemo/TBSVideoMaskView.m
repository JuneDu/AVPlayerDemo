//
//  TBSVideoMaskView.m
//  PlayerDemo
//
//  Created by DuJun on 2017/6/23.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//

#import "TBSVideoMaskView.h"
#import <SDAutoLayout.h>
@interface TBSVideoMaskView()
@property (nonatomic, strong) UIActivityIndicatorView * activityView;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UIButton *fullScreenBtn;
@property (nonatomic, strong) UISlider *videoSlider;
@property (nonatomic, strong) UIProgressView *progessView;

@end

@implementation TBSVideoMaskView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews {
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:self.activityView];
    self.bottomBackgroundView = [[UIView alloc] init];
    self.bottomBackgroundView.backgroundColor = [UIColor whiteColor];
    self.bottomBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self addSubview:self.bottomBackgroundView];
    
    self.playBtn = [self creatButtonWithNormalImageName:@"icon_play" selectedImageName:@"icon_pause" highLightImageName:@"icon_pause_hl"];
    [self.playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
     [self.bottomBackgroundView addSubview:self.playBtn];
    
    self.currentTimeLabel =  [self creatLabelWithFont:[UIFont systemFontOfSize:11] textColor:[UIColor whiteColor] originalText: @"00:00" textAlignment:NSTextAlignmentCenter];
     [self.bottomBackgroundView addSubview:self.currentTimeLabel];
    
    self.totalTimeLabel = [self creatLabelWithFont:[UIFont systemFontOfSize:11] textColor:[UIColor whiteColor] originalText: @"00:00" textAlignment:NSTextAlignmentCenter];
     [self.bottomBackgroundView addSubview:self.totalTimeLabel];

    self.fullScreenBtn =  [self creatButtonWithNormalImageName:@"kr-video-player-fullscreen" selectedImageName:@"kr-video-player-fullscreen" highLightImageName:@"kr-video-player-fullscreen"];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
       [self.bottomBackgroundView addSubview:self.fullScreenBtn];
    
    self.videoSlider = [[UISlider alloc]init];
    [self.videoSlider setThumbImage:[UIImage imageNamed:@"slider_icon"] forState:UIControlStateNormal];
    self.videoSlider.minimumTrackTintColor = [UIColor colorWithRed:0/255.f green:76/255.f blue:70/255.f alpha:1];
    self.videoSlider.maximumTrackTintColor =  [UIColor colorWithRed:131/255.f green:131/255.f blue:131/255.f alpha:1];
    [self.bottomBackgroundView addSubview:self.videoSlider];
    
    self.progessView = [[UIProgressView alloc]init];
    self.progessView.progressTintColor = [UIColor colorWithRed:0/255.f green:76/255.f blue:70/255.f alpha:1];
    self.progessView.trackTintColor = [UIColor clearColor];
    
    [self.bottomBackgroundView addSubview:self.progessView];
    [self addSubview:self.placeHolderImageView];

}

- (UILabel*)creatLabelWithFont:(UIFont*)font textColor:(UIColor*)textColor originalText:(NSString*)originalText textAlignment:(NSTextAlignment)textAlignment{
  UILabel * label = [[UILabel alloc]init];
    label.text = originalText;
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    return label;
}
- (UIButton*)creatButtonWithNormalImageName:(NSString*)normalImage selectedImageName:(NSString*)selectedImage highLightImageName:(NSString*)hightImgeName {
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:hightImgeName] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
    btn.selected = NO;
    return btn;
}
//playBtnClick
- (void)playBtnClick: (UIButton *)button {
    self.playBtn.selected = !self.playBtn.selected;
    if (self.playBtnClick) {
        self.playBtnClick(self.playBtn);
    }
}

- (void)fullScreenBtnCLick: (UIButton *)button {
    if (self.fullScreenClick) {
        self.fullScreenClick(button);
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
     CGFloat width = self.frame.size.width;
    CGFloat heihgt = self.frame.size.height;
    self.playBtn.frame = CGRectMake(0, 0, 50, 50);
    CGPoint center = CGPointMake(width / 2, heihgt / 2);
    self.activityView.center = center;
    self.placeHolderImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.bottomBackgroundView.frame = CGRectMake(0, heihgt - 50, width, 50);
    
    self.currentTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.playBtn.frame), 0, 60, self.bottomBackgroundView.frame.size.height);
    self.fullScreenBtn.frame = CGRectMake(width - 50, 0, 50, self.bottomBackgroundView.frame.size.height);
    CGFloat totalX = CGRectGetMinX(self.fullScreenBtn.frame);
    self.totalTimeLabel.frame = CGRectMake(totalX - 60, 0, 60, self.bottomBackgroundView.frame.size.height);
    
     CGFloat sliderWidth = width - (220);
    self.videoSlider.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLabel.frame), 0, sliderWidth, self.bottomBackgroundView.frame.size.height);
    
    self.progessView.frame = CGRectMake(CGRectGetMaxX(self.currentTimeLabel.frame), 24, sliderWidth, self.bottomBackgroundView.frame.size.height + 3);
}


- (void)addTargetOnSlider {

    [self.videoSlider removeTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    
    [self.videoSlider removeTarget:self action:@selector(progressSliderTouchEnd:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
    
    [self.videoSlider removeTarget:self action:@selector(progressSliderTouchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.videoSlider addTarget:self action:@selector(progressSliderTouchEnd:) forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchCancel | UIControlEventTouchUpOutside];
 }

//拖拽开始
- (void)progressSliderTouchBegan:(UISlider *)slider {
    if(self.sliderBeginDragBlock) {
        self.sliderBeginDragBlock(slider);
    }
}
//拖拽中
- (void)progressSliderTouchValueChanged:(UISlider*)slider {
    if(self.sliderValueChangeBlock) {
        self.sliderValueChangeBlock(slider);
    }
}
//拖拽结束
- (void)progressSliderTouchEnd:(UISlider*)slider {
    if(self.sliderEndDragBlock) {
        self.sliderEndDragBlock(slider);
    }
}

-(UIImageView *)placeHolderImageView {
    
    if(!_placeHolderImageView) {
        _placeHolderImageView = [[UIImageView alloc]init];
        _placeHolderImageView.userInteractionEnabled = YES;
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"susppend_icon"] forState:UIControlStateNormal];
        [_placeHolderImageView addSubview:btn];
        _placeHolderImageView.hidden = NO;
        btn.sd_layout.centerXEqualToView(_placeHolderImageView).centerYEqualToView(_placeHolderImageView).heightIs(50).widthIs(50);
        [btn addTarget:self action:@selector(clcikToPlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _placeHolderImageView;
}

- (void)clcikToPlay:(UIButton *)btn {
    self.playBtn.selected = YES;
    self.placeHolderImageView.hidden = YES;
    self.playBtnClick(self.playBtn);
}

- (void)activityViewStartAnimation {
    self.bottomBackgroundView.userInteractionEnabled = NO;
    [self.activityView startAnimating];
}

- (void)activityViewStopAnimation{
    self.bottomBackgroundView.userInteractionEnabled = YES;
    [self.activityView stopAnimating];
}

-(void)setProgressValue:(float)progressValue{
    [self.progessView setProgress:progressValue animated:NO];
}

- (void)setSlidelValue:(float)slidelValue {
    [self.videoSlider setValue:slidelValue animated:YES];
}

-(void)setCurrentTimeLabelText:(NSString *)currentTimeLabelText {
    self.currentTimeLabel.text = currentTimeLabelText;
}

-(void)setTotalTimeLabelText:(NSString *)totalTimeLabelText {
    self.totalTimeLabel.text = totalTimeLabelText;
}
@end
