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
#import "ELBottomStackOverlay.h"
#import <AFNetworking.h>
#import "BasicInfo.h"
@interface BroadcastViewController ()<UITableViewDelegate,UITableViewDataSource,PGDatePickerDelegate>

@end

@implementation BroadcastViewController

- (instancetype)initWithHomeworkData:(TaskModel *)data
{
    self = [super init];
    if (self) {
        _editMode = NO;
        if(data!=nil){
            _task = data;
            _editMode = YES;
        }
        [self loadData:data];
    }
    return self;
}

- (void)loadData:(TaskModel *)data{
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
//    [_models addObject:({
//        SettingDataModel *model = [SettingDataModel new];
//        model.title =@"班级";
//        model.clickBlock=^{
//            NSDictionary *dic = @{ @"key1":@[@"one",@"1"], @"key2":@[@"two"]};
//            NSArray *array = @[@"key1",@"key2"];
//            ELBottomStackOverlay *overlay = [[ELBottomStackOverlay alloc]initWithFrame:self.view.bounds Data:dic SubTitles:array];
//            [overlay showHighlightView];
//        };
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

- (void)setNavagationBar{
    [self setTitle:@"任务"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(publishHomework)];
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor f6f6f6];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.scrollEnabled = NO;
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
    else return 2;
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
-(void)postTaskNetworkWithSuccess:(nullable void (^)())success{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
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
        @"teamIds":@[@1,@2]
    };
    [manager POST:[BasicInfo url:@"/task"] parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        
        if(code!=0){
            NSString* msg = [responseObject objectForKey:@"msg"];
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }else{
            success();
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}


-(void)updateTaskNetworkWithSuccess:(nullable void (^)())success{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
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
        @"teamIds":@[@1,@2]
    };
    int tid = _task.id;
    [manager PUT:[BasicInfo url:@"/task" path:[NSString stringWithFormat:@"%d",tid]] parameters:paramDict headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        
        if(code!=0){
            NSString* msg = [responseObject objectForKey:@"msg"];
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }else{
            success();
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
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
    self.endDate = dateComponents;
    [_models objectAtIndex:3].detailText = [self date2Str:[NSDate dateFromComponents:dateComponents]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

@end
