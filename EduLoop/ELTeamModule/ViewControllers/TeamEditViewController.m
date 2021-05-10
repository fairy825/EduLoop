//
//  TeamEditViewController.m
//  EduLoop
//
//  Created by mijika on 2021/4/24.
//

#import "TeamEditViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import <AFNetworking.h>
#import "BasicInfo.h"
#import "ELOverlay.h"
#import <TZImagePickerController.h>
#import "ELNetworkSessionManager.h"
@interface TeamEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TeamEditViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (instancetype)initWithData:(TeamModel *)team
{
    self = [super init];
    if (self) {
        _editMode = NO;
        if(team!=nil){
            _editMode = YES;
            _team = team;
        }
        [self loadData:team];
    }
    return self;
}

- (void)loadData:(TeamModel *)data{
    _models = @[].mutableCopy;
   
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_InlineTextField;
        model.showArrow = NO;
        model.title =@"班级名称";
        model.detailText = data?data.name:@"";
        model;
    })];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData:nil];
    self.view.backgroundColor = [UIColor f6f6f6];
    [self setNavagationBar];
    [self setupSubviews];
}

- (void)setNavagationBar{
    [self setTitle:@"班级信息"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishPublish)];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"settingDataTableViewCell";
    SettingDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger idx = [indexPath row];
    SettingDataModel *model = self.models[idx];
    if (!cell) {
        cell = [[SettingDataTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.data = model;
    [cell loadData];
    return cell;
}

#pragma mark - network
-(void)postTeamNetworkWithSuccess:(nullable void (^)())success{
    NSDictionary *params = @{
        @"name":[_models objectAtIndex:0].realContent
    };
    [BasicInfo POST: [BasicInfo url:@"/team/teacher"] parameters:params success:success];
}

-(void)updateStudentNetworkWithSuccess:(nullable void (^)())success{
    NSMutableDictionary *paramDict =  [self.team toDictionary].mutableCopy;
    [paramDict setObject:_models[0].realContent forKey:@"name"];
    
    [BasicInfo PUT:[BasicInfo url:@"/team/teacher"] parameters:paramDict success:success];
}

#pragma mark - keyboard
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

#pragma mark - action
- (BOOL)canFinish{
    NSString *str;
    if(_models[0].realContent.length==0){
        str = @"未填写班级名称";
    }else{
       return YES;
   }
    [BasicInfo showToastWithMsg:str];
    return NO;
}

- (void)finishPublish{
    if([self canFinish]){
        if(_editMode==YES){
            [self updateStudentNetworkWithSuccess:^{
                [BasicInfo showToastWithMsg:@"更新班级信息成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [self postTeamNetworkWithSuccess:^{
                [BasicInfo showToastWithMsg:@"创建班级信息成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

@end


