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

@end
