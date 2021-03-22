//
//  HomeworkShowViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import "HomeworkShowViewController.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "HomeworkShowTableViewCell.h"
#import "ELOverlay.h"
#import "ELCenterOverlay.h"
#import "BroadcastViewController.h"
#import <AFNetworking.h>
#import "BasicInfo.h"
#import "ELResponse.h"
#import <MJRefresh.h>
@interface HomeworkShowViewController ()<UITableViewDelegate,UITableViewDataSource,HomeworkShowTableViewCellDelegate>

@end

@implementation HomeworkShowViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
    _models = @[].mutableCopy;
    self.page=1;
    [self setupSubviews];
    [self loadDataIsRefresh:YES];
}

- (void)endRefresh{
    if (self.page == 1) {
           [self.tableView.mj_header endRefreshing];
    }
    [self.tableView.mj_footer endRefreshing];
}

- (void)loadDataIsRefresh:(BOOL) isRefresh{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    int start = 1;
    int size = BasicInfo.pageSize;
    if(isRefresh==NO){
        start=self.page+1;
    }
    [manager GET: [BasicInfo url:@"/task/student/1" Start:start AndSize:size] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(isRefresh){
            self.page=1;
            [_models removeAllObjects];
        }
        [self endRefresh];
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            ELResponse *model =[[ELResponse alloc] initWithDictionary:responseObject error: nil];
            if(start>model.data.total){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.page=start;
            }
            if(isRefresh){
                [_models removeAllObjects];
            }
            [_models addObjectsFromArray: model.data.rows];
//            NSDictionary *data = [responseObject objectForKey:@"data"];
//            NSError *error;
//            PagedResult *pg = [[PagedResult alloc] initWithDictionary:data error:&error];
//            self->_models=pg.rows;
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }
        [self.tableView reloadData];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
//    [_models addObject:({
//        TaskModel *model = [HomeworkModel new];
//        model.title = @"12月14日作业";
//        model.detail =@"test1";
//        model.allowSubmitAfter = NO;
//        model.submitOnline = YES;
//        model;
//    })];
//    [_models addObject:({
//        TaskModel *model = [HomeworkModel new];
//        model.title = @"12月15日作业";
//        model.detail =@"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
//        model;
//    })];
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor f6f6f6];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataIsRefresh:YES];
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
        [self loadDataIsRefresh:NO];
    }];
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    //正在刷新
    [header setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"拼命加载中..." forState:MJRefreshStateRefreshing];    self.tableView.mj_header = header;
    [footer setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
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
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"HomeworkShowTableViewCell";
    HomeworkShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger idx = [indexPath row];
    TaskModel *model = self.models[idx];
    
    if (!cell) {
        cell = [[HomeworkShowTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
    }
    cell.data = model;
    cell.delegate = self;
    [cell loadData];
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 216;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    [self jumpToDetailPageWithData:_models[row]];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 50;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView* sh_footerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width,50.0)];
//
//    UILabel* sh_label = [[UILabel alloc ]init];
//    sh_label.text =@"----没有更多记录了----";
//    sh_label.textColor = [UIColor lightGrayColor];
//    sh_label.font = [UIFont systemFontOfSize:16];
//    sh_label.textAlignment =NSTextAlignmentCenter;
//    [sh_label sizeToFit];
//    [sh_footerView addSubview:sh_label];
//    sh_label.center =sh_footerView.center;
//
//    return sh_footerView;
//}

#pragma mark - ELFloatingButtonDelegate
- (void)clickFloatingButton{
    [self jumpToDetailPageWithData:nil];
}

#pragma mark - action
- (void)jumpToDetailPageWithData:(TaskModel *)model{
    [self.navigationController pushViewController:[[BroadcastViewController alloc]initWithHomeworkData:model] animated:YES];
}

#pragma mark - HomeworkShowTableViewCellDelegate
- (void)clickOtherButtonTableViewCell:(UITableViewCell *)tableViewCell {
    HomeworkShowTableViewCell *cell = (HomeworkShowTableViewCell *)tableViewCell;
    ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:self.view.bounds Data:@[
        ({
        ELOverlayItem *item = [ELOverlayItem new];
        item.title = @"编辑";
        item.clickBlock = ^{
            [self jumpToDetailPageWithData:cell.data];
        };
        item;
    }),
        ({
        ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
        centerOverlayModel.title = @"确认删除此作业吗？";
        centerOverlayModel.subTitle = @"删除后不可恢复";
        centerOverlayModel.leftChoice = ({
            ELOverlayItem *sureItem =[ELOverlayItem new];
            sureItem.title = @"确认";
            __weak typeof(self) wself = self;
            sureItem.clickBlock = ^{
                __strong typeof(self) sself = wself;
                NSIndexPath *index = [sself.tableView indexPathForCell:tableViewCell];
                [sself.models removeObjectAtIndex:[index row]];
                [sself.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            sureItem;
        });
        ELOverlayItem *item = [ELOverlayItem new];
        item.title = @"删除";
        item.clickBlock = ^{
            ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
            ];
            
            [deleteAlertView showHighlightView];
        };
        item;
        
    })]];
    [overlay showHighlightView];
}
@end
