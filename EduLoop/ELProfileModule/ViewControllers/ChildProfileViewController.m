//
//  ChildProfileViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import "ChildProfileViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
@interface ChildProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChildProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setTitle:@"孩子档案"];
    self.view.backgroundColor = [UIColor f6f6f6];
    self.profileTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.profileTableView.delegate = self;
    self.profileTableView.dataSource = self;
    self.profileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.profileTableView.backgroundColor = [UIColor f6f6f6];

    [self.view addSubview:self.profileTableView];
    [self.profileTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    [self.view addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-100);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
    
//    self.childProfileCard = [[ChildProfileCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-40, 314)];
//    [self.view addSubview:self.childProfileCard];
//    [self.childProfileCard mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
//        make.centerX.equalTo(self.view);
//        make.height.equalTo(@314);
//        make.width.equalTo(@(self.view.bounds.size.width-40));
//    }];
}

- (void)loadData{
    _models = @[].mutableCopy;
    
    [_models addObject:({
        ChildModel *model = [ChildModel new];
        model.grade = @"三年级";
        model.team =@"三（4）班";
        model.nickname = @"王二";
        model.sex = @"女";
        model.relationship = @"妈妈";
        model.sno = @"19";
        model.avatarUrl = @"avatar_child_1";
        model;
    })];
    [_models addObject:({
        ChildModel *model = [ChildModel new];
        model.grade = @"六年级";
        model.team =@"六（3）班";
        model.nickname = @"李四";
        model.sex = @"女";
        model.relationship = @"其他";
        model.sno = @"3";
        model.avatarUrl = @"avatar_child_3";
        model;
    })];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"ChildProfileCard";
    ChildProfileCard *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger row = [indexPath row];
    ChildModel *model = self.models[row];
    if (!cell) {
        cell = [[ChildProfileCard alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
    }
    [cell loadData:model];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90+56*7;
}

- (ELFloatingButton *)addBtn{
    if(!_addBtn){
        _addBtn = [[ELFloatingButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50) Image: [UIImage imageNamed:@"icon_add"]];
        _addBtn.delegate = self;
    }
    return _addBtn;
}
@end
