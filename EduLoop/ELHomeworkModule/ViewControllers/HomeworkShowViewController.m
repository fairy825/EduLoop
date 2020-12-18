//
//  HomeworkShowViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import "HomeworkShowViewController.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "HomeworkShowTableViewCell.h"
#import "ELOverlay.h"
#import "ELCenterOverlay.h"
#import "BroadcastViewController.h"
@interface HomeworkShowViewController ()<UITableViewDelegate,UITableViewDataSource,HomeworkShowTableViewCellDelegate>

@end

@implementation HomeworkShowViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor eh_f6f6f6];
    [self loadData];
    [self setupSubviews];
}

- (void)loadData{
    _models = @[].mutableCopy;
    
    [_models addObject:({
        HomeworkModel *model = [HomeworkModel new];
        model.title = @"12月14日作业";
        model.detail =@"test1";
        model.allowSubmitAfter = NO;
        model.submitOnline = YES;
        model;
    })];
    [_models addObject:({
        HomeworkModel *model = [HomeworkModel new];
        model.title = @"12月15日作业";
        model.detail =@"测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试测试";
        model;
    })];
}
- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_f6f6f6];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    
    [self.view addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-100);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).offset(-10);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
}


- (ELFloatingButton *)addBtn{
    if(!_addBtn){
        _addBtn = [[ELFloatingButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50) Image: [UIImage imageNamed:@"icon_add"]];
        _addBtn.delegate = self;
    }
    return _addBtn;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"HomeworkShowTableViewCell";
    HomeworkShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        NSUInteger idx = [indexPath row];
        cell = [[HomeworkShowTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:self.models[idx]];
        cell.delegate = self;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 216;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = [indexPath row];
    [self jumpToDetailPageWithData:_models[row]];
}

#pragma mark - ELFloatingButtonDelegate
- (void)clickFloatingButton{
    [self jumpToDetailPageWithData:nil];
}

#pragma mark - action
- (void)jumpToDetailPageWithData:(HomeworkModel *)model{
    [self.navigationController pushViewController:[[BroadcastViewController alloc]initWithHomeworkData:model] animated:YES];
}

#pragma mark - HomeworkShowTableViewCellDelegate
- (void)clickOtherButtonTableViewCell:(UITableViewCell *)tableViewCell {
    HomeworkShowTableViewCell *cell = (HomeworkShowTableViewCell *)tableViewCell;
    ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:self.view.bounds Data:@[
        ({
        ELOverlayItem *item = [ELOverlayItem new];
        item.title = @"编辑";
        item.clickBlock = ^{
            [self jumpToDetailPageWithData:cell.data];
        };
        item;
    }),
        ({
        ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
        centerOverlayModel.title = @"确认删除此作业吗？";
        centerOverlayModel.subTitle = @"删除后不可恢复";
        centerOverlayModel.leftChoice = ({
            ELOverlayItem *sureItem =[ELOverlayItem new];
            sureItem.title = @"确认";
            __weak typeof(self) wself = self;
            sureItem.clickBlock = ^{
                __strong typeof(self) sself = wself;
                NSIndexPath *index = [sself.tableView indexPathForCell:tableViewCell];
                [sself.models removeObjectAtIndex:[index row]];
                [sself.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
            };
            sureItem;
        });
        ELOverlayItem *item = [ELOverlayItem new];
        item.title = @"删除";
        item.clickBlock = ^{
            ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
            ];
            
            [deleteAlertView showHighlightView];
        };
        item;
        
    })]];
    [overlay showHighlightView];
}
@end
