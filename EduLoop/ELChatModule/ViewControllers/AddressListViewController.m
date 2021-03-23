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
@interface AddressListViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AddressListViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor f6f6f6];
    [self setNavagationBar];
    [self loadData];
    [self setupSubviews];
}

- (void)setNavagationBar{
    [self setTitle:@"通讯录"];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_add_small"] style:UIBarButtonItemStylePlain target:self action:@selector(addContact)];
}

- (void)loadData{
    self.dataSource = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];

    NSArray<ContactPersonModel *> *arr = [[NSArray alloc] initWithObjects:
                                          ({
        ContactPersonModel *model = [[ContactPersonModel alloc] init];
        model.name = @"王达";
        model.identity = @"老师";
        model.avatar = @"avatar";
        model;
    }),    ({
        ContactPersonModel *model = [[ContactPersonModel alloc] init];
        model.name = @"王达2";
        model.identity = @"老师";
        model.avatar = @"avatar";
        model;
    }),    ({
        ContactPersonModel *model = [[ContactPersonModel alloc] init];
        model.name = @"王二";
        model.identity = @"老师";
        model.avatar = @"avatar";
        model;
    }),  ({
        ContactPersonModel *model = [[ContactPersonModel alloc] init];
        model.name = @"王三";
        model.identity = @"老师";
        model.avatar = @"avatar";
        model;
    }), ({
        ContactPersonModel *model = [[ContactPersonModel alloc] init];
        model.name = @"李明";
        model.identity = @"老师";
        model.avatar = @"avatar";
        model;
    }),({
        ContactPersonModel *model = [[ContactPersonModel alloc] init];
        model.name = @"李三";
        model.identity = @"老师";
        model.avatar = @"avatar";
        model;
    }), ({
        ContactPersonModel *model = [[ContactPersonModel alloc] init];
        model.name = @"李八";
        model.identity = @"老师";
        model.avatar = @"avatar";
        model;
    }), ({
        ContactPersonModel *model = [[ContactPersonModel alloc] init];
        model.name = @"安美";
        model.identity = @"老师";
        model.avatar = @"avatar";
        model;
    }), ({
        ContactPersonModel *model = [[ContactPersonModel alloc] init];
        model.name = @"啊Q";
        model.identity = @"家长";
        model.avatar = @"avatar";
        model;
    }),
nil];
    
    NSMutableArray *modelArray = [NSMutableArray array];
    for (int i = 0; i< arr.count; i++) {
        NSMutableString *mutableString = [[NSMutableString stringWithString:arr[i].name] mutableCopy];
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
        CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformStripDiacritics, false);
        arr[i].symbol = mutableString;
        [modelArray addObject:arr[i]];
    }
    //NSSortDescriptor 指定用于对象数组排序的对象的属性
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"symbol" ascending:YES]];
    //对person进行排序
    [modelArray sortUsingDescriptors:sortDescriptors];

    for (int i = 0; i < modelArray.count; i++) {
        ContactPersonModel *model = modelArray[i];
        NSString *str = [model.symbol substringToIndex:1] ;
        if (![self.titleArray containsObject:str]) {
            [self.titleArray addObject:str];
        }
    }

    for (int i = 0; i< self.titleArray.count; i++) {
        NSString *str = self.titleArray[i];
        NSMutableArray *sortArray = [NSMutableArray array];
        BOOL flag = NO;
        for (ContactPersonModel *model in modelArray) {
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
}

- (void)showDefaultView{
    if(self.dataSource.count==0){
        [self.view addSubview:self.defaultView];
        [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(200, 230));
        }];
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchBar.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
           make.height.equalTo(@0);
        }];

    }
}

- (void)setupSubviews{
    [self.view addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).offset(10);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
        make.height.equalTo(@60);
    }];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor f6f6f6];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionIndexColor = [UIColor color999999];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
       
    }];
    [self showDefaultView];
}

- (void)jumpToAddressList{
    [self.navigationController pushViewController:[[AddressListViewController alloc]init] animated:YES];
}

- (UIView *)defaultView{
    if(!_defaultView){
        _defaultView = [UIView new];
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.image = [UIImage imageNamed:@"sample-1"];
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
            make.size.mas_equalTo(CGSizeMake(200, 200));
        }];
        [_defaultView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgView.mas_bottom).offset(10);
            make.centerX.equalTo(imgView);
        }];
    }
    return _defaultView;
}

- (ELSearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[ELSearchBar alloc]initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-10*2,60)];
        _searchBar.textField.returnKeyType = UIReturnKeySearch;
    }
    return _searchBar;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ContactPersonModel *data = self.dataSource[indexPath.section][indexPath.row];
    NSString *id =@"AddressListTableViewCell";
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[AddressListTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:data];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

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

- (void)addContact{
//    [self.navigationController pushViewController:[[ChatDetailViewController alloc]initWithModel:data] animated:YES];

}
@end
