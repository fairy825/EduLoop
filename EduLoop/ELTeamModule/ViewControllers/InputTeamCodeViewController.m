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
#import <AFNetworking.h>
#import "ELNetworkSessionManager.h"
#import "ChildProfileEditViewController.h"
@interface InputTeamCodeViewController ()

@end

@implementation InputTeamCodeViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _isStudent = YES;
    }
    return self;
}
- (instancetype)initWithStudent:(NSInteger)studentId
{
    self = [super init];
    if (self) {
        _isStudent = YES;
        _personId = studentId;
    }
    return self;
}

- (instancetype)initWithTeacher{
    self = [super init];
    if (self) {
        _isStudent = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
        __weak typeof(self) wself = self;
        _codeField.complete = ^(NSString *code) {
            __strong typeof(self) sself = wself;
            NSLog(@"SecurityCode: %@", code);
            if(sself.isStudent==YES){
                if(sself.personId==0){
                    [sself.navigationController pushViewController:[[ChildProfileEditViewController alloc]initWithTeamCode:code] animated:YES];
                }else{
                    [sself studentJoinTeamNetworkWithCode:code Success:^{
                        
                        [BasicInfo showToastWithMsg:@"成功加入"];
                        NSArray <UIViewController *>*vcs =sself.navigationController.viewControllers;
                        [sself.navigationController popToViewController:[vcs objectAtIndex:vcs.count-3] animated:YES];
                    }];
                }
            }else{
                [sself teacherJoinTeamNetworkWithCode:code];
            }
        };
        
    }
    return _codeField;
}

- (void)studentJoinTeamNetworkWithCode:(NSString *)code Success:(nullable void (^)())success{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    [manager GET:[NSString stringWithFormat:@"%@%@%@%ld",
                  [BasicInfo url:@"/team/"],
                  code,
                  @"/join/",
                  self.personId]
      parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            NSString* msg = [responseObject objectForKey:@"msg"];
            if(code==0){
                success();
                
            }else{
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
            }
        [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}

- (void)teacherJoinTeamNetworkWithCode:(NSString *)code{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    [manager GET:[NSString stringWithFormat:@"%@%@%@",
                  [BasicInfo url:@"/team/"],
                  code,
                  @"/join/teacher"]
      parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            NSString* msg = [responseObject objectForKey:@"msg"];
            if(code==0){
                [BasicInfo showToastWithMsg:@"成功加入"];
            }else{
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
            }
        [self.navigationController popViewControllerAnimated:YES];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}
@end
