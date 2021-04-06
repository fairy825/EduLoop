//
//  LoginViewController.m
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import "LoginViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "IdentitySelectViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
//    [self loadData];
    [self setupSubviews];
}


- (void)setupSubviews{
    [self.view addSubview:self.logo];
    [self.logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(180, 180));
    }];
    
    
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(self.view.bounds.size.height/3);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
        make.height.equalTo(@200);
    }];
    
    [self.view addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
        make.height.equalTo(@200);
    }];
    
    [self.inputView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputView).offset(10);
        make.left.equalTo(self.inputView);
        make.width.equalTo(@50);
    }];
    
    [self.inputView addSubview:self.userNameTextField];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.userNameLabel);
        make.left.equalTo(self.userNameLabel.mas_right).offset(20);
        make.right.equalTo(self.inputView);
    }];
    
    UIView * underLine = [[UIView alloc]init];
    underLine.backgroundColor = [UIColor color999999];
    [self.inputView addSubview:underLine];
    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom);
        make.left.equalTo(self.userNameTextField);
        make.right.equalTo(self.userNameTextField);
        make.height.equalTo(@1);
    }];
    
    [self.inputView addSubview:self.passwordLabel];
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(40);
        make.left.equalTo(self.inputView);
        make.width.equalTo(@50);
    }];
    
    [self.inputView addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.passwordLabel);
        make.left.equalTo(self.userNameTextField);
        make.right.equalTo(self.userNameTextField);
    }];
    
    UIView * underLine2 = [[UIView alloc]init];
    underLine2.backgroundColor = [UIColor color999999];
    [self.inputView addSubview:underLine2];
    [underLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom);
        make.left.equalTo(self.passwordTextField);
        make.right.equalTo(self.passwordTextField);
        make.height.equalTo(@1);
    }];
    
    [self.inputView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.inputView);
        make.width.equalTo(self.inputView);
        make.height.equalTo(@40);
        make.bottom.equalTo(self.inputView);
    }];
     
    
}

#pragma mark - views
- (UIImageView *)logo{
    if(!_logo){
        _logo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        _logo.contentMode = UIViewContentModeScaleToFill;
        _logo.layer.cornerRadius = 25;
        _logo.layer.masksToBounds = YES;
        _logo.image = [UIImage imageNamed:@"logo_home_family"];
    }
    return _logo;
}

- (UIView *)inputView{
    if(!_inputView){
        _inputView = [[UIView alloc]init];
        _inputView.backgroundColor = [UIColor f6f6f6];
    }
    return _inputView;
}

- (UIButton *)loginBtn{
    if(!_loginBtn){
        _loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
        _loginBtn.backgroundColor = [UIColor color5bb2ff];
        [_loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16]];
        _loginBtn.layer.cornerRadius = 20;
        _loginBtn.layer.masksToBounds = NO;
        _loginBtn.layer.shadowColor = [UIColor grayColor].CGColor;
        _loginBtn.layer.shadowOffset = CGSizeMake(5,5);
        _loginBtn.layer.shadowOpacity = 0.7;
        _loginBtn.layer.shadowRadius = 10;
        [_loginBtn addTarget:self action:@selector(registerAndLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UILabel *)userNameLabel{
    if(!_userNameLabel){
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        _userNameLabel.font = [UIFont fontWithName:@"PingFangSC" size:20.f];
        _userNameLabel.textColor = [UIColor blackColor];
        _userNameLabel.text = @"账号";
        [_userNameLabel sizeToFit];
    }
    return _userNameLabel;
}

- (UILabel *)passwordLabel{
    if(!_passwordLabel){
        _passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        _passwordLabel.font = [UIFont fontWithName:@"PingFangSC" size:20.f];
        _passwordLabel.textColor = [UIColor blackColor];
        _passwordLabel.text = @"密码";
        [_passwordLabel sizeToFit];
    }
    return _passwordLabel;
}

- (UITextField *)userNameTextField{
    if(!_userNameTextField){
        _userNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(0,0, 60, 30)];
        _userNameTextField.keyboardType = UIKeyboardTypeNumberPad;

        _userNameTextField.textAlignment = NSTextAlignmentLeft;
        _userNameTextField.backgroundColor = [UIColor clearColor];
        _userNameTextField.textColor = [UIColor color999999];
        _userNameTextField.font = [UIFont systemFontOfSize:18];
        _userNameTextField.borderStyle = UITextBorderStyleNone;
        _userNameTextField.placeholder = @"请输入手机号";
        _userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _userNameTextField;
}

- (UITextField *)passwordTextField{
    if(!_passwordTextField){
        _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(0,0, 60, 30)];
        _passwordTextField.textAlignment = NSTextAlignmentLeft;
        _passwordTextField.backgroundColor = [UIColor clearColor];
        _passwordTextField.textColor = [UIColor color999999];
        _passwordTextField.font = [UIFont systemFontOfSize:18];
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _passwordTextField;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissKeyboard];
}

- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - action
-(void)registerAndLogin{
    [self jumpToIdentitySelectPage];
}

- (void)jumpToIdentitySelectPage{
    [self.navigationController pushViewController:[[IdentitySelectViewController alloc]init] animated:YES];
}
@end
