//
//  ChatViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/16.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ChatViewController.h"
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChat:) name:Notification_Send_Chat object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateChat:) name:Notification_Receive_Chat object:nil];

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

#pragma mark

- (void)updateChat:(NSNotification*)notification {
    
    ChatModel *model = [notification object];
    [chatPresenter updateChat:model];
    
}


#pragma mark

- (void)refreshData {
    [table reloadData];
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
}



@end
