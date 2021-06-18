//
//  ChildProfileViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import "ChildProfileViewController.h"
#import "UIColor+ELColor.h"
#import <Masonry/Masonry.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import "BasicInfo.h"
#import "ChildProfileEditViewController.h"
#import "InputTeamCodeViewController.h"
#import "ELCenterOverlay.h"
#import "ELNetworkSessionManager.h"
#import "GetMyStudentsResponse.h"
#import "ScanQRCodeViewController.h"
@interface ChildProfileViewController ()<UITableViewDelegate,UITableViewDataSource,ELFloatingButtonDelegate,ChildProfileCardDelegate>

@end

@implementation ChildProfileViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self getMyStuNetwork];
}

- (NSArray<NSString *> *)grades{
    return @[@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级",
       @"初一",@"初二",@"初三",@"高一",@"高二",@"高三"];
}

- (ChildModel *)fromStudentModel:(StudentModel *)stu{
    ChildModel *child = [ChildModel new];
    child.id = stu.id;
    child.nickname = stu.name;
    child.sno = stu.sno;
    child.avatarUrl = stu.faceImage;
    child.relationship = stu.relationship;
    child.sex = stu.sex?@"男":@"女";
    child.grade = [[self grades] objectAtIndex:stu.grade];
    child.team = stu.teamName;
    child.teamId = [stu.teamId integerValue];
    child.qrcode = stu.qrcode;
    return child;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page=1;
    [self loadData];
    [self setTitle:@"孩子档案"];
    self.view.backgroundColor = [UIColor elBackgroundColor];
    self.profileTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.profileTableView.delegate = self;
    self.profileTableView.dataSource = self;
    self.profileTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.profileTableView.backgroundColor = [UIColor elBackgroundColor];
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
}

- (void)getMyStuNetwork{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];

    [manager GET:[BasicInfo urlwithDefaultStartAndSize:@"/student/mine"] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            GetMyStudentsResponse *model =[[GetMyStudentsResponse alloc] initWithDictionary:responseObject error: nil];
            NSArray<StudentModel *> *students = model.data;
            NSMutableArray<ChildModel *>*children = [[NSMutableArray alloc]init];
            for(StudentModel *stu in students){
                [children addObject:({
                    [self fromStudentModel:stu];
                })];
            }
            self.models = children;
            [self.profileTableView reloadData];
            
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"ChildProfileCard";
    ChildProfileCard *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger row = [indexPath row];
    ChildModel *model = self.models[row];
    if (!cell) {
        cell = [[ChildProfileCard alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
        cell.tag = 10+row;
        UIGestureRecognizer *recog = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(pushUnbindWindow:)];
        [cell addGestureRecognizer:recog];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    [cell reload:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    ChildModel *child = [_models objectAtIndex:row];
    [self.navigationController pushViewController:[[ChildProfileEditViewController alloc]initWithData:child] animated:YES];

    
}

- (void)ChildProfileCardJumpToInputCode:(ChildProfileCard *)card{
    [self.navigationController pushViewController:[[InputTeamCodeViewController alloc]initWithStudent:card.model.id] animated:YES];
}

- (void)pushUnbindWindow:(UILongPressGestureRecognizer *)recog {
    if(recog.state == UIGestureRecognizerStateBegan){
        ChildProfileCard *card = (ChildProfileCard *)recog.view;
        ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
        centerOverlayModel.title = [NSString stringWithFormat:@"%@%@%@", @"确认与孩子",card.model.nickname,@"解绑？" ];
        centerOverlayModel.leftChoice = ({
            ELOverlayItem *sureItem =[ELOverlayItem new];
            sureItem.title = @"确认";
            __weak typeof(self) wself = self;
            sureItem.clickBlock = ^{
                __strong typeof(self) sself = wself;
                [sself unbindChildNetwork:card];

            };
            sureItem;
        });
        ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
        ];
        
        [deleteAlertView showHighlightView];
    }
}

- (void)unbindChildNetwork:(ChildProfileCard *)card{
    NSInteger studentId = card.model.id;
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    [manager GET:[BasicInfo url:@"/student/unbind/" path:[NSString stringWithFormat:@"%ld", studentId]] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            NSString* msg = [responseObject objectForKey:@"msg"];
            if(code==0){
                NSIndexPath *index = [self.profileTableView indexPathForCell:card];
                [self.models removeObjectAtIndex:[index row]];
                [self.profileTableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}
#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90+56*7+40;
}

- (ELFloatingButton *)addBtn{
    if(!_addBtn){
        _addBtn = [[ELFloatingButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50) Image: [UIImage imageNamed:@"icon_add"]];
        _addBtn.delegate = self;
    }
    return _addBtn;
}

#pragma mark - ELFloatingButtonDelegate
- (void)clickFloatingButton{
    __weak typeof(self) wself = self;
    ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:self.view.bounds Data:@[({
        ELOverlayItem *item = [ELOverlayItem new];
        item.title =@"创建学生";
        item.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [self.navigationController pushViewController:[[ChildProfileEditViewController alloc]initWithData:nil] animated:YES];
        };
        item;
    }),({
        ELOverlayItem *item = [ELOverlayItem new];
        item.title =@"绑定学生";
        item.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.navigationController pushViewController:[[ScanQRCodeViewController alloc]init] animated:YES];
        };
        item;
    })]];
    [overlay showHighlightView];
    
}
@end
