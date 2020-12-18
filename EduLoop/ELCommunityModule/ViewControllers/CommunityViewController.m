//
//  CommunityViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import "CommunityViewController.h"
#import "UgcCard.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CommunityViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor eh_f6f6f6];
    [self loadData];
    [self setupSubviews];
}


- (void)loadData{
    _models = @[].mutableCopy;
    
    [_models addObject:({
        UgcModel *model = [UgcModel new];
        model.authorName = @"Mijika";
        model.detail =@"发了一条班级圈～";
        model.thumbNum = 4;
        model.commentNum = 5;
        model.dateStr = @"刚刚";
        model;
    })];
    [_models addObject:({
        UgcModel *model = [UgcModel new];
        model.authorName = @"Mijika";
        model.detail =@"发了一条班级圈～";
        model.thumbNum = 4;
        model.commentNum = 5;
        model.dateStr = @"刚刚";
        model;
    })];
    
}
- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_f6f6f6];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    
    [self.view addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-100);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
}


- (ELFloatingButton *)addBtn{
    if(!_addBtn){
        _addBtn = [[ELFloatingButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50) Image: [UIImage imageNamed:@"icon_add"]];
        _addBtn.delegate = self;
    }
    return _addBtn;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"UgcCard";
    UgcCard *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        NSUInteger idx = [indexPath row];
        cell = [[UgcCard alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:self.models[idx]];
//        cell.delegate = self;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 216;
}

#pragma mark - ELFloatingButtonDelegate
- (void)clickFloatingButton{
//    [self jumpToDetailPageWithData:nil];
}


@end
