//
//  PersonListViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/13.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "PersonListViewController.h"
#import "PersonListViewProtocol.h"
#import "PersonListPresenter.h"
#import "PersonListTableViewCell.h"

#import "ChatViewProtocol.h"
#import "ChatPresenter.h"
#import "ChatMessageViewController.h"
#import "ChatBean.h"

@interface PersonListViewController ()<PersonListViewProtocol,UITableViewDataSource,UITableViewDelegate,ChatViewProtocol>

@property (nonatomic,strong) id<PersonListPresenterProtocol> personListPresenter;
@property (nonatomic,strong) id<ChatPresenterProtocol> chatPresenter;

@property (nonatomic,strong) UITableView *table;

@end

@implementation PersonListViewController
@synthesize personListPresenter,table;
@synthesize chatPresenter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    personListPresenter = [[PersonListPresenter alloc] initWithView:self];
    
    chatPresenter = [[ChatPresenter alloc] initWithView:self];
    
    [self initControl];
    
    [personListPresenter loadDataFromUrl];
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
    
    [table registerNib:[UINib nibWithNibName:PersonListTableViewCellNib bundle:nil] forCellReuseIdentifier:PersonListTableViewCellIdentifier];
    
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
 
    PersonListTableViewCell *cell = (PersonListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:PersonListTableViewCellIdentifier];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonListTableViewCell *personCell = (PersonListTableViewCell*)cell;
    PersonBean *bean = (PersonBean*)[personListPresenter.dataSource objectAtIndex:indexPath.row];
    [personCell setup:bean];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PersonListTableViewCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return personListPresenter.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    PersonBean *bean = (PersonBean*)[personListPresenter.dataSource objectAtIndex:indexPath.row];
//    [chatPresenter createChatWithType:ChatTypeSingle ReceivePerson:bean];
}



#pragma mark PersonListPresenterProtocol

- (void)refreshData {
    [table reloadData];
}

- (void)chatPushTo:(NSString *)chatID Name:(NSString *)name{
    ChatMessageViewController *chatMessageViewController = [[ChatMessageViewController alloc] initWithChatID:chatID Name:name];
    chatMessageViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatMessageViewController animated:YES];
}



@end
