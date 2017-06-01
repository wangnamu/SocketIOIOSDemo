//
//  ChatPresenter.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatPresenterProtocol.h"
#import "ChatViewProtocol.h"

@interface ChatPresenter : NSObject<ChatPresenterProtocol>

@property (nonatomic,weak) id<ChatViewProtocol> chatView;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_semaphore_t sem;

- (instancetype)initWithView:(id<ChatViewProtocol>)view;

@end
