//
//  ChatMessageViewProtocol.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

@protocol ChatMessageViewProtocol <NSObject>

@required
- (void)reloadDataComplete;
- (void)loadMoreDataComplete;

//- (void)insertChatMessageToCell:(NSInteger)row;
//- (void)updateChatMessageForCell:(NSInteger)row;

- (void)updateChatMessageCell;
- (void)reloadData;

@end
