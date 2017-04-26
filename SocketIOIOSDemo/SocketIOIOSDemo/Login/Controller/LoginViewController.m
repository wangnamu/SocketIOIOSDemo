//
//  LoginViewController.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/9.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewProtocol.h"
#import "LoginPresenter.h"
#import "UserInfoRepository.h"
#import "RealmConfig.h"
#import "MainViewController.h"
#import "SocketIOManager.h"
#import "MyChat.h"

@interface LoginViewController ()<LoginViewProtocol>

@property (nonatomic,strong) id<LoginPresenterProtocol> presenter;

@property (nonatomic,strong) UITextField* tbUserName;
@property (nonatomic,strong) UITextField* tbPassWord;
@property (nonatomic,strong) UIButton* btnOK;

@end

@implementation LoginViewController

@synthesize presenter;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    presenter = [[LoginPresenter alloc] initWithView:self];
    [self initControl];
    
    [self.tbUserName setText:@"wangnan"];
    [self.tbPassWord setText:@"123"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initControl {
    
    WS(ws);
    
    self.tbUserName = [[UITextField alloc] init];
    self.tbUserName.placeholder = @"请输入用户名";
    self.tbUserName.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tbUserName];
    
    self.tbPassWord = [[UITextField alloc] init];
    self.tbPassWord.placeholder = @"请输入密码";
    self.tbPassWord.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tbPassWord];
    
    self.btnOK = [[UIButton alloc] init];
    [self.btnOK setTitle:@"登    录" forState:UIControlStateNormal];
    self.btnOK.backgroundColor = [UIColor blackColor];
    self.btnOK.layer.cornerRadius = 10;
    self.btnOK.layer.masksToBounds = YES;
    [self.view addSubview:self.btnOK];
    
    
    [self.btnOK addTarget:self action:@selector(sumbit:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tbUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view.mas_top).offset(100);
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        make.centerX.equalTo(ws.view.mas_centerX);
    }];

    [self.tbPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.tbUserName.mas_bottom).offset(20);
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        make.centerX.equalTo(ws.view.mas_centerX);
    }];
    
    [self.btnOK mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.tbPassWord.mas_bottom).offset(30);
        make.left.equalTo(ws.view.mas_left).offset(50);
        make.right.equalTo(ws.view.mas_right).offset(-50);
        make.height.equalTo(@(44.0f));
    }];

}


- (void)sumbit:(id)sender {
    [presenter loginUserName:self.tbUserName.text PassWord:self.tbPassWord.text];
}

#pragma mark LoginPresenterProtocol

- (void)loginSuccess {

    [RealmConfig setUp:[[UserInfoRepository sharedClient] currentUser].UserName];
    
    MainViewController *mainViewController = [[MainViewController alloc] init];
    self.view.window.rootViewController = mainViewController;
    
    [[SocketIOManager sharedClient] connect];
    [[MyChat sharedClient] getRecent];
}

- (void)loginFail:(NSString *)errorMsg {
    [self.tbPassWord setText:nil];
}

@end
