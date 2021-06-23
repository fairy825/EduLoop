//
//  HomeworkShowViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import "HomeworkShowViewController.h"
#import "UIColor+ELColor.h"
#import <Masonry/Masonry.h>
#import "HomeworkShowTableViewCell.h"
#import "ELOverlay.h"
#import "ELCenterOverlay.h"
#import "BroadcastViewController.h"
#import <AFNetworking.h>
#import "BasicInfo.h"
#import "TeacherScanAllTaskResponse.h"
#import <MJRefresh.h>
#import "TeacherTaskSummaryViewController.h"
#import "TeacherShowDetailTaskResponse.h"
#import <LMJDropdownMenu.h>
#import "GetMyStudentsResponse.h"
#import "ParentScanAllTaskResponse.h"
#import "InputTeamCodeViewController.h"
#import "ELNetworkSessionManager.h"
#import "HomeworkPublishViewController.h"
#import "ReviewViewController.h"
#import <SDWebImage.h>
#import "GTListLoader.h"
@interface HomeworkShowViewController ()<UITableViewDelegate,UITableViewDataSource,HomeworkShowTableViewCellDelegate,LMJDropdownMenuDelegate,LMJDropdownMenuDataSource>

@end

@implementation HomeworkShowViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self loadDataNetwork:YES];
//    [self teacherLoadDataIsRefresh:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor elBackgroundColor];
    [self getIdentity];
    _models = @[].mutableCopy;
    _students = @[].mutableCopy;
    self.page=1;
    [self setupSubviews];
}

- (void)loadStudentsAvatar{
    _studentAvatars = @[].mutableCopy;
    for(StudentModel *stu in self.students){
        if(stu.faceImage.length>0){
            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:stu.faceImage]];
            [self.studentAvatars addObject:[[UIImage alloc]initWithData:data]];
        }else [self.studentAvatars addObject:[UIImage imageNamed:@"avatar-4"]];
    }
}

- (void)getIdentity{
    _isParent = [ELUserInfo sharedUser].identity;
}

- (void)loadDataNetwork:(BOOL) isRefresh{
    if(_isParent){
        [self getMyStuNetworkWithSuccess:^{
            [self loadDataIsRefresh:isRefresh];
        }];
    }else{
        [self teacherLoadDataIsRefresh:isRefresh];
    }
}

- (void)endRefresh{
    if (self.page == 1) {
           [self.tableView.mj_header endRefreshing];
    }
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - network
-(void)deleteTaskNetworkWithTaskId:(NSString *)tid success:(nullable void (^)())success{
    [BasicInfo DELETE:[BasicInfo url:@"/task" path:tid] success:success];
}

- (void)getMyStuNetworkWithSuccess:(nullable void (^)())success{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    [manager GET:[BasicInfo urlwithDefaultStartAndSize:@"/student/mine"] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_students removeAllObjects];
        
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            GetMyStudentsResponse *model =[[GetMyStudentsResponse alloc] initWithDictionary:responseObject error: nil];
            
            [_students addObjectsFromArray: model.data];
//            self->_selectedStuIndex = 0;
            [self.menu reloadOptionsData];
            if(success) success();
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}

- (void)loadDataIsRefresh:(BOOL) isRefresh{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    int start = 1;
    int size = BasicInfo.pageSize;
    if(isRefresh==NO){
        start=self.page+1;
    }
    NSDictionary *paramDict =  @{@"start":[NSString stringWithFormat:@"%d", start],@"size":[NSString stringWithFormat:@"%d", size]
    };
    if(_students.count>0){
    [manager GET:[BasicInfo url:@"/task/student" path:[NSString stringWithFormat:@"%ld",_students[_selectedStuIndex].id]] parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(isRefresh){
            self.page=1;
            [_models removeAllObjects];
        }
        [self endRefresh];
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            ParentScanAllTaskResponse *model =[[ParentScanAllTaskResponse alloc] initWithDictionary:responseObject error: nil];
            if(start>model.data.total){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.page=start;
            }
            if(isRefresh){
                [_models removeAllObjects];
            }
            [_models addObjectsFromArray: model.data.rows];
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }
        [self.tableView reloadData];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
    }
}

- (void)teacherLoadDataIsRefresh:(BOOL) isRefresh{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    int start = 1;
    int size = BasicInfo.pageSize;
    if(isRefresh==NO){
        start=self.page+1;
    }
    NSDictionary *paramDict =  @{@"start":[NSString stringWithFormat:@"%d", start],@"size":[NSString stringWithFormat:@"%d", size]
    };
    /*GTListLoader *listLoader = [[GTListLoader alloc] init];
    
    __weak typeof(self)wself = self;
    [listLoader loadListDataWithFinishBlock:^(BOOL success, NSArray<GTListItem *> * _Nonnull dataArray) {
        __strong typeof(wself) strongSelf = wself;
        strongSelf.models = dataArray;
        [strongSelf.tableView reloadData];
    }];*/
    
    [manager GET:[BasicInfo url:@"/task/teacher"] parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(isRefresh){
            self.page=1;
            [_models removeAllObjects];
        }
        [self endRefresh];
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            TeacherScanAllTaskResponse *model =[[TeacherScanAllTaskResponse alloc] initWithDictionary:responseObject error: nil];
            if(start>model.data.total){
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.page=start;
            }
            if(isRefresh){
                [_models removeAllObjects];
            }
            [_models addObjectsFromArray: model.data.rows];
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }
        [self.tableView reloadData];

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}

-(void) teacherShowDetailTaskNetworkWithTaskId:(NSInteger)taskId{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    NSDictionary *paramDict =  @{@"start":[NSString stringWithFormat:@"%d", 1],@"size":[NSString stringWithFormat:@"%d", 10]
    };
    [manager GET:[BasicInfo url:@"/task/teacher" path:[NSString stringWithFormat:@"%ld",(long)taskId]] parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            NSString* msg = [responseObject objectForKey:@"msg"];
            if(code==0){
                TeacherShowDetailTaskResponse *response = [[TeacherShowDetailTaskResponse alloc]initWithDictionary:responseObject error:nil];
                TeacherTaskModel *taskModel = response.data;
                [self.rt_navigationController pushViewController: [[TeacherTaskSummaryViewController alloc]initWithTeacherTaskModel:taskModel] animated:YES];

            }else{
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor elBackgroundColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataNetwork:YES];
//        [self teacherLoadDataIsRefresh:YES];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    //文字颜色
    header.stateLabel.textColor = [UIColor lightGrayColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
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
    //正在刷新
    [header setTitle:@"" forState:MJRefreshStateIdle];
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadDataNetwork:NO];
//        [self teacherLoadDataIsRefresh:NO];
    }];
    footer.stateLabel.font = [UIFont systemFontOfSize:15];
    
    [footer setTitle:@"拼命加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer = footer;

    [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    if(_isParent==NO){
        [self.view addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-100);
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
                make.size.mas_equalTo(CGSizeMake(50, 50));
            }];
    }
}


