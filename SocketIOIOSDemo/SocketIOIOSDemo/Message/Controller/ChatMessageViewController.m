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
#import "InputToolbar.h"


static NSInteger const elapsedTime = 15;
@interface ChatMessageViewController ()<UITableViewDataSource,UITableViewDelegate,ChatMessageViewProtocol,InputToolbarDelegate> {
    BOOL keyboardIsVisible;
}

@property (nonatomic,strong) id<ChatMessagePresenterProtocol> chatMessagePresenter;

@property (nonatomic,strong) NSString *currentChatID;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) InputToolbar *inputToolbar;

@end

@implementation ChatMessageViewController
@synthesize currentChatID;
@synthesize table,inputToolbar;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:Notification_Get_Recent_Finish object:nil];
    
    [self loadData];
    [self scrollToBottom:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /* Listen for keyboard */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /* No longer listen for keyboard */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}



- (void)initControl {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    table = [[UITableView alloc] init];
    table.separatorStyle = NO;
    
    table.dataSource = self;
    table.delegate = self;

    [table registerClass:[ChatHostTableViewCell class] forCellReuseIdentifier:ChatHostTableViewCellIdentifier];
    [table registerClass:[ChatGuestTableViewCell class] forCellReuseIdentifier:ChatGuestTableViewCellIdentifier];
    
    [self.view addSubview:table];
    
    
    inputToolbar = [[InputToolbar alloc] init];
    inputToolbar.backgroundColor = [UIColor whiteColor];
    inputToolbar.delegate = self;
    [self.view addSubview:inputToolbar];
    
    WS(ws);
    
    [inputToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(50.0f));
        make.bottom.equalTo(ws.view.mas_bottom).with.offset(-4.0f);
        make.left.equalTo(ws.view.mas_left).with.offset(16.0f);
        make.right.equalTo(ws.view.mas_right).with.offset(-16.0f);
    }];

    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top);
        make.left.equalTo(ws.view.mas_left);
        make.bottom.equalTo(ws.inputToolbar.mas_top);
        make.right.equalTo(ws.view.mas_right);
    }];

    
}


#pragma mark controller action


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
    NSInteger row = [table numberOfRowsInSection:section - 1];
    if (row < 1) return;
    NSIndexPath *index = [NSIndexPath indexPathForRow:row - 1 inSection:section - 1];
    [table scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}



#pragma mark protocol

- (void)loadData {
    [chatMessagePresenter loadDataWithChatID:currentChatID];
}

- (void)refreshData {
    [table reloadData];
}


- (void)insertChatMessageToCell:(NSInteger)row {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [table beginUpdates];
    [table insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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



#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    
    
//    WS(ws);
//    void (^animation)(void) = ^void(void) {
//        
//        if (ws.table.frame.size.height < ws.table.contentSize.height + keyBoardHeight) {
//            ws.table.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight);
//        }
//        
//        
//        
//        [ws scrollToBottom:YES];
//        ws.inputToolbar.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight);
//    };
//    
//    if (animationTime > 0) {
//        [UIView animateWithDuration:animationTime animations:animation];
//    } else {
//        animation();
//    }
    
    
    WS(ws);
    
    [inputToolbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.view.mas_bottom).with.offset(-keyBoardHeight-4.0f);
    }];
    
    
    [table mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top).with.offset(-keyBoardHeight-4.0f);
        make.bottom.equalTo(ws.inputToolbar.mas_top);
    }];
    
    // 更新约束
    [UIView animateWithDuration:animationTime animations:^{
        [ws.view layoutIfNeeded];
        [ws scrollToBottom:YES];
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];

    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
//    WS(ws);
//    void (^animation)(void) = ^void(void) {
//        ws.table.transform = CGAffineTransformIdentity;
//        ws.inputToolbar.transform = CGAffineTransformIdentity;
//    };
//    
//    if (animationTime > 0) {
//        [UIView animateWithDuration:animationTime animations:animation];
//    } else {
//        animation();
//    }

    WS(ws);
    
    [inputToolbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-4.0f);
    }];
    [table mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top);
        make.bottom.equalTo(ws.inputToolbar.mas_top);
    }];
    
    // 更新约束
    [UIView animateWithDuration:animationTime animations:^{
        [ws.view layoutIfNeeded];
    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


- (void)contentTextChanged:(CGFloat)height {

    [inputToolbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    WS(ws);
    [UIView animateWithDuration:0.25 animations:^{
        [ws.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [ws scrollToBottom:NO];
    }];
    
}


- (void)sendButtonPressed:(NSString *)inputText {
    [chatMessagePresenter sendText:inputText ChatID:currentChatID];
}


@end
