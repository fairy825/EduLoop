//
//  ChildProfileEditViewController.m
//  EduLoop
//
//  Created by mijika on 2021/4/16.
//

#import "ChildProfileEditViewController.h"
#import "BroadcastViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import <AFNetworking.h>
#import "BasicInfo.h"
#import "ELOverlay.h"
#import <TZImagePickerController.h>
#import "ELNetworkSessionManager.h"
@interface ChildProfileEditViewController ()<UITableViewDelegate,UITableViewDataSource,ELOverlayDelegate,ELBottomSelectOverlayDelegate>

@end

@implementation ChildProfileEditViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (instancetype)initWithData:(ChildModel *)data
{
    self = [super init];
    if (self) {
        _editMode = NO;
        _gradeIndex = -1;
        _relationshipIndex = -1;
        if(data!=nil){
            _editMode = YES;
            _child = data;
            _relationshipIndex = [[self array]indexOfObject: _child.relationship];
            _gradeIndex = [[self grades]indexOfObject: _child.grade];
        }
        [self loadData:data];
    }
    return self;
}

- (instancetype)initWithTeamCode:(NSString *)teamCode{
    self = [super init];
    if (self) {
        _editMode = NO;
        _gradeIndex = -1;
        _relationshipIndex = -1;
        _teamCode = teamCode;
        [self loadData:nil];
    }
    return self;
}

- (void)loadData:(ChildModel *)data{
    _models = @[].mutableCopy;
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Image;
        model.title =@"孩子头像";
        model.defaultAvatarImage = [UIImage imageNamed:@"avatar-4"];
        model.avatarImageUrl = data?data.avatarUrl:@"";
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself selectImage];
        };model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_InlineTextField;
        model.showArrow = NO;
        model.title =@"孩子昵称";
        model.detailText = data?data.nickname:@"";
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_InlineTextField;
        model.showArrow = NO;
        model.title =@"孩子学号";
//        model.detailText = data?data.sno:@"";
        model.detailText = @"1";
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"孩子年级";
        model.detailText = data?data.grade:@"请选择";
        _overlay1 = [[ELBottomSelectOverlay alloc]initWithFrame:self.view.bounds Title:@"年级"];
        _overlay1.subTitles = [self grades];
        _overlay1.delegate = self;
        _overlay1.selectedIdxs = @[[NSNumber numberWithInteger:_gradeIndex]];
        [_overlay1 reload];
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.overlay1 showHighlightView];
        };
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"孩子性别";
        model.detailText = data?data.sex:@"男";
        model.clickBlock = ^{
            ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:self.view.bounds Data:@[({
                ELOverlayItem *item = [ELOverlayItem new];
                item.title =@"男";
                item;
            }),({
                ELOverlayItem *item = [ELOverlayItem new];
                item.title =@"女";
                item;
            })]];
            overlay.delegate = self;
            [overlay showHighlightView];
        };
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Text;
        model.showArrow = YES;
        model.title =@"关系";
        model.detailText = data?data.relationship:@"请选择";
        _overlay = [[ELBottomSelectOverlay alloc]initWithFrame:self.view.bounds Title:@"关系"];
        _overlay.subTitles = [self array];
        _overlay.delegate = self;
        _overlay.selectedIdxs = @[[NSNumber numberWithInteger:_relationshipIndex]];
        [_overlay reload];
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            [sself.overlay showHighlightView];
        };
        model;
    })];
}
- (NSArray <NSString *>*)array{
    return  @[@"爸爸",@"妈妈",@"爷爷",@"奶奶",@"外公",@"外婆",@"阿姨",@"叔叔",@"其他"];
}

- (NSArray<NSString *> *)grades{
    return @[@"一年级",@"二年级",@"三年级",@"四年级",@"五年级",@"六年级",
       @"初一",@"初二",@"初三",@"高一",@"高二",@"高三"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData:nil];
    self.view.backgroundColor = [UIColor f6f6f6];
    [self setNavagationBar];
    [self setupSubviews];
}

- (void)setNavagationBar{
    [self setTitle:@"孩子档案"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishPublish)];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self dismissKeyboard];
}
- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor f6f6f6];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.scrollEnabled = YES;
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