- (ELFloatingButton *)addBtn{
    if(!_addBtn){
        _addBtn = [[ELFloatingButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50) Image: [UIImage imageNamed:@"icon_add"]];
        _addBtn.delegate = self;
    }
    return _addBtn;
}

- (LMJDropdownMenu *)menu{
    if(!_menu){
        _menu = [[LMJDropdownMenu alloc]initWithFrame:CGRectMake(0, 0, 200, 60)];
        _menu.backgroundColor = [UIColor whiteColor];
        _menu.dataSource = self;
        _menu.delegate = self;
        _menu.title = @"选择要查看的学生";
        _menu.titleColor = [UIColor blackColor];
        _menu.optionIconSize = CGSizeMake(50, 50);
        _menu.rotateIconSize = CGSizeMake(20, 20);
        _menu.rotateIcon = [UIImage imageNamed:@"icon_arrow_down"];
    }
    return _menu;
}

#pragma mark - LMJ
- (void)dropdownMenu:(LMJDropdownMenu *)menu didSelectOptionAtIndex:(NSUInteger)index optionTitle:(NSString *)title{
    if(index==_students.count){
        [self.navigationController pushViewController:[[InputTeamCodeViewController alloc]init] animated:YES];
    }else{
        _selectedStuIndex = index;
        [self loadDataIsRefresh:YES];
    }
}

- (CGFloat)dropdownMenu:(LMJDropdownMenu *)menu heightForOptionAtIndex:(NSUInteger)index{
    return 60;
}

