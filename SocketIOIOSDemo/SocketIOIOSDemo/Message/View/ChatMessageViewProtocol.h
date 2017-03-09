//
//  ChatMessageViewProtocol.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

@protocol ChatMessageViewProtocol <NSObject>

@required
- (void) refreshData;

- (void)insertChatMessageToCell:(NSInteger)row;
- (void)updateChatMessageForCell:(NSInteger)row;


@end
