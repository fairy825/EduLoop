//
//  TeamDetailViewController.m
//  EduLoop
//
//  Created by mijika on 2021/4/25.
//

#import "TeamDetailViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "ELOverlay.h"
#import "ELCenterOverlay.h"
#import <AFNetworking.h>
#import "BasicInfo.h"
#import <MJRefresh.h>
#import "ELNetworkSessionManager.h"
#import "GetOneTeamResponse.h"
#import "StudentTableViewCell.h"
#import "TeamDetailCard.h"
@interface TeamDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TeamDetailViewController
- (instancetype)initWithTeam:(TeamModel *)team{
    self = [super init];
    if (self) {
        _team = team;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self getTeamDetailNetwork:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
    _students = @[].mutableCopy;
    self.page=1;
    [self setTitle:self.team.name];
    [self setupSubviews];
}

- (void)endRefresh{
    if (self.page == 1) {
           [self.tableView.mj_header endRefreshing];
    }
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - network
- (void)getTeamDetailNetwork:(BOOL) isRefresh{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    int start = 1;
    int size = BasicInfo.pageSize;
    if(isRefresh==NO){
        start=self.page+1;
    }
    NSDictionary *paramDict =  @{@"start":[NSString stringWithFormat:@"%d", start],@"size":[NSString stringWithFormat:@"%d", size]
    };
    [manager GET: [NSString stringWithFormat:@"%@%ld%@",[BasicInfo url:@"/team/"],self.team.id,@"/student"]  parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(isRefresh){
            self.page=1;
            [self.students removeAllObjects];
        }
        [self endRefresh];
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            GetOneTeamResponse *model =[[GetOneTeamResponse alloc] initWithDictionary:responseObject error: nil];
            if(start>model.data.students.total){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.page=start;
            }
            if(isRefresh){
                [self.students removeAllObjects];
            }
            [self.students addObjectsFromArray: model.data.students.rows];
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
        [self getTeamDetailNetwork:YES];
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
        [self getTeamDetailNetwork:NO];
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
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.students.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"StudentTableViewCell";
    StudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger idx = [indexPath row];
    StudentModel *model = self.students[idx];
    if (!cell) {
//        cell = [[UITableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
        cell = [[StudentTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id];
    }
    cell.data = model;
    [cell loadData];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,120)];
    TeamDetailCard *bgView = [[TeamDetailCard alloc]init];
    [bgView loadData:self.team];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = NO;
    bgView.layer.shadowColor = [UIColor grayColor].CGColor;
    bgView.layer.shadowOffset = CGSizeMake(0,5);
    bgView.layer.shadowOpacity = 0.7;
    bgView.layer.shadowRadius = 10;
    [header addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(header);
    }];
    [header layoutIfNeeded];
    return header;
}
@end

