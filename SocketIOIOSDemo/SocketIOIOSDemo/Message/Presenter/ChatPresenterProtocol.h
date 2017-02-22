//
//  ChatPresenterProtocol.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

@protocol ChatPresenterProtocol <NSObject>

@required

@property (nonatomic,strong) NSMutableArray *dataSource;

- (void) loadDataFromUrl;
- (void) loadDataFromLocal;

@end
