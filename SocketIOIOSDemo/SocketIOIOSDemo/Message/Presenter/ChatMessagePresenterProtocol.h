//
//  ChatMessagePresenterProtocol.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/24.
//  Copyright © 2017年 ufo. All rights reserved.
//


#import "ChatMessageModel.h"

@protocol ChatMessagePresenterProtocol <NSObject>

@required
@property (nonatomic,strong) NSMutableArray *dataSource;

- (void)loadDataWithChatID:(NSString*)chatID;
- (void)sendText:(NSString*)body
          ChatID:chatID;

- (void)insertChatMessage:(ChatMessageModel*)model;
- (void)updateChatMessage:(ChatMessageModel*)model;


@end
