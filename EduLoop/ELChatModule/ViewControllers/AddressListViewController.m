//
//  AddressListViewController.m
//  EduLoop
//
//  Created by mijika on 2021/1/5.
//

#import "AddressListViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "ELCenterOverlayModel.h"
#import "ELCenterOverlay.h"
#import "ChatDetailViewController.h"
#import "AddressListTableViewCell.h"
#import "ELNetworkSessionManager.h"
#import "BasicInfo.h"
#import <MJRefresh.h>
#import "GetContactsResponse.h"
@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddressListViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
    [self setNavagationBar];
    [self setupSubviews];
    [self loadData];
}

- (void)setNavagationBar{
    [self setTitle:@"通讯录"];
}

- (void)loadData{
    self.dataSource = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    
    dispatch_group_t group = dispatch_group_create();
        
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [self getContactsNetworkWithSuccess:^{
            for (int i = 0; i< self.contacts.count; i++) {
                NSMutableString *mutableString = [[NSMutableString stringWithString:self.contacts[i].nickname] mutableCopy];
                CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
                CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
                self.contacts[i].symbol = mutableString;
            }
            //NSSortDescriptor 指定用于对象数组排序的对象的属性
            NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES]];
            //对person进行排序
            [self.contacts sortUsingDescriptors:sortDescriptors];

            for (int i = 0; i < self.contacts.count; i++) {
                ContactPersonModel *model = self.contacts[i];
                NSString *str = [model.symbol substringToIndex:1] ;
                if (![self.titleArray containsObject:str]) {
                    [self.titleArray addObject:str];
                }
            }

            for (int i = 0; i< self.titleArray.count; i++) {
                NSString *str = self.titleArray[i];
                NSMutableArray *sortArray = [NSMutableArray array];
                BOOL flag = NO;
                for (ContactPersonModel *model in self.contacts) {
                    BOOL hasPre = [model.symbol hasPrefix:str];
                    if(hasPre){
                        [sortArray addObject:model];
                        flag = YES;
                    }
                    else if (!hasPre&&flag) {
                        break;
                    }
                }
                [self.dataSource addObject:sortArray];
            }
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);

        }];
        [self reloadDefaultView];
        [self.tableView reloadData];
    });
}

- (void)reloadDefaultView{
    if(self.dataSource.count==0){
        self.defaultView.alpha=1;
    }else{
        self.defaultView.alpha=0;
    }
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor f6f6f6];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionIndexColor = [UIColor color999999];
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
       
    }];
    [self.view addSubview:self.defaultView];
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50, 80));
    }];
}

- (UIView *)defaultView{
    if(!_defaultView){
        _defaultView = [UIView new];
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:@"icon_empty"];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.clipsToBounds = YES;
        UILabel *label = [UILabel new];
        label.font = [UIFont fontWithName:@"PingFangSC" size:18.f];
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"还没有联系人哦";
        [label sizeToFit];
        [_defaultView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_defaultView);
            make.centerX.equalTo(_defaultView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        [_defaultView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(10);
            make.centerX.equalTo(imgView);
        }];
    }
    return _defaultView;
}
//
//- (ELSearchBar *)searchBar{
//    if(!_searchBar){
//        _searchBar = [[ELSearchBar alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-10*2,60)];
//        _searchBar.textField.returnKeyType = UIReturnKeySearch;
//    }
//    return _searchBar;
//}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger c =  self.dataSource[section].count;
    return c;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactPersonModel *data = self.dataSource[indexPath.section][indexPath.row];
    NSString *id =@"AddressListTableViewCell";
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[AddressListTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:data];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.data = data;
    [cell loadData];
    return cell;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *arr = [NSMutableArray array];
    for(int i=0;i<self.titleArray.count;i++){
        arr[i] = [self.titleArray[i] uppercaseString];
    }
    return arr;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 70;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 60, 20)];
    label.text = [self.titleArray[section] uppercaseString];
    label.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
    label.textAlignment = NSTextAlignmentLeft;
    [view addSubview:label];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactPersonModel *data = self.dataSource[indexPath.section][indexPath.row];
    [self pushToDetailPageWithData:data];
}

- (void)pushToDetailPageWithData:(ContactPersonModel *)data{
    [self.navigationController pushViewController:[[ChatDetailViewController alloc]initWithModel:data] animated:YES];
}

- (ContactPersonModel *)fromProfileModel:(ProfileModel *)profile{
    ContactPersonModel *contacts = [ContactPersonModel new];
    contacts.id = [NSNumber numberWithInteger:profile.id];
    contacts.name =  profile.name;
    contacts.nickname = profile.nickname;
    contacts.identity = [NSNumber numberWithInteger:profile.identity];
    contacts.avatar = profile.faceImage;
    return contacts;
}

#pragma mark - network
- (void)getContactsNetworkWithSuccess:(nullable void (^)())success{
    AFHTTPSessionManager *manager = [ELNetworkSessionManager sharedManager];
    [manager GET: [BasicInfo url:@"/addressBook/"] parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@---%@",[responseObject class],responseObject);
        int code = [[responseObject objectForKey:@"code"]intValue];
        NSString* msg = [responseObject objectForKey:@"msg"];
        if(code==0){
            GetContactsResponse *model =[[GetContactsResponse alloc] initWithDictionary:responseObject error: nil];
            NSArray<ProfileModel *> *profiles = model.data;

            NSMutableArray<ContactPersonModel *>*contacts = [[NSMutableArray alloc]init];
            for(ProfileModel *pro in profiles){
                [contacts addObject:({
                    [self fromProfileModel:pro];
                })];
            }
            self.contacts = contacts;
            if(success!=nil) success();
            NSString *key = [NSString stringWithFormat:@"%@%ld",@"contacts-",[ELUserInfo sharedUser].id];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSData *jsonData = [NSKeyedArchiver archivedDataWithRootObject:[contacts mutableCopy]];
            [userDefaults setObject:jsonData forKey:key];
            [userDefaults synchronize];
        }else{
            NSLog(@"error--%@",msg);
            [BasicInfo showToastWithMsg:msg];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求失败--%@",error);
        }];
}

@end
