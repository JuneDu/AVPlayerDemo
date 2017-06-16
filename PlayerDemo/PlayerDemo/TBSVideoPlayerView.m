//
//  TBSVideoPlayerView.m
//  PlayerDemo
//
//  Created by DuJun on 2017/6/14.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//

#import "TBSVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <SDAutoLayout.h>
#import "NSDate+Utils.h"
#import "TBSVideoBottomBar.h"
typedef NS_ENUM(NSInteger, PlayerState) {
    TBSPlayerStatePlay = 0,//播放状态
    TBSPlayerStateSuspend, //暂停播放
};
@interface TBSVideoPlayerView()
@property (nonatomic,strong) AVPlayer * videoPlayer;
@property (nonatomic, strong) AVPlayerItem   *currentPlayerItem;
@property (nonatomic, strong) AVURLAsset     *videoURLAsset;
@property (nonatomic, strong) AVPlayerLayer  *currentPlayerLayer;
@property (nonatomic, strong) TBSVideoBottomBar         *bottomBar;
@property (nonatomic, strong) UILabel        *timeGuideLabel;
@property (nonatomic, strong) UIProgressView *videoProgressView;  //缓冲进度条
@property (nonatomic, strong) UISlider       *playSlider;  //滑竿
@property (nonatomic, strong) UIImageView       *imageView;  //滑竿
@property (nonatomic, strong) UIButton       *stopButton;//播放暂停按钮
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UIImageView * placeHolderImageView;
/* 定时器 */
@property (nonatomic, assign) PlayerState playState;

@property (nonatomic, copy) NSString * totalTime;


@end
@implementation TBSVideoPlayerView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
     }
    return self;
}

- (void)setup {
    [self addSubview:self.bottomBar];
     _bottomBar.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).bottomSpaceToView(self, 0).heightIs(44);
//    self.showBottomBar = YES;
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToShowBottomBar)];
//    tap.numberOfTapsRequired = 1;
//    [self addGestureRecognizer:tap];
}
-(void)setShowBottomBar:(BOOL)showBottomBar {
    self.bottomBar.hidden = !showBottomBar;
}

