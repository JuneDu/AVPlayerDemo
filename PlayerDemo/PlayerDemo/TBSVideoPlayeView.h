//
//  TBSVideoPlayeView.h
//  PlayerDemo
//
//  Created by DuJun on 2017/6/23.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**视频播放的状态**/
typedef NS_ENUM(NSInteger, PlayerState) {
    
    Playing, // 播放中
    Stoped, // 停止播放
    Pause, // 暂停播放
    ReadyToPlay //准备好播放了
    
} ;


@interface TBSVideoPlayeView : UIView
@property (nonatomic, copy) NSString *videoUrlStr;
@property (nonatomic, assign) BOOL fullScreenPlay;
@property (nonatomic, assign) BOOL   showBottomBar;
@end
