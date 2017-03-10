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
#import "ChatMessageViewProtocol.h"
#import "ChatMessagePresenter.h"
#import "MyChat.h"

static NSInteger const elapsedTime = 15;
@interface ChatMessageViewController ()<UITableViewDataSource,UITableViewDelegate,ChatMessageViewProtocol>

@property (nonatomic,strong) id<ChatMessagePresenterProtocol> chatMessagePresenter;

@property (nonatomic,strong) NSString *currentChatID;
@property (nonatomic,strong) UITableView *table;

@end

@implementation ChatMessageViewController
@synthesize currentChatID;
@synthesize table;
@synthesize chatMessagePresenter;


- (instancetype)initWithChatID:(NSString *)chatID {
    self = [super init];
    if (self) {
        currentChatID = chatID;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    chatMessagePresenter = [[ChatMessagePresenter alloc] initWithView:self];
    
    [self initControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifySend:) name:Notification_Send_Message object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifyReceive:) name:Notification_Receive_Message object:nil];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addData)];
    
    
//    dataSource = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i< 10; i++) {
//        
//        int value = arc4random() % 2;
//        
//        if (value == 0) {
//            
//            int f = arc4random() % 2;
//            
//            ChatMessageBean *bean = [[ChatMessageBean alloc] init];
//            bean.SID = @"adasdada";
//            bean.SenderID = @"BBB";
//            bean.Title = @"aaaa";
//            bean.Time = (long)[[NSDate date] timeIntervalSince1970];
//            bean.MessageType = MessageTypeText;
//            bean.NickName = @"赵宇环";
//            bean.HeadPortrait = @"http://192.168.19.85:8080/NettySocketioWebDemo/img/2.jpg";
//            bean.ChatID = @"1";
//            bean.SendStatusType = SendStatusTypeReaded;
//            
//            if (f == 0) {
//                bean.Thumbnail = @"Big";
//                bean.MessageType = MessageTypeImage;
//            }
//            else {
//                bean.Body = @"据国外媒体报道称，苹果日前成功获得了 iCloud.net 域名的所有权，这可以说是同该公司旗下 iCloud 服务有关的最后一项极具价值的互联网资产。虽然目前我们尚不清楚苹果是在什么时候完成这一域名收购的。";
//                bean.MessageType = MessageTypeText;
//            }
//            
//            [dataSource addObject:bean];
//        }
//        else {
//            
//            int f = arc4random() % 2;
//            
//            ChatMessageBean *bean = [[ChatMessageBean alloc] init];
//            bean.SID = @"babababba";
//            bean.SenderID = @"AAA";
//            bean.Title = @"bbbb";
//            bean.Time = (long)[[NSDate date] timeIntervalSince1970];
//            bean.NickName = @"王南";
//            bean.HeadPortrait = @"http://192.168.19.85:8080/NettySocketioWebDemo/img/1.jpg";
//            bean.ChatID = @"2";
//            bean.SendStatusType = SendStatusTypeError;
//            
//            if (f == 0) {
//                bean.Thumbnail = @"Big";
//                bean.MessageType = MessageTypeImage;
//            }
//            else {
//                bean.Body = @"任何一个完备的后端语言都应该有支持进程间通信（IPC）的方法，本文依旧通过并发循环ID生成器来讲 PHP 中对System V IPC包装的函数族，描述信号量。";
//                bean.MessageType = MessageTypeText;
//            }
//            
//            [dataSource addObject:bean];
//        }
//        
//    }
//    
//    [table reloadData];
    
    
    [chatMessagePresenter loadDataWithChatID:currentChatID];
    [self scrollToBottom:NO];
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


#pragma mark controller action

- (void)addData {
    [chatMessagePresenter sendText:[[NSUUID UUID] UUIDString] ChatID:currentChatID];
}

- (void)onNotifySend:(NSNotification*)notification {
    ChatMessageModel *model = [notification object];
    [chatMessagePresenter updateChatMessage:model];
}

- (void)onNotifyReceive:(NSNotification*)notification {
    ChatMessageModel *model = [notification object];
    [chatMessagePresenter insertChatMessage:model];
}


- (void)scrollToBottom:(BOOL)animated {
    NSInteger section = [table numberOfSections];
    if (section < 1) return;
    NSInteger row = [table numberOfRowsInSection:section-1];
    if (row < 1) return;
    NSIndexPath *index = [NSIndexPath indexPathForRow:row-1 inSection:section-1];
    [table scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}



#pragma mark protocol

- (void)refreshData {
    [table reloadData];
}


- (void)insertChatMessageToCell:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [table beginUpdates];
    [table insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [table endUpdates];
    [self scrollToBottom:YES];
    
}

- (void)updateChatMessageForCell:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [table beginUpdates];
    [table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [table endUpdates];
}



#pragma mark tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatMessageModel* model = [chatMessagePresenter.dataSource objectAtIndex:indexPath.row];
    
    if ([model isHost]) {
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
    
    long lastTime = indexPath.row - 1 > 0 ? ((ChatMessageModel*)[chatMessagePresenter.dataSource objectAtIndex:indexPath.row - 1]).Time : 0;
    ChatMessageModel* model = [chatMessagePresenter.dataSource objectAtIndex:indexPath.row];
    
    if ([model isHost]) {
        [(ChatHostTableViewCell*)cell setupWithModel:model Current:model.Time Last:lastTime Position:indexPath.row Elapsed:elapsedTime];
    }
    else {
        [(ChatGuestTableViewCell*)cell setupWithModel:model Current:model.Time Last:lastTime Position:indexPath.row Elapsed:elapsedTime];
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
    return chatMessagePresenter.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}



@end
