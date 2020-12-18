//
//  ViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/2.
//

#import "MineViewController.h"
#import "UIColor+EHGenerator.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "MineMiscCardTableViewCell.h"
#import "ProfileViewController.h"
#import "ChildProfileViewController.h"
@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MineViewController
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.miscTitles = @[@"孩子档案",@"推荐给好友",@"意见反馈"];
    self.miscDetails = @[@"",@"",@""];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_f6f6f6];
//    scrollView.contentSize = CGSizeMake(self.view.bounds.size.width*5, self.view.bounds.size.height*3);
    scrollView.showsVerticalScrollIndicator=NO;
//    scrollView.pagingEnabled=YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [self setupSubviews];
}

- (void)setupSubviews {
    self.container = [[UIView alloc]init];
    [self.view addSubview:self.container];
    if (@available(iOS 11,*)) {
        [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        }];
    } else {

        [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    self.header = [[MineInfoCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 110)];
    UITapGestureRecognizer  *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToProfile)];
    [self.header addGestureRecognizer:recognizer];
    [self.container addSubview:self.header];
    
    self.toolCard = [[MineToolCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 110)];
    [self.container addSubview:self.toolCard];
    [self.toolCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.header.mas_bottom);
        make.height.equalTo(@82);
    }];
    
    self.miscCard = [[MineMiscCard alloc]init];
    self.miscCard.miscTableView.delegate = self;
    self.miscCard.miscTableView.dataSource = self;
    [self.container addSubview:self.miscCard];
    [self.miscCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.toolCard.mas_bottom).offset(20);
        make.height.equalTo(@188);
    }];
    
    [self.container addSubview:self.logOutBtn];
    [self.logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.view).offset(-20);
        make.top.equalTo(self.miscCard.mas_bottom).offset(20);
        make.height.equalTo(@56);
    }];
}
#pragma mark - action
- (void)jumpToProfile{
    ProfileViewController *viewController = [ProfileViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)jumpToViewController:(UIViewController *)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - View

- (UIButton *)logOutBtn{
    if(!_logOutBtn){
        self.logOutBtn = [[UIButton alloc]init];
        self.logOutBtn.backgroundColor = [UIColor whiteColor];
        self.logOutBtn.layer.cornerRadius = 12;
        [self.logOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [self.logOutBtn setTitleColor:[UIColor eh_colorWithHexRGB:EHThemeColor_999999] forState:UIControlStateNormal];
        [self.logOutBtn.titleLabel setTextAlignment: NSTextAlignmentCenter];
        [self.logOutBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Bold" size:16]];
    }
    return _logOutBtn;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"mineMiscCardTableViewCell";
    MineMiscCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[MineMiscCardTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id];
        NSUInteger row = [indexPath row];
        cell.index = row;
        cell.title.text = [self.miscTitles objectAtIndex:row];
        cell.detail.text = [self.miscDetails objectAtIndex:row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    if([_miscTitles[row] isEqual:@"孩子档案"]){
        ChildProfileViewController *viewController = [[ChildProfileViewController alloc]init];
        [self jumpToViewController:viewController];
    }
}

@end
