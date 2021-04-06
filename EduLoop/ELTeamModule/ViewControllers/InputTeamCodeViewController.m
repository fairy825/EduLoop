//
//  InputTeamCodeViewController.m
//  EduLoop
//
//  Created by mijika on 2021/4/5.
//

#import "InputTeamCodeViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "BasicInfo.h"
@interface InputTeamCodeViewController ()

@end

@implementation InputTeamCodeViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [self.codeField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
    [self setNavagationBar];
//    [self loadData];
    [self setupSubviews];
}

- (void)setNavagationBar{
    [self setTitle:@"加入班级"];
}

- (void)setupSubviews{
    [self.view addSubview:self.introLabel];
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(60);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.view addSubview:self.codeField];
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.introLabel.mas_bottom).offset(60);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (UILabel *)introLabel{
    if(!_introLabel){
        _introLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        _introLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
        _introLabel.textColor = [UIColor blackColor];
        _introLabel.text = @"请输入六位班级代码";
        [_introLabel sizeToFit];
    }
    return _introLabel;
}

- (QuickSecurityCode *)codeField{
    if(!_codeField){
        _codeField = [[QuickSecurityCode alloc]init];
        _codeField.preferredSixDigits = YES;
        _codeField.complete = ^(NSString *code) {
            NSLog(@"SecurityCode: %@", code);
            [BasicInfo showToastWithMsg:@"成功加入"];
            [self.navigationController popViewControllerAnimated:YES];
        };
        
    }
    return _codeField;
}
@end
