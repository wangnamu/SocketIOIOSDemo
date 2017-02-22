//
//  ResultModel.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/10.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ResultModel.h"

@implementation ResultModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
                @"IsSuccess" : @"isSuccess",
                @"Data" : @"data",
                @"ErrorMessage" : @"errorMessage"
            };
}


@end
