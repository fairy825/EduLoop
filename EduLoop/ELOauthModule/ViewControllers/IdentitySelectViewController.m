//
//  IdentitySelectViewController.m
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import "IdentitySelectViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "BasicInfo.h"
#import <AFNetworking.h>
#import "NSString+MD5.h"
#import "UserLoginResponse.h"
@interface IdentitySelectViewController ()<IdentityCardProtocol>

@end

@implementation IdentitySelectViewController
- (instancetype)initWithName:(NSString *)name Pass:(NSString *)password
{
    self = [super init];
    if (self) {
        _name = name;
        _password = password;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
    self.type = 0;
    [self setNavigationBar];
    [self setupSubviews];
}

- (void)setNavigationBar{
    [self setTitle:@"选择身份"];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(userRegisterNetwork)];
}

- (void)setupSubviews{
    self.parentCard = [[IdentityCard alloc]initWithFrame:CGRectZero Type:USER_IDENTITY_PARENT];
    self.parentCard.delegate = self;
    self.teacherCard = [[IdentityCard alloc]initWithFrame:CGRectZero Type:USER_IDENTITY_TEACHER];
    self.teacherCard.delegate = self;

    [self.view addSubview:self.parentCard];
    [self.parentCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(50);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
        make.height.equalTo(@(self.view.bounds.size.height/3));
    }];
    
    [self.view addSubview:self.teacherCard];
    [self.teacherCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.parentCard.mas_bottom).offset(50);
        make.left.equalTo(self.parentCard);
        make.right.equalTo(self.parentCard);
        make.height.equalTo(@(self.view.bounds.size.height/3));
    }];
}

#pragma mark - action
-(void)userRegisterNetwork{
    NSString *salt = @"123456";
    
    NSLog(@"%ld", self.type);
    NSDictionary *paramDict =  @{
        @"name":_name,
        @"password": [NSString md5_32bitWithStr:_password Salt:salt],
        @"salt":salt,
        @"identity": @(_type==1)
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求头
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //添加多的请求格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json", @"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:[BasicInfo url:@"/oauth/register"] parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            if(code!=0){
                NSString* msg = [responseObject objectForKey:@"msg"];
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
            }else{
                UserLoginResponse *resp = [[UserLoginResponse alloc]initWithDictionary:responseObject error:nil];
                [ELUserInfo setUserInfo:resp.data];
                [BasicInfo markUser];
                [self.navigationController pushViewController:[BasicInfo initNavigationTab] animated:YES];

            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

#pragma mark - IdentityCardProtocol
- (void)clickIdentityCard:(IdentityCard *)card{
    if([card.radioBtn isSelected]){
        return;
    }
    else{
        [card.radioBtn setSelected:YES];
        if(card.identity==USER_IDENTITY_PARENT){
            [_teacherCard.radioBtn setSelected:NO];
            self.type = 1;
        }
        else {
            [_parentCard.radioBtn setSelected:NO];
            self.type = 2;
        }
    }
}
@end
