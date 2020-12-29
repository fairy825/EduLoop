//
//  CommunityViewController.m
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import "CommunityViewController.h"
#import "UgcCard.h"
#import "UIColor+EHTheme.h"
#import <Masonry/Masonry.h>
#import "ELCenterOverlayModel.h"
#import "ELCenterOverlay.h"
#import "UgcTextImgCard.h"
#import "UgcVoteCard.h"
#import "UgcCardTableViewCell.h"
#import "UgcDetailPageViewController.h"
#import "ELImageManager.h"
@interface CommunityViewController ()<UITableViewDelegate,UITableViewDataSource,UgcCardTableViewCellDelegate>

@end

@implementation CommunityViewController

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
        UgcModel *model = [UgcModel new];
        model.authorName = @"dd";
        model.detail =@"发了一条班级圈～";
        model.thumbNum = 4;
        model.commentNum = 5;
        model.dateStr = @"刚刚";
        model.hasClickedThumb = NO;
        model.isMine = YES;
        model.imgs = @[@"sample-1",@"sample-2",@"sample-2"];
        model;
    })];
    [_models addObject:({
        UgcModel *model = [UgcModel new];
        model.authorName = @"Mijika";
        model.detail =@"发了一条班级圈～";
        model.thumbNum = 4;
        model.commentNum = 5;
        model.dateStr = @"刚刚";
        model.hasClickedThumb = YES;
        model;
    })];
    [_models addObject:({
        UgcModel *model = [UgcModel new];
        model.ugcType = UgcType_vote;
        model.authorName = @"dd";
        model.dateStr = @"刚刚";
        model.isMine = YES;

        model;
    })];
    [_models addObject:({
        UgcModel *model = [UgcModel new];
        model.ugcType = UgcType_vote;
        model.authorName = @"Mijika";
        model.dateStr = @"刚刚";
        model.leftPercent = 23.2;
        model.leftChoice = @"不该";
        model.rightChoice = @"该";
        model.detail = @"老师应该和学生一起上体育课吗？";
        model.hasPicked = NO;
        model;
    })];
    
}

- (void)setupSubviews{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor eh_colorWithHexRGB:EHThemeColor_f6f6f6];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 244.0;
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
    NSUInteger idx = [indexPath row];

    UgcModel *data = [_models objectAtIndex:idx];
    NSString *id =@"UgcCardTableViewCell";
    UgcCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (!cell) {
        cell = [[UgcCardTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:data];
        cell.ugcCard.delegate = self;
        [cell layoutIfNeeded];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 356;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];

    UgcModel *data = [_models objectAtIndex:idx];
    [self pushToDetailPageWithData:data];

}
- (void)pushToDetailPageWithData:(UgcModel *)data{
    
    [self.navigationController pushViewController:[[UgcDetailPageViewController alloc]initWithModel:data] animated:YES];
}
#pragma mark - ELFloatingButtonDelegate
- (void)clickFloatingButton{
//    [self jumpToDetailPageWithData:nil];
}

#pragma mark - UgcCardDelegate
-(void)clickCommentButtonTableViewCell:(UITableViewCell *)tableViewCell{
    NSInteger idx = [[self.tableView indexPathForCell:tableViewCell]row];
    UgcModel *data = [_models objectAtIndex:idx];
    [self pushToDetailPageWithData:data];
}

- (void)clickTrashButtonTableViewCell:(UITableViewCell *)tableViewCell{
        ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
        centerOverlayModel.title = @"确认删除此动态吗？";
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
        ELCenterOverlay *deleteAlertView = [[ELCenterOverlay alloc]initWithFrame:self.view.bounds Data:centerOverlayModel
        ];
        
        [deleteAlertView showHighlightView];
}

- (void)clickPhoto:(UIImage *)photo TableViewCell:(UITableViewCell *)tableViewCell{
    [[ELImageManager sharedManager]showImageView:photo];
}

@end
