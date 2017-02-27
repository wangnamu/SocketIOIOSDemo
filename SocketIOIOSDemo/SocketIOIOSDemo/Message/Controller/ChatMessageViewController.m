//
//  ChatMessageViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/24.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatMessageViewController.h"
#import "ChatHostTableViewCell.h"
#import "ChatGuestTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSInteger const elapsedTime = 15;
@interface ChatMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation ChatMessageViewController
@synthesize table;
@synthesize dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initControl];
    
    dataSource = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< 10; i++) {
        
        int value = arc4random() % 2;
        
        if (value == 0) {
            
            int f = arc4random() % 2;
            
            ChatMessageBean *bean = [[ChatMessageBean alloc] init];
            bean.SID = @"adasdada";
            bean.SenderID = @"BBB";
            bean.Title = @"aaaa";
            bean.Time = (long)[[NSDate date] timeIntervalSince1970];
            bean.MessageType = MessageTypeText;
            bean.NickName = @"赵宇环";
            bean.HeadPortrait = @"http://192.168.19.83:8080/NettySocketioWebDemo/img/2.jpg";
            bean.ChatID = @"1";
            bean.SendStatusType = SendStatusTypeReaded;
            
            if (f == 0) {
                bean.Thumbnail = @"Big";
                bean.MessageType = MessageTypeImage;
            }
            else {
                bean.Body = @"据国外媒体报道称，苹果日前成功获得了 iCloud.net 域名的所有权，这可以说是同该公司旗下 iCloud 服务有关的最后一项极具价值的互联网资产。虽然目前我们尚不清楚苹果是在什么时候完成这一域名收购的。";
                bean.MessageType = MessageTypeText;
            }
            
            [dataSource addObject:bean];
        }
        else {
            
            int f = arc4random() % 2;
            
            ChatMessageBean *bean = [[ChatMessageBean alloc] init];
            bean.SID = @"babababba";
            bean.SenderID = @"AAA";
            bean.Title = @"bbbb";
            bean.Time = (long)[[NSDate date] timeIntervalSince1970];
            bean.NickName = @"王南";
            bean.HeadPortrait = @"http://192.168.19.83:8080/NettySocketioWebDemo/img/1.jpg";
            bean.ChatID = @"2";
            bean.SendStatusType = SendStatusTypeError;
            
            if (f == 0) {
                bean.Thumbnail = @"Big";
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
    
    ChatMessageBean* bean = [dataSource objectAtIndex:indexPath.row];
    
    if ([bean isHost]) {
        ChatHostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatHostTableViewCellIdentifier];
        
        [self configureCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        ChatGuestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatGuestTableViewCellIdentifier];
        
        [self configureCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = YES;
    
    long lastTime = indexPath.row - 1 > 0 ? ((ChatMessageBean*)[dataSource objectAtIndex:indexPath.row - 1]).Time : 0;
    ChatMessageBean* bean = [dataSource objectAtIndex:indexPath.row];
    
    if ([bean isHost]) {
        [(ChatHostTableViewCell*)cell setupWithModel:bean Current:bean.Time Last:lastTime Position:indexPath.row Elapsed:elapsedTime];
    }
    else {
        [(ChatGuestTableViewCell*)cell setupWithModel:bean Current:bean.Time Last:lastTime Position:indexPath.row Elapsed:elapsedTime];
    }
    
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
