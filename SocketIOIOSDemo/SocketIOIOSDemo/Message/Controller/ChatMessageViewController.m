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
@interface ChatMessageViewController ()<UITableViewDataSource,UITableViewDelegate,ChatMessageViewProtocol,InputToolbarDelegate>

@property (nonatomic,strong) id<ChatMessagePresenterProtocol> chatMessagePresenter;

@property (nonatomic,strong) NSString *currentChatID;
@property (nonatomic,strong) NSString *currentName;
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) InputToolbar *inputToolbar;

@end

@implementation ChatMessageViewController
@synthesize currentChatID,currentName;
@synthesize table,inputToolbar;
@synthesize chatMessagePresenter;


- (instancetype)initWithChatID:(NSString *)chatID
                          Name:(NSString *)name {
    self = [super init];
    if (self) {
        currentChatID = chatID;
        currentName = name;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:Notification_Get_Recent_Finish object:nil];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    self.navigationItem.title = currentName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    table = [[UITableView alloc] init];
    table.separatorStyle = NO;
    table.dataSource = self;
    table.delegate = self;
    table.backgroundColor = COLOR_FROM_RGB(0xebebeb);

    [table registerClass:[ChatHostTableViewCell class] forCellReuseIdentifier:ChatHostTableViewCellIdentifier];
    [table registerClass:[ChatGuestTableViewCell class] forCellReuseIdentifier:ChatGuestTableViewCellIdentifier];
    [table registerClass:[UITableViewCell self] forCellReuseIdentifier:@"CellLoadMore"];
    
    [self.view addSubview:table];
    
    
    inputToolbar = [[InputToolbar alloc] init];
    inputToolbar.delegate = self;
    [self.view addSubview:inputToolbar];
    
   
    WS(ws);
    
    [inputToolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(InputToolbarHeight));
        make.bottom.equalTo(ws.view.mas_bottom);
        make.left.equalTo(ws.view.mas_left);
        make.right.equalTo(ws.view.mas_right);
    }];
    
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top);
        make.left.equalTo(ws.view.mas_left);
        make.bottom.equalTo(ws.inputToolbar.mas_top);
        make.right.equalTo(ws.view.mas_right);
    }];
    
}


#pragma mark notification


- (void)onNotifySend:(NSNotification*)notification {
    ChatMessageModel *model = [notification object];
    if([model.ChatID isEqualToString:currentChatID]) {
        NSLog(@"send");
        [chatMessagePresenter updateChatMessage:model];
    }
}

- (void)onNotifyReceive:(NSNotification*)notification {
    ChatMessageModel *model = [notification object];
    if ([model.ChatID isEqualToString:currentChatID]) {
        NSLog(@"receive");
        [chatMessagePresenter insertChatMessage:model];
    }
}



#pragma mark view protocol

- (void)loadMoreData {
    [chatMessagePresenter loadMoreDataWithChatID:currentChatID];
}

- (void)loadMoreDataComplete {

    CGPoint initialOffset = table.contentOffset;

    [UIView setAnimationsEnabled:NO];
    CGFloat contentHeightBefore = table.contentSize.height;
    [table reloadData];
    CGFloat contentHeightAfter = table.contentSize.height;
    initialOffset.y += contentHeightAfter - contentHeightBefore;
    [UIView setAnimationsEnabled:YES];
    table.contentOffset = initialOffset;

}


- (void)reloadData {
    [chatMessagePresenter reloadDataWithChatID:currentChatID];
}

- (void)reloadDataComplete {
    [table reloadData];
    [self scrollToBottom:NO];
}


- (void)insertChatMessageToCell:(NSInteger)row {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
//    [table beginUpdates];
//    [table insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [table endUpdates];
//    [self scrollToBottom:YES];
    [table reloadData];
    [self scrollToBottom:YES];

}

- (void)updateChatMessageForCell:(NSInteger)row {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:1];
//    [table beginUpdates];
//    [table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [table endUpdates];
    [table reloadData];
    [self scrollToBottom:YES];
}



