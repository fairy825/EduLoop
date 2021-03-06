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
@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITextViewDelegate>

@end

@implementation TestViewController

- (void)viewWillAppear:(BOOL)animated{
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, 414, 700)];
//    bgView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:bgView];
//
//    self.textView = [[UITextView alloc]init];
//    self.textView.delegate = self;
//    _textView.backgroundColor = [UIColor whiteColor];
//    _textView.textAlignment = NSTextAlignmentLeft;
//
//    [bgView addSubview:self.textView];
//    self.textView.frame = CGRectMake(20, 20, 414-40, 600);
//    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    self.textView.contentSize = CGSizeMake(self.textView.frame.size.width,self.textView.frame.size.height+1);

    
    // _placeholderLabel
//    UILabel *placeHolderLabel = [[UILabel alloc] init];
//    placeHolderLabel.text = @"请输入内容请输入内容请输入内容请输入内容...";
//    placeHolderLabel.numberOfLines = 0;
//    placeHolderLabel.textColor = [UIColor blackColor];
//    [placeHolderLabel sizeToFit];
//    [_textView addSubview:placeHolderLabel];

    // same font
//    _textView.font = [UIFont systemFontOfSize:20];
//    placeHolderLabel.font = [UIFont systemFontOfSize:20.f];
//    [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    
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
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize =  CGSizeMake(self.view.bounds.size.width*5, self.view.bounds.size.height*3);
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:scrollView];
    UIView *sub = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,100)];
    sub.backgroundColor = [UIColor redColor];
    [scrollView addSubview:sub];
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
//    [self.view addSubview:self.commentTableView];
//    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-80);
//    }];
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 500;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 500)];
    view.backgroundColor = [UIColor greenColor];
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UITableViewCell *cell=[self.commentTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.detailTextLabel.text=@"bbbbbbbbbbbbbbbb";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

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
