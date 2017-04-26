//
//  ContactPresenterProtocol.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/4/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatModel.h"

@protocol ContactPresenterProtocol <NSObject>

@required

@property (nonatomic,strong) NSMutableArray *dataSource;

- (void)loadData;

@end
