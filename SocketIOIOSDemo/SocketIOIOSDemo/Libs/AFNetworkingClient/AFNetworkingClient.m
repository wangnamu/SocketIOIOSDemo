//
//  AFNetworkingClient.m
//  AFNetworkingExtendDemo
//
//  Created by tjpld on 2016/12/9.
//  Copyright © 2016年 ufo. All rights reserved.
//

#import "AFNetworkingClient.h"


@implementation AFNetworkingClient
    
+ (instancetype)sharedClient {
    static AFNetworkingClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.timeoutIntervalForRequest = 60;        
        _sharedClient = [[AFNetworkingClient alloc] initWithBaseURL:[NSURL URLWithString:AFAPIBaseURLString]];
        _sharedClient.responseSerializer = [AFJSONResponseSerializer serializer];
    });
    
    return _sharedClient;
}
    
@end
