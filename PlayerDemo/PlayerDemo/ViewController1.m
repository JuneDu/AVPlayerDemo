
//  ViewController1.m
//  PlayerDemo
//
//  Created by DuJun on 2017/6/21.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//
#import "ViewController1.h"
#import "ViewController.h"
#import "TBSVideoPlayeView.h"

@interface ViewController1 ()
@property (nonatomic, strong) TBSVideoPlayeView *player;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    [super viewDidLoad];
    CGFloat deviceWith = [UIScreen mainScreen].bounds.size.width;
    
    self.player = [[TBSVideoPlayeView alloc]initWithFrame:CGRectMake(0, 20, deviceWith, 300)];
    self.player.videoUrlStr = @"https://v.u.pingcoo.com/v/aa/bf/61b0679009708d72f2e2c6b691d3b21f.mp4";
    self.player.fullScreenPlay = NO;
    self.player.showBottomBar = YES;

     [self.view addSubview:self.player];

}

 
@end
