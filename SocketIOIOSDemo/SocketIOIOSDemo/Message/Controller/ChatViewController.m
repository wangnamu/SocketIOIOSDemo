//
//  ChatViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "ChatViewController.h"
#import "ChatMessageViewController.h"
#import "ChatTableViewCell.h"
#import "ChatViewProtocol.h"
#import "ChatPresenter.h"
#import "SocketIOManager.h"
#import "MyChat.h"



@interface ChatViewController ()<UITableViewDataSource,UITableViewDelegate,ChatViewProtocol>

@property (nonatomic,strong) id<ChatPresenterProtocol> chatPresenter;

@property (nonatomic,strong) UITableView *table;

@end

@implementation ChatViewController
@synthesize table;
@synthesize chatPresenter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    chatPresenter = [[ChatPresenter alloc] initWithView:self];
    
    [self initControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChat:) name:Notification_Update_Chat object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRecentBegin) name:Notification_Get_Recent_Begin object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRecentFinish) name:Notification_Get_Recent_Finish object:nil];
    
    [chatPresenter loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)initControl {
    
    self.navigationItem.title = @"消息";
    
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    table.dataSource = self;
    table.delegate = self;
    
    [table registerNib:[UINib nibWithNibName:ChatTableViewCellNib bundle:nil] forCellReuseIdentifier:ChatTableViewCellIdentifier];
    
    [self.view addSubview:table];
    
    WS(ws);
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top);
        make.left.equalTo(ws.view.mas_left);
        make.bottom.equalTo(ws.view.mas_bottom);
        make.right.equalTo(ws.view.mas_right);
    }];
    
}

#pragma mark notification

- (void)updateChat:(NSNotification*)notification {
    [chatPresenter updateChat];
}


- (void)getRecentBegin {
    [self showNavigationLoading];
}

- (void)getRecentFinish {
    [self hideNavigationLoading];
    [chatPresenter updateChat];
}

#pragma mark view protocol

- (void)refreshData {
    [table reloadData];
}

- (void)showNavigationLoading {
    
    int padding = 8.0f;
    
    UIView *titleView = [[UIView alloc] init];
    
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView.hidesWhenStopped = YES;
    [actView startAnimating];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(actView.frame.size.width + 8, 0, 80, actView.frame.size.height)];
    [label setFont:[UIFont boldSystemFontOfSize:17.0f]];
    [label setText:@"收取中..."];
    
    titleView.frame = CGRectMake(0, 0, actView.frame.size.width + padding + label.frame.size.width, 20);
    
    [titleView addSubview:actView];
    [titleView addSubview:label];
    
    self.navigationItem.titleView = titleView;
}

- (void)hideNavigationLoading {
    self.navigationItem.titleView = nil;
}


#pragma mark tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatTableViewCell *cell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ChatTableViewCellIdentifier];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatTableViewCell *chatCell = (ChatTableViewCell*)cell;
    ChatModel *model = (ChatModel*)[chatPresenter.dataSource objectAtIndex:indexPath.row];
    [chatCell setup:model];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ChatTableViewCellHeight;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return chatPresenter.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel *model = (ChatModel*)[chatPresenter.dataSource objectAtIndex:indexPath.row];
    ChatMessageViewController *chatMessageViewController = [[ChatMessageViewController alloc] initWithChatID:model.SID Name:model.Name];
    
    chatMessageViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatMessageViewController animated:YES];
}



@end
