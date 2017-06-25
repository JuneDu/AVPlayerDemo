//
//  ViewController.m
//  PlayerDemo
//
//  Created by DuJun on 2017/6/14.
//  Copyright © 2017年 thebeastshop.com. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
#import "UIView+convenience.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
       [self.navigationController pushViewController:[ViewController1 new] animated:YES];
}


@end
