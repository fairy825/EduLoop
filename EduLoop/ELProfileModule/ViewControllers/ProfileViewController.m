//
//  ProfileViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/8.
//

#import "ProfileViewController.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "SettingDataTableViewCell.h"
#import "ELOverlay.h"
@interface ProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ProfileViewController

- (void)loadData{
    _models = @[].mutableCopy;
    
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Image;
        model.title =@"头像";
        model.defaultAvatarImage = [UIImage imageNamed:@"avatar-4"];
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.accessoryType = SettingTableViewCellType_InlineTextField;
        model.title =@"昵称";
        model.detailText = @"Mijika";
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.title =@"账号";
        model.detailText = @"123456";
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"身份";
        model.detailText = @"家长";
        model.clickBlock = ^{
            ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:self.view.bounds Data:@[
                ({
                ELOverlayItem *item = [ELOverlayItem new];
                item.title = @"家长";
                item;
            }),({
                ELOverlayItem *item = [ELOverlayItem new];
                item.title = @"老师";
                item;
            })]];
            [overlay showHighlightView];
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
            make.height.equalTo(@258);
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
    return 4;
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
@end
