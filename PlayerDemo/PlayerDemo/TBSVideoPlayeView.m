//
//  TBSVideoPlayeView.m
//  PlayerDemo
//
//  Created by DuJun on 2017/6/23.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//

#import "TBSVideoPlayeView.h"
#import "TBSVideoMaskView.h"
#import <AVFoundation/AVFoundation.h>
@interface TBSVideoPlayeView()
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) CGRect smallFrame;
@property (nonatomic, assign) CGRect bigFrame;
@property (nonatomic, strong) TBSVideoMaskView *videoMaskView;
@property (nonatomic, assign) BOOL isDragSlider;
@property (nonatomic, assign) NSInteger currentPlayTime;
@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, assign) PlayerState playerState;
@property (nonatomic, strong) id timeObserver;//播放器时间观察者

@end
@implementation TBSVideoPlayeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews:frame];
    }
    return self;
}

- (void)setupSubViews:(CGRect)frame {
    self.smallFrame = frame;
    self.bigFrame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

     self.player = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
    if([[UIDevice currentDevice] systemName].floatValue >= 10.0) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    }
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.playerLayer.frame = frame;
    [self.layer insertSublayer:self.playerLayer atIndex:0];
    self.videoMaskView = [[TBSVideoMaskView alloc]initWithFrame:frame];
    
    __weak typeof(self) weakSelf = self;
    [self addSubview:self.videoMaskView];
    
    self.videoMaskView.playBtnClick = ^(UIButton *btn) {
        btn.selected?[weakSelf play]:[weakSelf pause];
    } ;
    
    self.videoMaskView.fullScreenClick = ^(UIButton *btn) {
        btn.selected = !btn.selected;
         if (btn.selected) {
             [UIView animateWithDuration:0.3 animations:^{
                weakSelf.transform = CGAffineTransformMakeRotation(M_PI / 2);
            } completion:nil];
             weakSelf.frame = weakSelf.bigFrame;
            
        }else {
             [UIView animateWithDuration:0.3 animations:^{
                weakSelf.transform = CGAffineTransformMakeRotation(M_PI * 2);
            } completion:nil];
            weakSelf.frame = weakSelf.smallFrame;
        }
 
        
    };
    
    self.videoMaskView.sliderBeginDragBlock = ^(UISlider *slider) {
        [weakSelf progressSliderTouchBegan:slider];
    };
    
    self.videoMaskView.sliderValueChangeBlock = ^(UISlider *slider) {
        [weakSelf progressSliderTouchValueChanged:slider];
    };
    
    self.videoMaskView.sliderEndDragBlock = ^(UISlider *slider) {
        [weakSelf progressSliderTouchEnd:slider];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self setTheProgressOfPlayTime];
}
//设置播放进度和时间
-(void)setTheProgressOfPlayTime{
    __weak typeof(self) weakSelf = self;
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 10.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (weakSelf.isDragSlider) {
            return ;
        }
        float current= CMTimeGetSeconds(time);
        float total= CMTimeGetSeconds([weakSelf.playerItem duration]);
        weakSelf.currentPlayTime = current;
        weakSelf.totalTime = total;
         if (current) {
             weakSelf.videoMaskView.slidelValue = (current/total);
         }
        NSInteger proSec = (NSInteger)current%60;
        NSInteger proMin = (NSInteger)current/60;
        NSInteger durSec = (NSInteger)total%60;
        NSInteger durMin = (NSInteger)total/60;
        weakSelf.videoMaskView.currentTimeLabelText = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];
        weakSelf.videoMaskView.totalTimeLabelText = [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
        
    } ];
}

#pragma mark - 滑杆滑动事件
/**开始拖动滑杆**/
-(void)progressSliderTouchBegan: (UISlider *)slider {
    
    if (!self.playerItem || ![self.player currentItem].duration.value || ![self.player currentItem].duration.timescale) {
        return;
    }
    
    self.isDragSlider = YES;
    
}

/**滑动中**/
- (void)progressSliderTouchValueChanged: (UISlider *)slider {
    
    if (!self.playerItem || ![self.player currentItem].duration.value || ![self.player currentItem].duration.timescale) {
        return;
    }
    
    CGFloat total = [self.player currentItem].duration.value / [self.player currentItem].duration.timescale;
    CGFloat current = total * slider.value;
    
    NSInteger proSec = (NSInteger)current % 60;
    
    NSInteger proMin = (NSInteger)current / 60;
    
    self.videoMaskView.currentTimeLabelText = [NSString stringWithFormat:@"%02zd:%02zd", proMin, proSec];

}

