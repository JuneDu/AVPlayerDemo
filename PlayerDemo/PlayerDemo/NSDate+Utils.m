//
//  NSDate+Utils.m
//  theBeastApp
//
//  Created by 付朋华 on 16/5/30.
//  Copyright © 2016年 com.thebeastshop. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

+ (dispatch_source_t)countDownTimerForInterval:(NSUInteger)seconds repeatTimes:(NSUInteger)times action:(void (^)(NSUInteger currentSeconds))action competion:(dispatch_block_t)completion
{
    __block NSUInteger count = times;
     __block dispatch_source_t timer = nil;
    timer = [self timerForInterval:seconds action:^{
        if (count <= 0) {
            //cancel timer
             [self cancelTimer:timer];
            if (completion) {
                completion();
            }
        } else {
            if (action) {
                action(count);
            }
            count--;
        }
    }];
    return timer;
}

+ (void)cancelTimer:(dispatch_source_t)timer
{
    if (timer) {
        dispatch_source_cancel(timer);
#if !OS_OBJECT_USE_OBJC
        dispatch_release(timer);
#endif
    }
}

+ (void)startWithTimer:(dispatch_source_t)timer {
    if (timer) {
        dispatch_resume(timer);
    }
}

+ (void)suspendWithTimer:(dispatch_source_t)timer {
    if (timer) {
        dispatch_suspend(timer);
    }
}

+ (dispatch_source_t)timerForInterval:(CGFloat)seconds action:(dispatch_block_t)action {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), seconds * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (action) {
                action();
            }
        });
    });
    dispatch_resume(timer);
    return timer;
}


+ (NSString *)dateStringFromTimeInterval:(NSString *)timeInterval {
    return [self dateStringFromTimeInterval:timeInterval formatter:nil];
}


+ (NSString *)dateStringFromTimeInterval:(NSString *)timeInterval formatter:(NSString *)format {
    NSDate *confromTimesp = [self dateWithTimeInterval:timeInterval];
    NSDateFormatter* formatter = [self formatterWithFormat:format];
    NSString *dateString = [formatter stringFromDate:confromTimesp];
    return dateString;
}

+ (NSDate *)dateWithTimeInterval:(NSString *)timeInterval {
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeInterval doubleValue]/1000];
    return confromTimesp;
}


+ (NSDateFormatter *)formatterWithFormat:(NSString *)format {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (!format || !format.length)
        format = @"YYYY-MM-dd HH:mm:ss";
    [formatter setDateFormat:format];
    return formatter;
}

+ (NSString *)countDownStringFromTimeInterval:(NSInteger)timeInterval {
    NSInteger d = timeInterval / (3600 * 24);
    NSInteger h = (timeInterval - d * 24 * 3600) / 3600;
    NSInteger m = (timeInterval - d * 24 * 3600 - h * 3600) / 60;
    NSInteger s = (timeInterval - d * 24 * 3600 - h * 3600) % 60;
    NSString *dayString = @"";
    NSString *hourString = @"";
    NSString *minuteString = @"";
    NSString *secondsString = @"";
    if (d > 0) {
        dayString = [NSString stringWithFormat:@"%d天", (int)d];
    }
    
    if (h > 0) {
        hourString = [NSString stringWithFormat:@"%d小时", (int)h];
    }
    
    if (m > 0) {
        minuteString = [NSString stringWithFormat:@"%02d分钟", (int)m];
    }
    
    if (s > 0) {
        secondsString = [NSString stringWithFormat:@"%02d秒", (int)s];
    }
    NSString *countDownString = [NSString stringWithFormat:@"%@%@%@%@", dayString, hourString, minuteString, secondsString];
    return countDownString;
}

@end
