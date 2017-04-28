//
//  ChatMessagePresenter.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessagePresenterProtocol.h"
#import "ChatMessageViewProtocol.h"

@interface ChatMessagePresenter : NSObject<ChatMessagePresenterProtocol>

@property (nonatomic,weak) id<ChatMessageViewProtocol> chatMessageView;
@property (nonatomic, strong) dispatch_queue_t queue;


- (instancetype)initWithView:(id<ChatMessageViewProtocol>)view;

@end
