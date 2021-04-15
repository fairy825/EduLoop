//
//  ProfileViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/8.
//

#import "ProfileViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "SettingDataTableViewCell.h"
#import "ELOverlay.h"
#import "ELCenterOverlay.h"
#import "ELCenterOverlayModel.h"
#import "BasicInfo.h"
#import "ELUserInfo.h"
#import "UserLoginResponse.h"
@interface ProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ProfileViewController

- (void)loadData{
    ELUserInfo *profile = [ELUserInfo sharedUser];
    _models = @[].mutableCopy;
    
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Image;
        model.title =@"头像";
        model.defaultAvatarImage = [UIImage imageNamed:@"avatar_child_2"];
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = YES;
        model.accessoryType = SettingTableViewCellType_InlineTextField;
        model.title =@"昵称";
        model.detailText = profile.nickname;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.title =@"账号";
        model.detailText = profile.name;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = YES;
        model.title =@"联系方式";
        model.detailText = profile.phone;
        model;
    })];

    /**[_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = YES;
        model.title =@"切换身份至老师";
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
            centerOverlayModel.title = @"确认切换身份至老师？";
            centerOverlayModel.leftChoice = ({
                ELOverlayItem *sureItem =[ELOverlayItem new];
                sureItem.title = @"确认";
                __weak typeof(self) wwself = sself;
                sureItem.clickBlock = ^{
                    __strong typeof(self) ssself = wwself;
                    [ssself.navigationController popViewControllerAnimated:YES];

                };
                sureItem;
            });
            ELCenterOverlay *identityView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
            ];
            
            [identityView showHighlightView];
        };
        model;
    })];*/
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"身份";
        model.detailText = profile.identity==YES?@"家长":@"教师";
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
            centerOverlayModel.title = [NSString stringWithFormat:@"%@%@%@", @"确认切换身份至",profile.identity==YES?@"教师":@"家长",@"？" ];
            centerOverlayModel.leftChoice = ({
                ELOverlayItem *sureItem =[ELOverlayItem new];
                sureItem.title = @"确认";
                __weak typeof(self) wwself = sself;
                sureItem.clickBlock = ^{
                    __strong typeof(self) ssself = wwself;
                    [ssself identityChangeNetworkWithIdentity:!profile.identity];
                };
                sureItem;
            });
            ELCenterOverlay *identityView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
            ];
            
            [identityView showHighlightView];
        };
        model;
    })];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setTitle:@"个人信息"];
    self.view.backgroundColor = [UIColor f6f6f6];
    [self.view addSubview:self.profileTableView];
            [self.profileTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.height.equalTo(@(90+56*4));
        }];
    
    [self.view addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-20);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(20);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-20);
        make.height.equalTo(@32);
    }];

}
#pragma mark - View
- (UITableView *)profileTableView{
    if(!_profileTableView){
        self.profileTableView = [[UITableView alloc]init];
        self.profileTableView.delegate = self;
        self.profileTableView.dataSource = self;
        self.profileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.profileTableView.estimatedRowHeight = 56;
        self.profileTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _profileTableView;
}

- (UIButton *)saveBtn{
    if(!_saveBtn){
        _saveBtn = [[UIButton alloc]init];
        _saveBtn.backgroundColor = [UIColor color5bb2ff];
        _saveBtn.layer.cornerRadius = 15;
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveBtn.titleLabel setTextAlignment: NSTextAlignmentCenter];
        [_saveBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:16]];
    }
    return _saveBtn;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"settingDataTableViewCell";
    SettingDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger row = [indexPath row];
    SettingDataModel *model = self.models[row];
    if (!cell) {
        cell = [[SettingDataTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
    }
    cell.data = model;
    [cell loadData];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if(self.models[row].accessoryType==SettingTableViewCellType_Image)
        return 90;
    return 56;
}

- (void)identityChangeNetworkWithIdentity:(BOOL)identity{
    NSDictionary *paramDict =  @{
        @"identity":[NSNumber numberWithBool:identity]
    };
    [BasicInfo POST:[BasicInfo url:@"/oauth/identity/change"] parameters:paramDict wholesuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        int code = [[responseObject objectForKey:@"code"]intValue];
        if(code!=0){
            NSString* msg = [responseObject objectForKey:@"msg"];
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }else{
            UserLoginResponse *resp = [[UserLoginResponse alloc]initWithDictionary:responseObject error:nil];
            ProfileModel *profile = resp.data;
            [ELUserInfo setUserInfo:profile];
            [BasicInfo markUser];
            
            [self.navigationController pushViewController:[BasicInfo initNavigationTab] animated:YES];
        }
    }];
}
@end
