//
//  ContactViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/4/21.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactTableViewCell.h"
#import "ContactViewProtocol.h"
#import "ContactPresenter.h"
#import "ChatMessageViewController.h"
#import "ChatBean.h"
#import "MyChat.h"


@interface ContactViewController ()<ContactViewProtocol,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) id<ContactPresenterProtocol> contactPresenter;

@property (nonatomic,strong) UITableView *table;

@end

@implementation ContactViewController

@synthesize table,contactPresenter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    contactPresenter = [[ContactPresenter alloc] initWithView:self];
    
    [self initControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateContact:) name:Notification_Update_Contact object:nil];
    
    [contactPresenter loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControl {
    
    self.navigationItem.title = @"联系人";
    
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    
    [table registerNib:[UINib nibWithNibName:ContactTableViewCellNib bundle:nil] forCellReuseIdentifier:ContactTableViewCellIdentifier];
    
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
    
    ContactTableViewCell *cell = (ContactTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ContactTableViewCellIdentifier];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContactTableViewCell *contactCell = (ContactTableViewCell*)cell;
    ChatModel *model = (ChatModel*)[contactPresenter.dataSource objectAtIndex:indexPath.row];
    [contactCell setup:model];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ContactTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return contactPresenter.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel *model = (ChatModel*)[contactPresenter.dataSource objectAtIndex:indexPath.row];
    ChatMessageViewController *chatMessageViewController = [[ChatMessageViewController alloc] initWithChatID:model.SID Name:model.Name];
    
    chatMessageViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatMessageViewController animated:YES];
}


#pragma mark notification

- (void)updateContact:(NSNotification*)notification {
    [contactPresenter loadData];
}



#pragma mark ContactPresenterProtocol

- (void)refreshData {
    [table reloadData];
}

- (void)chatPushTo:(NSString *)chatID Name:(NSString *)name{
    ChatMessageViewController *chatMessageViewController = [[ChatMessageViewController alloc] initWithChatID:chatID Name:name];
    chatMessageViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatMessageViewController animated:YES];
}



@end
