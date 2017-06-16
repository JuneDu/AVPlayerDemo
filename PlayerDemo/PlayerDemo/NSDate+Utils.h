//
//  NSDate+Utils.h
//  theBeastApp
//
//  Created by 付朋华 on 16/5/30.
//  Copyright © 2016年 com.thebeastshop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSDate (Utils)

/**
 定时器

 @param seconds 执行间隔时间 单位S
 @param action 事件执行
 @return dispatch_source_t  定时器对象
 */
+ (dispatch_source_t)timerForInterval:(CGFloat)seconds action:(dispatch_block_t)action;


/**
 倒计时

 @param seconds 执行间隔时间 单位S
 @param times 倒计时总时间
 @param action 倒计时执行实践
 @param completion 倒计时完成
 @return dispatch_source_t  定时器对象
 */
+ (dispatch_source_t)countDownTimerForInterval:(NSUInteger)seconds repeatTimes:(NSUInteger)times action:(void (^)(NSUInteger currentSeconds))action competion:(dispatch_block_t)completion;


/**
 关闭定时器

 @param timer dispatch_source_t  定时器对象
 */
+ (void)cancelTimer:(dispatch_source_t)timer;

/**
 开始定时器

 @param timer 定时器对象
 */
+ (void)startWithTimer:(dispatch_source_t)timer;

/**
 暂停定时器

 @param timer 定时器对象
 */
+ (void)suspendWithTimer:(dispatch_source_t)timer;

/**
 时间戳转date

 @param timeInterval 时间戳
 @return date
 */
+ (NSDate *)dateWithTimeInterval:(NSString *)timeInterval;

/**
 时间戳转化为时间字符串 YYYY-MM-dd HH:mm:ss
 
 @param timeInterval timeInterval 时间戳（毫秒
 @return 时间字符串
 */
+ (NSString *)dateStringFromTimeInterval:(NSString *)timeInterval;


/**
 时间戳转化为时间字符串


 @param timeInterval 时间戳（毫秒）
 @param format 时间格式 default  YYYY-MM-dd HH:mm:ss
 @return 时间字符串
 */
+ (NSString *)dateStringFromTimeInterval:(NSString *)timeInterval formatter:(NSString *)format;


/**
 天时分秒格式倒计时

 @param timeInterval 倒计时秒数
 @return 天时分秒格式string
 */
+ (NSString *)countDownStringFromTimeInterval:(NSInteger)timeInterval;

@end
