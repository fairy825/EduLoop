//
//  BroadcastViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import "BroadcastViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import <PGDatePicker/PGDatePickManager.h>
#import "TaskModel.h"
#import "HomeworkShowViewController.h"
#import "ELBottomSelectOverlay.h"
#import <AFNetworking.h>
#import "BasicInfo.h"
#import "GetAllMyTeamResponse.h"
#import "ELNetworkSessionManager.h"
@interface BroadcastViewController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate,ELBottomSelectOverlayDelegate>

@end

@implementation BroadcastViewController

- (instancetype)initWithHomeworkData:(TeacherTaskModel *)data
{
    self = [super init];
    if (self) {
        _editMode = NO;
        if(data!=nil){
            _task = data;
            _editMode = YES;
        }
        [self getAllMyTeamsNetwork];
        [self loadData:data];
    }
    return self;
}

- (void)loadData:(TeacherTaskModel *)data{
    _chosedTeamIndexs = @[].mutableCopy;
    _models = @[].mutableCopy;
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_InlineTextField;
        model.showArrow = NO;
        model.title =@"任务名称";
        model.detailText = data?data.title:[[NSString alloc] initWithFormat:@"%@%@", [self todayString], @"任务"];
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.accessoryType = SettingTableViewCellType_BigTextField;
        model.title =@"任务内容";
        model.detailText = data?data.content:@"";
        model.detailDefaultText = @"请输入内容";
        model;
    })];
//    [_models addObject:({
//        SettingDataModel *model = [SettingDataModel new];
//        model.showArrow = NO;
//        model.accessoryType = SettingTableViewCellType_Switch;
//        model.title =@"在线提交";
////        model.switchOpen = data.submitOnline;
//        model;
//    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"截止时间";
        self.endDate = data? [self str2Date:data.endTime]
        :
        [self defaultEndTime];
        model.detailText = [self date2Str:self.endDate];
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself pushDatePicker];
        };
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.accessoryType = SettingTableViewCellType_Switch;
        model.title =@"允许补交";
        model.switchOpen = data.delayAllowed;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"班级";
        _overlay = [[ELBottomSelectOverlay alloc]initWithFrame:self.view.bounds Title:model.title];
        _overlay.isSingle = NO;
        _overlay.delegate = self;
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.overlay showHighlightView];
        };
        model;
    })];
}

-(void)ELBottomSelectOverlay:(ELBottomSelectOverlay *)overlay  updateChosedTeams:(int)idx Add:(BOOL)isAdd{
    NSInteger teamId = [_teams objectAtIndex:idx].id;
    NSNumber *number = [NSNumber numberWithInteger:teamId];
    if(isAdd==YES){
        [_chosedTeamIndexs addObject:number];
    }else{
        [_chosedTeamIndexs removeObject:number];
    }
}

-(void)pushDatePicker{
    PGDatePickManager *datePickManager  = [BasicInfo sharedManager];
    datePickManager.style = PGDatePickManagerStyleAlertTopButton;
    datePickManager.isShadeBackground = true;
    PGDatePicker *datePicker = datePickManager.datePicker;
    [datePicker setDate:self.endDate];
    datePicker.showUnit = PGShowUnitTypeNone;
    datePicker.isHiddenMiddleText = false;
    datePicker.delegate = self;
    datePicker.datePickerType = PGDatePickerTypeVertical;
    datePicker.datePickerMode = PGDatePickerModeDateHourMinute;
    [self presentViewController:datePickManager animated:false completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData:nil];
    self.view.backgroundColor = [UIColor f6f6f6];
    [self setNavagationBar];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)setNavagationBar{
    [self setTitle:@"任务"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(publishHomework)];
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor f6f6f6];
    self.tableView.showsVerticalScrollIndicator=NO;
//    self.tableView.scrollEnabled = NfO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.tableView addGestureRecognizer:tapGesture];    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//            make.height.equalTo(@516);
        }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0) return 2;
    else return 3;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @" ";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"settingDataTableViewCell";
    SettingDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger idx = [indexPath section]*2+[indexPath row];
    SettingDataModel *model = self.models[idx];
    if (!cell) {
        cell = [[SettingDataTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
    }
    cell.data = model;
    [cell loadData];
    return cell;
}

#pragma mark - UITableViewDelegate

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
        view.backgroundColor = [UIColor f6f6f6];
        return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
       return 20;
    }
   return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath section]*2+[indexPath row];
    if(self.models[row].accessoryType==SettingTableViewCellType_BigTextField)
        return 216;
    return 56;
}