- (UIImage *)dropdownMenu:(LMJDropdownMenu *)menu iconForOptionAtIndex:(NSUInteger)index{
    if(index==_students.count)
        return [UIImage imageNamed:@"icon_add_small-1"];
    /**UIImage *image;
    NSString *avatar = _students[index].faceImage;
    if(avatar.length==0)
        image = [UIImage imageNamed:@"avatar-4"];
    else{
        UIImageView *imgView = [[UIImageView alloc]init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:avatar]];
        image = imgView.image;
    }*/
    return nil;
}
- (NSString *)dropdownMenu:(LMJDropdownMenu *)menu titleForOptionAtIndex:(NSUInteger)index{
    if(index==_students.count)
        return @"加入班级";
    return _students[index].name;
}
- (NSUInteger)numberOfOptionsInDropdownMenu:(LMJDropdownMenu *)menu{
    return _students.count+1;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"HomeworkShowTableViewCell";
    HomeworkShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger idx = [indexPath row];
    JSONModel *model = nil;
    if(_isParent)
        model = (TaskModel *)self.models[idx];
    else
        model = (TeacherTaskModel *)self.models[idx];
    if (!cell) {
        cell = [[HomeworkShowTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.data = model;
    cell.delegate = self;
    [cell loadData];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_isParent)
        return 80;
    else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_isParent){
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,80)];
            
        UIView *bgView = [[UIView alloc]init];
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
//        UIView *seperateLine = [[UIView alloc]init];
//        [header addSubview:seperateLine];
//        [bgView mas_makeConstraints:^(MASConstraintMaker *make){
//            make.bottom.equalTo(bgView);
//            make.left.equalTo(bgView);
//            make.right.equalTo(bgView);
//            make.height.equalTo(@2);
//        }];
        [header addSubview:self.menu];
        [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(header).offset(10);
            make.left.equalTo(header).offset(20);
            make.height.equalTo(@60);
            make.width.equalTo(@200);
        }];
        [header layoutIfNeeded];
        return header;
    }else return nil;
}
#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 216;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    [self jumpToDetailPageWithData:_models[row]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_isParent)
        return NO;
    return YES;
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
        NSInteger index = [indexPath row];
        TaskModel *task = [self.models objectAtIndex:index];
        [self deleteTaskNetworkWithTaskId:[NSString stringWithFormat:@"%ld",(long)task.id] success:^{
            [self.models removeObjectAtIndex:index];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        }];
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了编辑");
        NSInteger index = [indexPath row];
        [self.navigationController pushViewController:[[BroadcastViewController alloc]initWithHomeworkData:[self.models objectAtIndex:index]] animated:YES];
    }];
    editAction.backgroundColor = [UIColor themeBlue];
    return @[deleteAction, editAction];
}
 
#pragma mark - ELFloatingButtonDelegate
- (void)clickFloatingButton{
    [self.navigationController pushViewController:[[BroadcastViewController alloc]initWithHomeworkData:nil] animated:YES];
//    [self jumpToDetailPageWithData:nil];
}

#pragma mark - action
- (void)jumpToDetailPageWithData:(id)data{
    if(_isParent){
        TaskModel *model = (TaskModel *)data;
        [self.navigationController pushViewController:[[ReviewViewController alloc]initWithHomeworkModel:model.homeworkVO TaskModel:(TaskModel *)data Student:self.students[self.selectedStuIndex]] animated:YES];
    }
    else{
        TeacherTaskModel *model = (TeacherTaskModel *)data;
        [self teacherShowDetailTaskNetworkWithTaskId:model.id];
    }
}

#pragma mark - HomeworkShowTableViewCellDelegate
- (void)clickSubmitButtonTableViewCell:(UITableView *)tableViewCell{
    HomeworkShowTableViewCell *cell = (HomeworkShowTableViewCell *)tableViewCell;
    TaskModel *model =(TaskModel *)cell.data;
    [self.navigationController pushViewController:[[HomeworkPublishViewController alloc]initWithTaskId:model.id Student:self.students[self.selectedStuIndex]] animated:YES];
}
//- (void)clickOtherButtonTableViewCell:(UITableViewCell *)tableViewCell {
//    HomeworkShowTableViewCell *cell = (HomeworkShowTableViewCell *)tableViewCell;
//    ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:self.view.bounds Data:@[
//        ({
//        ELOverlayItem *item = [ELOverlayItem new];
//        item.title = @"编辑";
//        item.clickBlock = ^{
//            [self jumpToDetailPageWithData:cell.data];
//        };
//        item;
//    }),
//        ({
//        ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
//        centerOverlayModel.title = @"确认删除此作业吗？";
//        centerOverlayModel.subTitle = @"删除后不可恢复";
//        centerOverlayModel.leftChoice = ({
//            ELOverlayItem *sureItem =[ELOverlayItem new];
//            sureItem.title = @"确认";
//            __weak typeof(self) wself = self;
//            sureItem.clickBlock = ^{
//                __strong typeof(self) sself = wself;
//                NSIndexPath *index = [sself.tableView indexPathForCell:tableViewCell];
//                [sself.models removeObjectAtIndex:[index row]];
//                [sself.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
//            };
//            sureItem;
//        });
//        ELOverlayItem *item = [ELOverlayItem new];
//        item.title = @"删除";
//        item.clickBlock = ^{
//            ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
//            ];
//            
//            [deleteAlertView showHighlightView];
//        };
//        item;
//        
//    })]];
//    [overlay showHighlightView];
//}
@end
