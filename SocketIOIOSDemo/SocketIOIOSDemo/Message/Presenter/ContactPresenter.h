//
//  ContactPresenter.h
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/4/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactPresenterProtocol.h"
#import "ContactViewProtocol.h"

@interface ContactPresenter : NSObject<ContactPresenterProtocol>

@property (nonatomic,weak) id<ContactViewProtocol> contactView;

- (instancetype)initWithView:(id<ContactViewProtocol>)view;

@end