#pragma mark - network
-(void) getAllMyTeamsNetwork{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    [manager GET:[BasicInfo urlwithDefaultStartAndSize:@"/team"] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            NSString* msg = [responseObject objectForKey:@"msg"];
            if(code==0){
                GetAllMyTeamResponse *response = [[GetAllMyTeamResponse alloc]initWithDictionary:responseObject error:nil];
                NSArray<TeamModel *> *teams = response.data.rows;
                if(teams==nil||teams.count==0){
                    [BasicInfo showToastWithMsg:@"不管理任何班级"];
                }else{
                    self.teams = teams.mutableCopy;
                    NSMutableArray<NSString *> *subs = [[NSMutableArray alloc]init];
                    for(TeamModel *team in self.teams){
                        [subs addObject:team.name];
                    }
                    self.overlay.subTitles = subs;
                    if(self.editMode== YES){
                        NSMutableArray<NSNumber *> *arr = [[NSMutableArray alloc]init];
                        NSArray<TeamModel*> *chosedTeams =  self.task.teamList;
                        for(TeamModel *currentTeam in chosedTeams){
                            int i=0;
                            for(TeamModel *t in self.teams){
                                if(t.id==currentTeam.id){
                                    [arr addObject:[NSNumber numberWithInt:i]];
                                    break;
                                }
                                i++;
                            }
                            [self.chosedTeamIndexs addObject:[NSNumber numberWithInteger:currentTeam.id]];

                        }
                        self.overlay.selectedIdxs = arr;
                    }
                    [self.overlay reload];
                }
                
            }else{
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}

-(void)postTaskNetworkWithSuccess:(nullable void (^)())success{
    NSDictionary *paramDict =  @{
        @"title":[_models objectAtIndex:0].realContent,
        @"content":[_models objectAtIndex:1].realContent ,
        @"delayAllowed":@([_models objectAtIndex:3].switchOpen),
        @"endTime":[self getUtcDate],
        @"teamIds":_chosedTeamIndexs
    };
    [BasicInfo POST:[BasicInfo url:@"/task"] parameters:paramDict success:success];
}


-(void)updateTaskNetworkWithSuccess:(nullable void (^)())success{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    // 设置请求头
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //添加多的请求格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/json", @"text/javascript",@"text/html",nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    
    NSDictionary *paramDict =  @{
        @"title":[_models objectAtIndex:0].realContent,
        @"content":[_models objectAtIndex:1].realContent ,
        @"delayAllowed":@([_models objectAtIndex:3].switchOpen),
        @"endTime":[self getUtcDate],
        @"teamIds":_chosedTeamIndexs
    };
    NSInteger tid = _task.id;
    [BasicInfo PUT:[BasicInfo url:@"/task" path:[NSString stringWithFormat:@"%ld",(long)tid]] parameters:paramDict success:success];
}

#pragma mark - keyboard
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - action
- (void)publishHomework{
    if(_editMode==YES)
        [self updateTaskNetworkWithSuccess:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    else [self postTaskNetworkWithSuccess:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (NSString *)todayString{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM月dd日"];
    NSString *currentDateStr = [dateFormat stringFromDate:[NSDate date]];
    return currentDateStr;
}

-(NSString *)getUtcDate{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    format.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    NSString *utcDateString = [format stringFromDate:self.endDate];
    return utcDateString;
}

-(NSString *)date2Str:(NSDate *)str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *utcDateString = [formatter stringFromDate:str];
    return utcDateString;
}

-(NSDate *)str2Date:(NSString *)str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *resDate = [formatter dateFromString:str];
    return  resDate;
}

- (NSDate *)defaultEndTime{
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:currentDate];
    NSInteger y = [components year]; // year
    NSInteger m = [components month]; // month
    NSInteger d = [components day]; // day
    NSInteger h = [components hour]; // hour
    NSDate *endDate;
    if(h>21){
        endDate = [NSDate setYear:y month:m day:d+1 hour:22 minute:0];
    }else{
        endDate = [NSDate setYear:y month:m day:d hour:22 minute:0];
    }
    return endDate;
}

#pragma mark - PGDatePickerDelegate
- (void)datePicker:(PGDatePicker *)datePicker didSelectDate:(NSDateComponents *)dateComponents {
    NSLog(@"dateComponents = %@", dateComponents);
    self.endDate = [NSDate dateFromComponents: dateComponents];
    [_models objectAtIndex:2].detailText = [self date2Str:[NSDate dateFromComponents:dateComponents]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self dismissKeyboard];
}

@end
