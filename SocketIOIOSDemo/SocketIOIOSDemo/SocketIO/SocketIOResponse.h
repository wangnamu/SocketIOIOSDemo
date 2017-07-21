//
//  SocketIOResponse.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/7/19.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketIOResponse : NSObject

@property (nonatomic,assign) BOOL IsSuccess;
@property (nonatomic,copy) NSString* Message;

@end
