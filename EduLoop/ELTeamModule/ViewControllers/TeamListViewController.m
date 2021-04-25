//
//  TeamListViewController.m
//  EduLoop
//
//  Created by mijika on 2021/4/24.
//

#import "TeamListViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "ELOverlay.h"
#import "ELCenterOverlay.h"
#import <AFNetworking.h>
#import "BasicInfo.h"
#import <MJRefresh.h>
#import "ELNetworkSessionManager.h"
#import "TeamEditViewController.h"
#import "GetAllMyTeamResponse.h"
#import "InputTeamCodeViewController.h"
#import "TeamDetailViewController.h"
@interface TeamListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TeamListViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self scanTeamNetwork:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
    _teams = @[].mutableCopy;
    self.page=1;
    [self setNavagationBar];
    [self setupSubviews];
}

- (void)setNavagationBar{
    [self setTitle:@"班级管理"];
}

- (void)endRefresh{
    if (self.page == 1) {
           [self.tableView.mj_header endRefreshing];
    }
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - network
-(void)deleteTeamNetworkWithId:(NSString *)tid success:(nullable void (^)())success{
    [BasicInfo DELETE:[BasicInfo url:@"/team/teacher" path:tid] success:success];
}

-(void)quitTeamNetworkWithId:(NSString *)tid success:(nullable void (^)())success{
    [BasicInfo DELETE:[NSString stringWithFormat:@"%@%@%@",
                       [BasicInfo url:@"/team/"],
                       tid,
                       @"/quit/teacher"]
              success:success];
}

- (void)scanTeamNetwork:(BOOL) isRefresh{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    int start = 1;
    int size = BasicInfo.pageSize;
    if(isRefresh==NO){
        start=self.page+1;
    }
    NSDictionary *paramDict =  @{@"start":[NSString stringWithFormat:@"%d", start],@"size":[NSString stringWithFormat:@"%d", size]
    };
    [manager GET:[BasicInfo url:@"/team"] parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(isRefresh){
            self.page=1;
            [self.teams removeAllObjects];
        }
        [self endRefresh];
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            GetAllMyTeamResponse *model =[[GetAllMyTeamResponse alloc] initWithDictionary:responseObject error: nil];
            if(start>model.data.total){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.page=start;
            }
            if(isRefresh){
                [self.teams removeAllObjects];
            }
            [self.teams addObjectsFromArray: model.data.rows];
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }
        [self.tableView reloadData];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor f6f6f6];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self scanTeamNetwork:YES];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    //文字颜色
    header.stateLabel.textColor = [UIColor color999999];
    header.lastUpdatedTimeLabel.textColor = [UIColor color999999];
    //字体
    header.stateLabel.font = [UIFont systemFontOfSize:15];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    //普通
    [header setTitle:@"往下拉刷新数据" forState:MJRefreshStateIdle];
    //松开可以刷新
    [header setTitle:@"松开加载数据" forState:MJRefreshStatePulling];
    //正在刷新
    [header setTitle:@"拼命加载中..." forState:MJRefreshStateRefreshing];
    //文字慢慢的显现
    header.automaticallyChangeAlpha = YES;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self scanTeamNetwork:NO];
    }];
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    //正在刷新
    [header setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"拼命加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;

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
    return self.teams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger idx = [indexPath row];
    TeamModel *model = self.teams[idx];
    if (!cell) {
//        cell = [[UITableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
        cell = [[UITableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id];
    }
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@",@"邀请码", model.code ];
//    cell.data = model;
//    cell.delegate = self;
//    [cell loadData];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    [self jumpToDetailPageWithData:self.teams[row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger index = [indexPath row];
    TeamModel *team = [self.teams objectAtIndex:index];
    NSMutableArray *array = [NSMutableArray array];
    UITableViewRowAction *action;
    if([ELUserInfo sharedUser].id == team.creatorId){
        action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"解散" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"点击了解散");
            [self pushHint:@"确认解散班级？" Cancel:^{
                [self deleteTeamNetworkWithId:[NSString stringWithFormat:@"%ld",(long)team.id] success:^{
                    [self.teams removeObjectAtIndex:index];
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
            }];
        }];
    }else{
        action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"退出" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                NSLog(@"点击了退出");
                [self pushHint:@"确认退出班级？" Cancel:^{
                [self quitTeamNetworkWithId:[NSString stringWithFormat:@"%ld",(long)team.id] success:^{
                [self.teams removeObjectAtIndex:index];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        }];
                }];
        }];
    }
    [array addObject:action];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了编辑");
        NSInteger index = [indexPath row];
        [self.navigationController pushViewController:[[TeamEditViewController alloc]initWithData:[self.teams objectAtIndex:index]] animated:YES];
    }];
    editAction.backgroundColor = [UIColor color5bb2ff];
    [array addObject:editAction];
    return array;
}
 
- (void)pushHint:(NSString *)hint Cancel:(nullable void (^)(void))block{
    ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
    centerOverlayModel.title = hint;
    centerOverlayModel.leftChoice = ({
        ELOverlayItem *sureItem =[ELOverlayItem new];
        sureItem.title = @"确认";
        __weak typeof(self) wself = self;
        sureItem.clickBlock = ^{
            __strong typeof(self) sself = wself;
            if(block!=nil) block();

        };
        sureItem;
    });
    ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
    ];
    
    [deleteAlertView showHighlightView];
}

#pragma mark - ELFloatingButtonDelegate
- (void)clickFloatingButton{
    __weak typeof(self) wself = self;
    ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:self.view.bounds Data:@[({
        ELOverlayItem *item = [ELOverlayItem new];
        item.title =@"创建班级";
        item.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.navigationController pushViewController:[[TeamEditViewController alloc]initWithData:nil] animated:YES];
        };
        item;
    }),({
        ELOverlayItem *item = [ELOverlayItem new];
        item.title =@"加入班级";
        item.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.navigationController pushViewController:[[InputTeamCodeViewController alloc]initWithTeacher] animated:YES];
        };
        item;
    })]];
    [overlay showHighlightView];
}

#pragma mark - action
- (void)jumpToDetailPageWithData:(TeamModel *)model{
    [self.navigationController pushViewController:[[TeamDetailViewController alloc]initWithTeam:model] animated:YES];
}
@end

