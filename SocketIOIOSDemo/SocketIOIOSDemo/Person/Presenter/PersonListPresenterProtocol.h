//
//  PersonListPresenterProtocol.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/15.
//  Copyright © 2017年 ufo. All rights reserved.
//


@protocol PersonListPresenterProtocol <NSObject>

@required

@property (nonatomic,strong) NSMutableArray *dataSource;

- (void) loadDataFromUrl;
- (void) loadDataFromLocal;

@end