#pragma mark tableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UITableViewCell *loadCell = [tableView dequeueReusableCellWithIdentifier:@"CellLoadMore"];
        loadCell.backgroundColor = COLOR_FROM_RGB(0xebebeb);
        
        if (chatMessagePresenter.hasMore && !chatMessagePresenter.isLoading) {
            UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            [act setCenter:loadCell.center];
            act.hidesWhenStopped = YES;
            
            [loadCell addSubview:act];
            [act startAnimating];
        }
        
        
        return loadCell;
    }
    else {
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
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = YES;
    
    long lastTime = indexPath.row - 1 >= 0 ? ((ChatMessageModel*)[chatMessagePresenter.dataSource objectAtIndex:indexPath.row - 1]).Time : 0;
    
    ChatMessageModel* model = [chatMessagePresenter.dataSource objectAtIndex:indexPath.row];
    
    if ([model isHost]) {
        [(ChatHostTableViewCell*)cell setupWithModel:model Current:model.Time Last:lastTime Position:indexPath.row Elapsed:elapsedTime];
    }
    else {
        [(ChatGuestTableViewCell*)cell setupWithModel:model Current:model.Time Last:lastTime Position:indexPath.row Elapsed:elapsedTime];
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (chatMessagePresenter.hasMore) {
            return 44.0f;
        }
        else {
            return 0;
        }
    }
    else {
        return [tableView fd_heightForCellWithIdentifier:ChatHostTableViewCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return chatMessagePresenter.dataSource.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0 && chatMessagePresenter.hasMore && !chatMessagePresenter.isLoading) {
        [self loadMoreData];
    }
    
}



#pragma mark keyborad

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
//    WS(ws);
//    void (^animation)(void) = ^void(void) {
//        
//        ws.table.transform = CGAffineTransformMakeTranslation(0, - keyBoardHeight);
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
        make.bottom.equalTo(ws.view.mas_bottom).with.offset(-keyBoardHeight);
    }];
    
    
    CGFloat differ = SCREEN_HEIGHT - table.contentSize.height - inputToolbar.frame.size.height;
    
    if (keyBoardHeight > differ) {
        
        if (differ <= 0) {
            [table mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ws.view.mas_top).with.offset(-keyBoardHeight);
                make.bottom.equalTo(ws.inputToolbar.mas_top);
            }];
        }
        else {
            CGFloat scrollHeight = keyBoardHeight - differ;;
            [table mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(ws.view.mas_top).with.offset(-scrollHeight);
                make.bottom.equalTo(ws.inputToolbar.mas_top);
            }];
        }
        
    }
    else {
        [table mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.view.mas_top);
            make.bottom.equalTo(ws.inputToolbar.mas_top);
        }];
    }
    
    
    // 更新约束
    [UIView animateWithDuration:animationTime animations:^{
        [ws.inputToolbar layoutIfNeeded];
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
        make.bottom.equalTo(ws.view.mas_bottom);
    }];
    [table mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top);
        make.bottom.equalTo(ws.inputToolbar.mas_top);
    }];
    
    
    // 更新约束
    [UIView animateWithDuration:animationTime animations:^{
        [ws.inputToolbar layoutIfNeeded];
        [ws.view layoutIfNeeded];
    }];
    
}

#pragma mark scroll

- (void)scrollToBottom:(BOOL)animated {
    NSInteger section = [table numberOfSections];
    if (section < 1) return;
    NSInteger row = [table numberOfRowsInSection:section - 1];
    if (row < 1) return;
    NSIndexPath *index = [NSIndexPath indexPathForRow:row - 1 inSection:section - 1];
    [table scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//       
//    //contentsize > framesize 有滚动条
//    //contentoffset -64 滚动到最上面
//    //contentoffset -20 左右
//    
//    if (scrollView.frame.size.height < scrollView.contentSize.height && scrollView.contentOffset.y <= -20 && chatMessagePresenter.hasMore && !chatMessagePresenter.isLoading) {
//        [self loadMoreData];
//    }
//    
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark inputToolbar


-(void)sendButtonPressed:(NSString *)inputText {
    [chatMessagePresenter sendText:inputText ChatID:currentChatID];
}

-(void)contentTextChanged:(CGFloat)height {
    [inputToolbar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
    
    WS(ws);
    [UIView animateWithDuration:0.25 animations:^{
        [ws.inputToolbar layoutIfNeeded];
        [ws.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [ws scrollToBottom:NO];
    }];
}

-(void)customButtonPressed:(NSInteger)tag {
    NSLog(@"%ld",(long)tag);
}



@end
