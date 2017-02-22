//
//  PersonListPresenter.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/15.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonListPresenterProtocol.h"
#import "PersonListViewProtocol.h"

@interface PersonListPresenter : NSObject<PersonListPresenterProtocol>

@property (nonatomic,weak) id<PersonListViewProtocol> personListView;

- (instancetype)initWithView:(id<PersonListViewProtocol>)view;



@end