- (void)selectImage{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.preferredLanguage = @"zh-Hans";
    imagePickerVc.allowPickingOriginalPhoto = NO;
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        self.avatarImage = photos[0];
        self.models[0].avatarImageUrl = @"";
        self.models[0].defaultAvatarImage = self.avatarImage;
        [self.tableView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)uploadStudentAvatarNetworkWithWithStuId:(NSInteger) stuId Success:(nullable void (^)())success{
    if(self.avatarImage==nil){
        if(success!=nil) success();
        return;
    }
    
    NSData *data = UIImagePNGRepresentation(self.avatarImage);
    NSString * base64 = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    int studentId = self.child?self.child.id:stuId;
    NSDictionary *paramDict =  @{
        @"studentId":[NSNumber numberWithInteger: studentId],
        @"faceData":base64
    };
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager POST:[BasicInfo url:@"/student/uploadFaceBase64"] parameters:paramDict headers:nil  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        if(code!=0){
            NSString* msg = [responseObject objectForKey:@"msg"];
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }else{
            NSString* url = [responseObject objectForKey:@"data"];
            self.models[0].avatarImageUrl = url;
            [self.tableView reloadData];
            if(success!=nil) success();
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if(self.models[row].accessoryType==SettingTableViewCellType_Image)
        return 90;
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
-(void)postStudentNetworkWithSuccess:(nullable void (^)())success{
    
    NSDictionary *paramDict =  @{
        @"sno":[_models objectAtIndex:2].realContent,
        @"name":[_models objectAtIndex:1].realContent,
        @"grade":[NSNumber numberWithInteger: _gradeIndex],
        @"sex":[NSNumber numberWithBool:[[_models objectAtIndex:4].realContent isEqual:@"男"]],
        @"relationship":[[self array] objectAtIndex:_relationshipIndex]
    };
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:[BasicInfo url:@"/student"] parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            if(code!=0){
                NSString* msg = [responseObject objectForKey:@"msg"];
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
            }else{
                
                int stuId = [[responseObject objectForKey:@"data"]intValue];
                [self uploadStudentAvatarNetworkWithWithStuId:stuId Success:success];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}


-(void)updateStudentNetworkWithSuccess:(nullable void (^)())success{
    NSDictionary *paramDict =  @{
        @"id":[NSNumber numberWithInteger: _child.id],
        @"sno":[_models objectAtIndex:2].realContent,
        @"name":[_models objectAtIndex:1].realContent ,
        @"grade":[NSNumber numberWithInteger: _gradeIndex],
        @"sex":[NSNumber numberWithBool:[[_models objectAtIndex:4].realContent isEqual:@"男"]],
        @"relationship":[[self array] objectAtIndex:_relationshipIndex],
    };
    [BasicInfo PUT:[BasicInfo url:@"/student"] parameters:paramDict success:success];
}

- (void)createStudentJoinTeamNetworkWithCode:(NSString *)code Success:(nullable void (^)())success{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    NSDictionary *paramDict =  @{
        @"sno":[_models objectAtIndex:2].realContent,
        @"name":[_models objectAtIndex:1].realContent ,
        @"grade":[NSNumber numberWithInteger: _gradeIndex],
        @"sex":[NSNumber numberWithBool:[[_models objectAtIndex:4].realContent isEqual:@"男"]],
        @"relationship":[[self array] objectAtIndex:_relationshipIndex],
    };
    [manager POST:[NSString stringWithFormat:@"%@%@%@",
                  [BasicInfo url:@"/team/"],
                  code,
                  @"/join/create"]
      parameters:paramDict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
            NSLog(@"%@---%@",[responseObject class],responseObject);
            int code = [[responseObject objectForKey:@"code"]intValue];
            NSString* msg = [responseObject objectForKey:@"msg"];
            if(code==0){
                int stuId = [[responseObject objectForKey:@"data"]intValue];
                [self uploadStudentAvatarNetworkWithWithStuId:stuId Success:nil];
                success();
            }else{
                NSLog(@"error--%@",msg);
                [BasicInfo showToastWithMsg:msg];
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
- (BOOL)canFinish{
    NSString *str;
    if(_models[1].realContent.length==0){
        str = @"未填写孩子昵称";
    }
    else if(_gradeIndex==-1){
       str =@"未选择年级";
    }else if(_relationshipIndex==-1){
       str =@"未选择与孩子之间的关系";
    }else{
       return YES;
   }
    [BasicInfo showToastWithMsg:str];
    return NO;
}

- (void)finishPublish{
    if([self canFinish]){
        if(_editMode==YES)
            [self updateStudentNetworkWithSuccess:^{
                [self uploadStudentAvatarNetworkWithWithStuId:0 Success:^{
                    [BasicInfo showToastWithMsg:@"更新学生信息成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }];
        else if(self.teamCode.length==0){
            [self postStudentNetworkWithSuccess:^{
                [BasicInfo showToastWithMsg:@"创建学生成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [self createStudentJoinTeamNetworkWithCode:self.teamCode Success:^{
                
                [BasicInfo showToastWithMsg:@"成功加入"];
                NSArray <UIViewController *>*vcs =self.navigationController.viewControllers;
                [self.navigationController popToViewController:[vcs objectAtIndex:vcs.count-3] animated:YES];
            }];
        }
    }
}

#pragma mark - ELOverlayDelegate
- (void) getChosenTitle:(NSString *)title{
    [_models objectAtIndex:4].detailText = title;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - ELBottomSelectOverlayDelegate
-(void)ELBottomSelectOverlay:(ELBottomSelectOverlay*)overlay singleUpdateChosedTeams:(int)idx Add:(BOOL)isAdd{
    NSInteger item;
    NSString *str;
    NSInteger k;
    
    if([overlay.title isEqual:@"关系"]){
        if(isAdd){
            k = idx;
            str = [[self array] objectAtIndex:idx];
        }else{
            k = -1;
            str = @"";
        }
        item=5;
        _relationshipIndex = k;
        
    }else{
        if(isAdd){
            k = idx;
            str = [[self grades] objectAtIndex:idx];
        }else{
            k = -1;
            str = @"";
        }
        item=3;
        _gradeIndex = k;
    }
    [_models objectAtIndex:item].detailText = str;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:item inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
@end


