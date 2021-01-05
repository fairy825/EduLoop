//
//  ChildProfileViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import "ChildProfileViewController.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
@interface ChildProfileViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChildProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    [self setTitle:@"孩子档案"];
    self.view.backgroundColor = [UIColor eh_f6f6f6];
    self.profileTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.profileTableView.delegate = self;
    self.profileTableView.dataSource = self;
    self.profileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.profileTableView.backgroundColor = [UIColor eh_f6f6f6];

    [self.view addSubview:self.profileTableView];
    [self.profileTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
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
        model.grade = @"五年级";
        model.school =@"上海小学";
        model.nickname = @"dd";
        model.sex = @"女";
        model;
    })];
    [_models addObject:({
        ChildModel *model = [ChildModel new];
        model.grade = @"六年级";
        model.school =@"上海小学";
        model.nickname = @"cc";
        model.sex = @"女";
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
    return 350;
}

@end
