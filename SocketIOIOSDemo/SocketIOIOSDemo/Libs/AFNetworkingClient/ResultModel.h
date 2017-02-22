//
//  ResultModel.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/10.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultModel : NSObject

@property (nonatomic,assign) BOOL IsSuccess;
@property (nonatomic,strong) id<NSObject> Data;
@property (nonatomic,strong) NSString* ErrorMessage;

@end
