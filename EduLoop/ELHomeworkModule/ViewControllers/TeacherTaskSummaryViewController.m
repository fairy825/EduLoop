//
//  TeacherTaskSummaryViewController.m
//  EduLoop
//
//  Created by mijika on 2021/3/29.
//

#import "TeacherTaskSummaryViewController.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "TeacherTaskSummaryTableViewCell.h"
#import "HomeworkModel.h"
#import "ELScreen.h"
#import "ReviewViewController.h"
@interface TeacherTaskSummaryViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TeacherTaskSummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self setNavagationBar];
    [self setupSubviews];
}

- (instancetype)initWithTeacherTaskModel:(TeacherTaskModel *)data
{
    self = [super init];
    if (self) {
        _data = data;
        _models = _data.homeworkLists;
//        [self getAllMyTeamsNetwork];
//        [self loadData:data];
    }
    return self;
}

- (void)setNavagationBar{
    [self setTitle:@"任务详情"];
    
    UIView *nav = [[UIView alloc]initWithFrame: CGRectMake(50, 0, 200, 50)];
    nav.backgroundColor = [UIColor color5bb2ff];
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont fontWithName:@"PingFangSC" size:14.f];
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%@%@",@"截止提交时间：",_data.endTime];
    [label sizeToFit];
    [nav addSubview:label];
    
    self.navigationItem.titleView = nav;
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableHeaderView:
        ({
            UIView *header = [UIView new];
            [header addSubview:self.taskDetailCard];
            [self.taskDetailCard loadData:_data];
        [header setNeedsLayout];
        [header layoutIfNeeded];
        NSLog(@"%@", [NSString stringWithFormat:@"%f",self.taskDetailCard.bounds.size.height ]);
        header.frame = CGRectMake(20, 20, SCREEN_WIDTH-40, 200);
        header;
        })];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
}

-(void)loadData{
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _data.homeworkLists.count;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return @" ";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"TeacherTaskSummaryTableViewCell";
    TeacherTaskSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger idx = [indexPath row];
    HomeworkModel *model = self.models[idx];
    if (!cell) {
        cell = [[TeacherTaskSummaryTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id];
    }
    cell.data = model;
    [cell loadData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    [self jumpToDetailPageWithData:_models[row]];
}

- (void)jumpToDetailPageWithData:(HomeworkModel *)model{
    [self.navigationController pushViewController: [[ReviewViewController alloc]initWithHomeworkModel:model] animated:YES];

}

- (TaskDetailCard *)taskDetailCard{
    if(!_taskDetailCard){
        _taskDetailCard = [[TaskDetailCard alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 250)];
        
    }
    return _taskDetailCard;
}

@end
