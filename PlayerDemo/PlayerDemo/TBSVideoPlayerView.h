//
//  TBSVideoPlayerView.h
//  PlayerDemo
//
//  Created by DuJun on 2017/6/14.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBSVideoPlayerView : UIView
@property (nonatomic, copy) NSURL * videoUrl;
@property (nonatomic, assign)BOOL showBottomBar;
-(void)play;
- (void)resume;
@end