/**滑动结束**/
- (void)progressSliderTouchEnd: (UISlider *)slider {
    self.isDragSlider = NO;
    if (!self.playerItem || ![self.player currentItem].duration.value || ![self.player currentItem].duration.timescale) {
        return;
    }
    [self.player pause];
    [self.videoMaskView activityViewStartAnimation];
    CGFloat total = [self.player currentItem].duration.value / [self.player currentItem].duration.timescale;
    CGFloat current = total * slider.value;
    CMTime dragTime = CMTimeMake(current, 1);
    
    __weak typeof(self) weakself = self;
    [self.player seekToTime:dragTime completionHandler:^(BOOL finished) {
        
        [weakself play];
        weakself.videoMaskView.bottomBackgroundView.hidden = NO;
    }];
    
}
- (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL  {
    AVURLAsset * asset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    AVAssetImageGenerator * gen = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = CMTimeMakeWithSeconds(0.0, 1);
    gen.appliesPreferredTrackTransform = YES;
    NSError * error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage * screenImage = [UIImage imageWithCGImage:image];
    return screenImage;
}

-(void)setVideoUrlStr:(NSString *)videoUrlStr {
    _videoUrlStr = videoUrlStr;
    self.videoMaskView.placeHolderImageView.image = [self thumbnailImageForVideo:[NSURL URLWithString:self.videoUrlStr]];
    //将之前的监听时间移除掉。
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    self.playerItem = nil;
    if([NSURL URLWithString:videoUrlStr]) {
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:videoUrlStr]];
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        // AVPlayer播放完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(playInterrupt:)
                                                    name:AVPlayerItemPlaybackStalledNotification
                                                  object:self.playerItem];
        // 监听播放状态
        [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // 监听loadedTimeRanges属性
        [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // Will warn you when your buffer is good to go again.
        [self.playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];

         [self.videoMaskView activityViewStartAnimation];
    }
  }

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (object == self.playerItem) {
        if ([keyPath isEqualToString:@"status"]) {
            if (self.player.status == AVPlayerStatusReadyToPlay) {
                [self.videoMaskView activityViewStartAnimation];
                [self addTargetOnSlider];
                
            } else if (self.player.status == AVPlayerStatusFailed){
                [self.videoMaskView activityViewStartAnimation];
                NSLog(@"不能播放");
            }
        } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
            NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
            CMTime duration             = self.playerItem.duration;
            CGFloat totalDuration       = CMTimeGetSeconds(duration);
            self.videoMaskView.progressValue = (timeInterval / totalDuration);
            
        }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
            [self.videoMaskView activityViewStopAnimation];
            
        }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]) {
             [self.videoMaskView activityViewStartAnimation];
        }
    }
}
// 应用退到后台
- (void)appDidEnterBackground{
    [self pause];
}

// 应用进入前台
- (void)appDidEnterPlayGround{
     [self play];
 }

- (void)play {
    [self.player play];
     self.playerState = Playing;
}

- (void)pause {
    [self.player pause];
     self.playerState = Pause;
 }

- (void)addTargetOnSlider {
    [self.videoMaskView addTargetOnSlider];
}

- (void)playDidEnd:(NSNotification *)notification{
    self.videoMaskView.placeHolderImageView.hidden = NO;
    [self.videoMaskView activityViewStopAnimation];
    __weak typeof(self) weakself = self;
    [self.player seekToTime:CMTimeMake(0, 1) completionHandler:^(BOOL finish){
        weakself.videoMaskView.slidelValue = 0.0;
         weakself.videoMaskView.currentTimeLabelText = @"00:00";
    }];
    self.playerState = Stoped;
    self.videoMaskView.playBtn.selected = NO;
}

- (void)playInterrupt: (NSNotification *)notification {
    
    [self.videoMaskView activityViewStartAnimation];
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (void)layoutSubviews {
     [super layoutSubviews];
    self.videoMaskView.frame = self.bounds;
    self.playerLayer.frame = self.bounds;
}


-(void)setFullScreenPlay:(BOOL)fullScreenPlay {
    if(fullScreenPlay){
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
    } completion:nil];
        self.frame = self.bigFrame;
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI * 2);
        } completion:nil];
        self.frame = self.smallFrame;
    }
 }

-(void)setShowBottomBar:(BOOL)showBottomBar {
    self.videoMaskView.bottomBackgroundView.hidden = !showBottomBar;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.player removeTimeObserver:self.timeObserver];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}

@end
