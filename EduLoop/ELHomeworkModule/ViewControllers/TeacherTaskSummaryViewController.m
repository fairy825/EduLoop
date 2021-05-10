//
//  TeacherTaskSummaryViewController.m
//  EduLoop
//
//  Created by mijika on 2021/3/29.
//

#import "TeacherTaskSummaryViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "TeacherTaskSummaryTableViewCell.h"
#import "HomeworkModel.h"
#import "ELScreen.h"
#import "ReviewViewController.h"
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "BasicInfo.h"
#import "TeacherShowDetailTaskResponse.h"
#import "ELNetworkSessionManager.h"
@interface TeacherTaskSummaryViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TeacherTaskSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self setNavagationBar];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (instancetype)initWithTeacherTaskModel:(TeacherTaskModel *)data
{
    self = [super init];
    if (self) {
        self.page = 1;
        _data = data;
        _models = _data.homeworkLists;
//        [self getAllMyTeamsNetwork];
//        [self loadData:data];
    }
    return self;
}

- (void)setNavagationBar{
    [self setTitle:@"任务详情"];
    self.navigationController.navigationBar.barTintColor = [UIColor color5bb2ff];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.navigationController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_return"] style:UIBarButtonItemStylePlain target:self action:@selector(popout)];
//    UIView *nav = [[UIView alloc]initWithFrame: CGRectMake(50, 0, 200, 50)];
//    nav.backgroundColor = [UIColor color5bb2ff];
//    UILabel *label = [[UILabel alloc]init];
//    label.font = [UIFont fontWithName:@"PingFangSC" size:14.f];
//    label.textColor = [UIColor redColor];
//    label.text = [NSString stringWithFormat:@"%@%@",@"截止提交时间：",_data.endTime];
//    [label sizeToFit];
//    [nav addSubview:label];
//
//    self.navigationItem.titleView = nav;
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableHeaderView:
        ({
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        UIView *bgView = [[UIView alloc]init];
        [header addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header);
        }];
        
        [header addSubview:self.taskDetailCard];
        [self.taskDetailCard mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(header).offset(20);
            make.left.equalTo(header).offset(20);
            make.right.equalTo(header).offset(-20);
        }];
        [self.taskDetailCard loadData:_data];
//        [header layoutIfNeeded];
        [self.taskDetailCard layoutIfNeeded];
        CGFloat h=0;
        for (UIView *view in [header subviews]) {
            h+=view.bounds.size.height;
        }
        header.frame = CGRectMake(0,0, self.view.bounds.size.width, self.taskDetailCard.bounds.size.height+40);
        
        UIBezierPath *maskPath = [UIBezierPath bezierPath];
        [maskPath moveToPoint:CGPointMake(header.frame.origin.x, header.frame.origin.y)];
        [maskPath addLineToPoint:CGPointMake(header.frame.origin.x, header.frame.origin.y+header.frame.size.height/2)];
        [maskPath addQuadCurveToPoint:CGPointMake(header.frame.origin.x+header.frame.size.width, header.frame.origin.y+header.frame.size.height/2) controlPoint:CGPointMake(header.frame.origin.x+header.frame.size.width/2, header.frame.origin.y+header.frame.size.height*2/3)];
        [maskPath addLineToPoint:CGPointMake(header.frame.origin.x+header.frame.size.width, header.frame.origin.y+header.frame.size.height/2)];
        [maskPath addLineToPoint:CGPointMake(header.frame.origin.x+header.frame.size.width, header.frame.origin.y)];
        [maskPath closePath];

        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = header.bounds;
        maskLayer.path = maskPath.CGPath;
//        maskLayer.fillColor = [UIColor redColor].CGColor;
        bgView.layer.mask = maskLayer;
        bgView.backgroundColor = [UIColor color5bb2ff];
        header;
        })];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self teacherShowDetailTaskNetworkWithTaskId:self.data.id];
    }];
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    //正在刷新
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"拼命加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
}

-(void)loadData{
}


- (void)endRefresh{
    if (self.page == 1) {
           [self.tableView.mj_header endRefreshing];
    }
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - network
-(void) teacherShowDetailTaskNetworkWithTaskId:(NSInteger)taskId{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    int start = 1;
    int size = BasicInfo.pageSize;
    start=self.page+1;
    
    NSDictionary *paramDict =  @{@"start":[NSString stringWithFormat:@"%d", start],@"size":[NSString stringWithFormat:@"%d", size]
    };
    [manager GET:[BasicInfo url:@"/task/teacher" path:[NSString stringWithFormat:@"%ld",(long)taskId]] parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self endRefresh];
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            TeacherShowDetailTaskResponse *response = [[TeacherShowDetailTaskResponse alloc]initWithDictionary:responseObject error:nil];
            TeacherTaskModel *taskModel = response.data;
            
            if(start>taskModel.totalPages){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.page=start;
            }
            
            [self.models addObjectsFromArray: taskModel.homeworkLists];
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }
        [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.homeworkLists.count;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @" ";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"TeacherTaskSummaryTableViewCell";
    TeacherTaskSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger idx = [indexPath row];
    HomeworkModel *model = self.models[idx];
    if (!cell) {
        cell = [[TeacherTaskSummaryTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.data = model;
    [cell loadData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    [self jumpToDetailPageWithData:_models[row]];
}

- (void)jumpToDetailPageWithData:(HomeworkModel *)model{
    [self.navigationController pushViewController: [[ReviewViewController alloc]initWithHomeworkModel:model TaskModel:(TaskModel *)self.data Student:nil] animated:YES];

}

- (TaskDetailCard *)taskDetailCard{
    if(!_taskDetailCard){
        _taskDetailCard = [[TaskDetailCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250)];
        _taskDetailCard.layer.masksToBounds = NO;
        _taskDetailCard.layer.shadowColor = [UIColor grayColor].CGColor;
        _taskDetailCard.layer.shadowOffset = CGSizeMake(0,10);
        _taskDetailCard.layer.shadowOpacity = 0.7;
        _taskDetailCard.layer.shadowRadius = 10;
    }
    return _taskDetailCard;
}

-(void)popout{
    [self.navigationController popViewControllerAnimated:YES];

}
@end
