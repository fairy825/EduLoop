//
//  ChatDetailViewController.m
//  EduLoop
//
//  Created by mijika on 2021/1/4.
//

#import "ChatDetailViewController.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>

@interface ChatDetailViewController ()<ChatBoardDelegate>

@end

@implementation ChatDetailViewController

- (instancetype)initWithModel:(ContactPersonModel *)personModel{
    self = [super init];
    if (self) {
        _personModel = personModel;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor eh_f6f6f6];
    [self setNavagationBar];
    [self loadData];
    [self setupSubviews];
}

- (void)setNavagationBar{
    [self setTitle:self.personModel.name];
}

- (void)loadData{
//    _models = @[].mutableCopy;
//
//    [_models addObject:({
//        ChatAllModel *model = [ChatAllModel new];
//        ContactPersonModel *personModel = [ContactPersonModel new];
//        personModel.name = @"陈老师";
//        personModel.avatar = @"avatar";
//        model.personModel = personModel;
//        model.dateStr = @"刚刚";
//        model.unreadNum = @"2";
//        model.messageStr = @"您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好";
//        model;
//    })];
//    [_models addObject:({
//        ChatAllModel *model = [ChatAllModel new];
//        ContactPersonModel *personModel = [ContactPersonModel new];
//        personModel.name = @"陈老师";
//        personModel.avatar = @"avatar";
//        model.personModel = personModel;
//        model.dateStr = @"刚刚";
//        model.unreadNum = @"2";
//        model.messageStr = @"您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好您好";
//        model;
//    })];
    
}

- (void)setupSubviews{
    [self.view addSubview:self.chatBoard];
    self.chatBoard.frame = CGRectMake(0, self.view.bounds.size.height-34-60, self.view.bounds.size.width, 60);
//    self.tableView = [[UITableView alloc]init];
//    self.tableView.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_f6f6f6];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 60.0;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self.view addSubview:self.tableView];
//
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//
//    }];
}

- (ChatBoard *)chatBoard{
    if(!_chatBoard){
        _chatBoard = [ChatBoard sharedManager];
        _chatBoard.textView.delegate = self;
        _chatBoard.delegate = self;
    }
    return _chatBoard;
}


#pragma mark - ChatBoardDelegate
- (void)textView:(UITextView *)textView finalText:(NSString *)text{
    NSLog(@"%@", [NSString stringWithFormat:@"%@", text]);
}

@end
