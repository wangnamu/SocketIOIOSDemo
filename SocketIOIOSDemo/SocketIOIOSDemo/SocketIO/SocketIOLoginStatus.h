//
//  SocketIOLoginStatus.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/6/6.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketIOLoginStatus : NSObject

+ (BOOL)isNeedToCheck;
+ (void)setNeedToCheck:(BOOL)status;

@end
