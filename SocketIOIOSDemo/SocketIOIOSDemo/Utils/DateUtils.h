//
//  DateUtils.h
//  AFNetworkingExtendDemo
//
//  Created by tjpld on 2016/12/13.
//  Copyright © 2016年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtils : NSObject

+(NSString*)stringFromDate:(NSDate*)date;

+(NSDate*)dateFromString:(NSString*)dateString;

+(long)longFromDate:(NSDate*)date;

+(NSDate*)dateFromLong:(long)msSince1970;

+(NSString*)stringFromLong:(long)msSince1970;

+(long)longFromString:(NSString*)dateString;

+(NSString*)dateToShort:(long)msSince1970;

+(BOOL)inTimeCurrent:(long)current Last:(long)last Elapsed:(NSInteger)elapsed;

@end
