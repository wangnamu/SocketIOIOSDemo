//
//  AFNetworkingClient.h
//  AFNetworkingExtendDemo
//
//  Created by tjpld on 2016/12/9.
//  Copyright © 2016年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define SHOW_PROGRESS               [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];\
                                    [SVProgressHUD show];

#define HIDE_PROGRESS               [SVProgressHUD dismiss];\
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];


#define SHOW_ERROR_PROGRESS(msg)    [SVProgressHUD showErrorWithStatus:msg]; \
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC); \
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){ \
                            [SVProgressHUD dismiss]; \
                            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];\
                        });

//static NSString* const AFAPIBaseURLString = @"http://192.168.16.61:8089/NettySocketioWebDemo/";
static NSString* const AFAPIBaseURLString = @"http://192.168.3.5:8080/NettySocketioWebDemo/";

@interface AFNetworkingClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
