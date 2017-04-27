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

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) BOOL hasMore;
@property (nonatomic,assign) NSInteger pageSize;


- (void)loadMoreDataWithChatID:(NSString*)chatID;

- (void)reloadDataWithChatID:(NSString*)chatID;

- (void)sendText:(NSString*)body
          ChatID:(NSString*)chatID;

- (void)insertChatMessage:(ChatMessageModel*)model;
- (void)updateChatMessage:(ChatMessageModel*)model;



@end
