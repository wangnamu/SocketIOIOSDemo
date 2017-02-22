//
//  ChatViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatHostTableViewCell.h"
#import "ChatGuestTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ChatViewController
@synthesize table;
@synthesize dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControl];
    
    dataSource = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< 100; i++) {
        
        int value = arc4random() % 2;
        
        if (value == 0) {
            
            MessageBean *bean = [[MessageBean alloc] init];
            bean.SID = @"adasdada";
            bean.SenderID = @"BBB";
            bean.ReceiverIDs = @"AAA";
            bean.Title = @"aaaa";
            bean.Body = @"什么新闻会上科技圈头条，真让人摸不透。2 月 14 日，情人节，马化腾因为回复了 keso 一条朋友圈说催促微信的付费订阅功能早日上线，上了科技新闻的头条。应了那句话，互联网圈有 3 大高潮：支付宝有新版本，百度有新丑闻，微信有新功能。";
            bean.Time = (long)[[NSDate date] timeIntervalSince1970];
            bean.MessageType = MessageTypeText;
            bean.NickName = @"赵宇环";
            bean.HeadPortrait = @"http://192.168.19.87:8080/NettySocketioWebDemo/img/2.jpg";
            bean.ChatID = @"1";
            bean.SendStatusType = SendStatusTypeSended;
            
            [dataSource addObject:bean];
        }
        else {
            
            int f = arc4random() % 2;
            
            
            MessageBean *bean = [[MessageBean alloc] init];
            bean.SID = @"babababba";
            bean.SenderID = @"AAA";
            bean.ReceiverIDs = @"BBB";
            bean.Title = @"bbbb";
            bean.Time = (long)[[NSDate date] timeIntervalSince1970];
            bean.NickName = @"王南";
            bean.HeadPortrait = @"http://192.168.19.87:8080/NettySocketioWebDemo/img/1.jpg";
            bean.ChatID = @"2";
            bean.SendStatusType = SendStatusTypeSended;
            
            if (f == 0) {
                bean.Thumbnail = @"http://192.168.19.87:8080/NettySocketioWebDemo/img/big.jpg";
                bean.MessageType = MessageTypeImage;
            }
            else {
                bean.Body = @"任何一个完备的后端语言都应该有支持进程间通信（IPC）的方法，本文依旧通过并发循环ID生成器来讲 PHP 中对System V IPC包装的函数族，描述信号量。";
                bean.MessageType = MessageTypeText;
            }
            
            [dataSource addObject:bean];
        }
        
    }
    
    [table reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initControl {
    
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.separatorStyle = NO;

    table.dataSource = self;
    table.delegate = self;
    
    
    [table registerClass:[ChatHostTableViewCell class] forCellReuseIdentifier:ChatHostTableViewCellIdentifier];
    [table registerClass:[ChatGuestTableViewCell class] forCellReuseIdentifier:ChatGuestTableViewCellIdentifier];
    
    [self.view addSubview:table];
    
    WS(ws);
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top);
        make.left.equalTo(ws.view.mas_left);
        make.bottom.equalTo(ws.view.mas_bottom);
        make.right.equalTo(ws.view.mas_right);
    }];
    
}


#pragma mark tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageBean* bean = [dataSource objectAtIndex:indexPath.row];
    
    if ([bean isHost]) {
        ChatHostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatHostTableViewCellIdentifier];
        
        [cell setup:bean];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else {
        ChatGuestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatGuestTableViewCellIdentifier];
        
        [cell setup:bean];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    
}

- (void)configureCell:(ChatHostTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.fd_enforceFrameLayout = YES;
    MessageBean* bean = [dataSource objectAtIndex:indexPath.row];
    [cell setup:bean];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:ChatHostTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}




@end