//- (void)clickToShowBottomBar {
//    self.showBottomBar = !self.showBottomBar;
//    self.bottomBar.hidden = self.showBottomBar;
//}
//
-(UIImageView *)placeHolderImageView {
    
    if(!_placeHolderImageView) {
        _placeHolderImageView = [[UIImageView alloc]init];
        _placeHolderImageView.userInteractionEnabled = YES;
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"susppend_icon"] forState:UIControlStateNormal];
         [_placeHolderImageView addSubview:btn];
        [self addSubview:_placeHolderImageView];
         _placeHolderImageView.sd_layout.leftSpaceToView(self, 0).rightSpaceToView(self, 0).topSpaceToView(self, 0).bottomSpaceToView(self, 0);
        btn.sd_layout.centerXEqualToView(_placeHolderImageView).centerYEqualToView(_placeHolderImageView).heightIs(50).widthIs(50);
        [btn addTarget:self action:@selector(clcikToPlay:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _placeHolderImageView;
}

-(void)clcikToPlay:(UIButton*) btn{
    [self play];
}
- (TBSVideoBottomBar*)bottomBar {
    __weak TBSVideoPlayerView * weakself = self;
    if(!_bottomBar) {
        _bottomBar = [[TBSVideoBottomBar alloc]init];
        _bottomBar.buttonClickBlock = ^{
            [weakself resumeOrPause];
        };
        _bottomBar.sliderChangeBlock = ^{
            [weakself playSliderChange];
        };
        _bottomBar.suspendTimerBlock = ^{
            [weakself suspendProgressTimer];
        };
        
        _bottomBar.startTimerBlock = ^{
            [weakself startProgressTimer];
        };
        
        [self addSubview:_bottomBar];
    }
    return _bottomBar;
}

- (void)playStateEnd {
    [NSDate cancelTimer:self.timer];
    self.timer = nil;
    _bottomBar.playState = YES;
     [self.videoPlayer seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    _bottomBar.sliderValue = 0;
    _bottomBar.timeGuideText = [NSString stringWithFormat:@"00:00/%@",_totalTime];
    self.placeHolderImageView.hidden = NO;
 }

-(void)resumeOrPause {
     if(self.playState == TBSPlayerStateSuspend) {
        [self startProgressTimer];
    }else {
        [self suspendProgressTimer];
    }
}

- (dispatch_source_t)timer {
    if (!_timer) {
        __weak TBSVideoPlayerView * weakself = self;
        _timer =  [NSDate timerForInterval:0.5 action:^{
            [weakself updateProgressInfo];
        }];
        [NSDate suspendWithTimer:_timer];
    }
    return _timer;
}

//手指开始拖动，播放器暂停播放，挂起定时器
- (void)playSliderTouchBegin:(UISlider *)slider{
    [self suspendProgressTimer];
    [self playSliderChange];
 }

- (void)suspendProgressTimer{
    _bottomBar.playState = YES;

    [NSDate cancelTimer:self.timer];
    self.timer = nil;
    [self.videoPlayer pause];
    _playState = TBSPlayerStateSuspend;

}

- (void)startProgressTimer {
    _bottomBar.playState = NO;
    [NSDate startWithTimer:self.timer];
    self.placeHolderImageView.hidden = YES;
     [self.videoPlayer play];
    _playState = TBSPlayerStatePlay;

}

////手指正在拖动，播放器继续播放，但是停止滑竿的时间走动
- (void)playSliderChange{
    NSTimeInterval currentTime = CMTimeGetSeconds(self.videoPlayer.currentItem.duration) * self.bottomBar.playSlider.value;
    // 设置当前播放时间
    [self.videoPlayer seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
 }

- (AVPlayer *)videoPlayer {
    if(!_videoPlayer) {
        self.videoURLAsset = [AVURLAsset URLAssetWithURL:self.videoUrl options:nil];
        self.currentPlayerItem = [AVPlayerItem playerItemWithAsset:_videoURLAsset];
        _videoPlayer = [AVPlayer playerWithPlayerItem:self.currentPlayerItem];
        self.currentPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
        self.currentPlayerLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self.layer insertSublayer:self.currentPlayerLayer below:self.bottomBar.layer];
        
    }
    return _videoPlayer;

}

- (void)updateProgressInfo{
     self.bottomBar.timeGuideText = [self timeString];
    CGFloat value = CMTimeGetSeconds(self.videoPlayer.currentTime) / CMTimeGetSeconds(self.videoPlayer.currentItem.duration);
    self.bottomBar.sliderValue = value;
    if(CMTimeGetSeconds(self.videoPlayer.currentTime) == CMTimeGetSeconds(self.videoPlayer.currentItem.duration)) {
        [self playStateEnd];
    }

}

- (NSString *)timeString{
     NSTimeInterval duration = CMTimeGetSeconds(self.videoPlayer.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.videoPlayer.currentTime);
        return [self stringWithCurrentTime:currentTime duration:duration];
}

- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration{
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    _totalTime = durationString;
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

-(void)play {
    [self startProgressTimer];
}

- (void)resume{
    [self suspendProgressTimer];
}

-(void)setVideoUrl:(NSURL *)videoUrl {
    _videoUrl = videoUrl;
    self.placeHolderImageView.image = [self thumbnailImageForVideo:self.videoUrl];
    
}

- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL  {
    AVURLAsset * asset = [[AVURLAsset alloc]initWithURL:self.videoUrl options:nil];
    AVAssetImageGenerator * gen = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMakeWithSeconds(0.0, 1);
    gen.appliesPreferredTrackTransform = YES;
    NSError * error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage * screenImage = [UIImage imageWithCGImage:image];
    return screenImage;
}
@end
