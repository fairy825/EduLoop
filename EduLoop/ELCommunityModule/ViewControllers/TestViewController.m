//
//  TestViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/24.
//

#import "TestViewController.h"
#import <Masonry/Masonry.h>
#import "ELSearchBar.h"
#import "ELCommentManager.h"
@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@end

@implementation TestViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    [self.tabBarController.navigationItem setTitleView:({
//        ELSearchBar *searchBar = [[ELSearchBar alloc]initWithFrame:CGRectMake(0, 0, 300, self.navigationController.navigationBar.bounds.size.height)];
//        searchBar;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, self.navigationController.navigationBar.bounds.size.height)];
        btn.backgroundColor = [UIColor grayColor];
        [btn addTarget:self action:@selector(_showCommentView) forControlEvents:UIControlEventTouchUpInside];
        btn;
    })];
}
- (void)_showCommentView{
    [[ELCommentManager sharedManager]showCommentView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scrollView.contentSize =  CGSizeMake(self.view.bounds.size.width*5, self.view.bounds.size.height*3);
//
//    scrollView.delegate = self;
//    scrollView.showsVerticalScrollIndicator = YES;
//    [self.view addSubview:scrollView];
//
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 500)];
//    view.backgroundColor = [UIColor greenColor];
//    [scrollView addSubview:view];
//    [view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//        make.height.equalTo(@500);
//    }];
    
//    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 500)];
//    view2.backgroundColor = [UIColor yellowColor];
//    [scrollView addSubview:view2];
//    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view.mas_bottom);
//        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//        make.height.equalTo(@500);
//    }];
//    self.commentTableView = [[UITableView alloc]init];
//    self.commentTableView.delegate = self;
//    self.commentTableView.dataSource = self;
//    self.commentTableView.estimatedRowHeight = 88.0;
//    self.commentTableView.rowHeight = UITableViewAutomaticDimension;
//    self.commentTableView.showsVerticalScrollIndicator = NO;
//    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [scrollView addSubview:self.commentTableView];
//    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view.mas_bottom);
//        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-80);
//    }];
    
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 500;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 500)];
//    view.backgroundColor = [UIColor greenColor];
//    return view;
//}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"..");
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];

    NSString *id =@"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[UITableViewCell alloc]                    initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id];
        cell.detailTextLabel.numberOfLines = 0;
        if(idx%2==0)
            cell.detailTextLabel.text = @"aaa";
        else
            cell.detailTextLabel.text = @"aaaUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];if (!cell) {cell = [[UITableViewCell alloc]                    initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id]";

    }
    return cell;
}
@end
