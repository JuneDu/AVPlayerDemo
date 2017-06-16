//
//  ViewController.m
//  PlayerDemo
//
//  Created by DuJun on 2017/6/14.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//

#import "ViewController.h"
#import "TBSVideoPlayerView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor blackColor];
    [super viewDidLoad];
    CGFloat widthX = [UIScreen mainScreen].bounds.size.width;
    TBSVideoPlayerView * player = [[TBSVideoPlayerView alloc]initWithFrame:CGRectMake(0, 100, widthX, widthX * 9 / 16)];
    player.videoUrl = [NSURL URLWithString:@"https://v.u.pingcoo.com/v/aa/bf/61b0679009708d72f2e2c6b691d3b21f.mp4"];
    player.showBottomBar = NO;
    [self.view addSubview:player];
}




@end
