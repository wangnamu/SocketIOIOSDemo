//
//  DateUtils.m
//  AFNetworkingExtendDemo
//
//  Created by tjpld on 2016/12/13.
//  Copyright © 2016年 ufo. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+(NSString*)stringFromDate:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];
}

+(NSDate*)dateFromString:(NSString*)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter dateFromString:dateString];
}

+(long)longFromDate:(NSDate*)date {
    return [date timeIntervalSince1970];
}

+(NSDate*)dateFromLong:(long)msSince1970 {
    return [NSDate dateWithTimeIntervalSince1970:msSince1970];
}

+(NSString*)stringFromLong:(long)msSince1970 {
    return [self stringFromDate:[self dateFromLong:msSince1970]];
}

+(long)longFromString:(NSString*)dateString {
    return [self longFromDate:[self dateFromString:dateString]];
}

+(NSString *)dateToShort:(long)msSince1970 {
    
    long different = [[NSDate date] timeIntervalSince1970] - msSince1970;
    
    long secondsInMilli = 1000;
    long minutesInMilli = secondsInMilli * 60;
    long hoursInMilli = minutesInMilli * 60;
    long daysInMilli = hoursInMilli * 24;
    
    long elapsedDays = different / daysInMilli;
    
    if (elapsedDays == 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"a hh:mm"];
        return [dateFormatter stringFromDate:[self dateFromLong:msSince1970]];
    } else if (elapsedDays > 0 && elapsedDays <= 1) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"a hh:mm"];
        return [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:[self dateFromLong:msSince1970]]];
    } else if (elapsedDays > 1 && elapsedDays <= 7) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"E a hh:mm"];
        return [dateFormatter stringFromDate:[self dateFromLong:msSince1970]];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 a hh:mm"];
        return [dateFormatter stringFromDate:[self dateFromLong:msSince1970]];
    }
}

+(BOOL)inTimeCurrent:(long)current Last:(long)last Elapsed:(NSInteger)elapsed {
    
    long different = last - current;
    
    long secondsInMilli = 1000;
    long minutesInMilli = secondsInMilli * 60;
    long hoursInMilli = minutesInMilli * 60;
    long daysInMilli = hoursInMilli * 24;
    
    
    long elapsedDays = different / daysInMilli;
    different = different % daysInMilli;
    
    if (elapsedDays > 0) {
        return true;
    }
    
    long elapsedHours = different / hoursInMilli;
    different = different % hoursInMilli;
    
    if (elapsedHours > 0) {
        return true;
    }
    
    long elapsedMinutes = different / minutesInMilli;
   
    if (elapsedMinutes >= elapsed) {
        return true;
    }
    
    return false;
}

@end
