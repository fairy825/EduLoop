//
//  IdentitySelectViewController.m
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import "IdentitySelectViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>

@interface IdentitySelectViewController ()<IdentityCardProtocol>

@end

@implementation IdentitySelectViewController


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
    NSLog(@"%ld", self.type);
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
