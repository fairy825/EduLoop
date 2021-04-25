//
//  ChildProfileCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/9.
//

#import "ChildProfileCard.h"
#import "SettingDataTableViewCell.h"
#import "ChildModel.h"
#import <Masonry/Masonry.h>
#import "UIColor+MyTheme.h"
#import "ELOverlay.h"
#import "ELCenterOverlay.h"
#import "BasicInfo.h"
#import "ELCenterImgOverlay.h"
#import <AFNetworking/AFNetworking.h>
@interface ChildProfileCard()<UITableViewDelegate,UITableViewDataSource,ELOverlayDelegate>
@property(nonatomic,strong,readwrite) NSMutableArray<SettingDataModel*>* models;
@end

@implementation ChildProfileCard
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadData:nil];
        [self setupView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData:nil];
        [self setupView];
    }
    return self;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(ChildModel *)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadData:model];
        [self setupView];
    }
    return self;
}

- (void)reload:(ChildModel *)data{
    [self loadData:data];
    [self.tableView reloadData];
}

- (void)loadData:(ChildModel *)data{
    _model = data;
    _models = @[].mutableCopy;
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Image;
        model.showArrow = NO;
        model.title =@"孩子头像";
        model.defaultAvatarImage = [UIImage imageNamed:@"avatar-4"];
        model.avatarImageUrl =data.avatarUrl;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Text;
        model.showArrow = NO;
        model.title =@"孩子昵称";
        model.detailText = data.nickname;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Text;
        model.showArrow = NO;
        model.title =@"孩子学号";
        model.detailText = data.sno;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Text;
        model.showArrow = YES;
        model.title =@"所在班级";
        model.detailText = data.team;
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            if(sself.model.teamId==0){
                if(sself.delegate&&[sself.delegate respondsToSelector:@selector(ChildProfileCardJumpToInputCode:)]){
                        [sself.delegate ChildProfileCardJumpToInputCode:sself];
                }
            }else{
                ELCenterOverlayModel *centerOverlayModel = [ELCenterOverlayModel new];
                centerOverlayModel.title = @"确认退出该班级吗？";
                centerOverlayModel.leftChoice = ({
                    ELOverlayItem *sureItem =[ELOverlayItem new];
                    sureItem.title = @"确认";
                    __weak typeof(self) wwself = sself;
                    sureItem.clickBlock = ^{
                        __strong typeof(self) ssself = wwself;
                        [ssself quitTeamNetwork:^{
                            ssself.models[3].detailText = @"";
                            ssself.model.team = @"";
                            ssself.model.teamId = 0;
                            [ssself.tableView reloadData];
                        }];
                    };
                    sureItem;
                });
                ELCenterOverlay *alertView = [[ELCenterOverlay alloc]initWithFrame:sself.bounds Data:centerOverlayModel];
                [alertView showHighlightView];
            }
        };
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.accessoryType = SettingTableViewCellType_Text;
        model.title =@"孩子年级";
        model.detailText = data.grade;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.accessoryType = SettingTableViewCellType_Text;
        model.title =@"孩子性别";
        model.detailText = data.sex;
        /**__weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:sself.bounds Data:@[({
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
        };*/
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.showArrow = NO;
        model.accessoryType = SettingTableViewCellType_Text;
        model.title =@"关系";
        model.detailText = data.relationship;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Text;
        model.showArrow = YES;
        model.title =@"查看二维码";
        __weak typeof(self) wself = self;
        model.clickBlock = ^{
            __strong typeof(self) sself = wself;
            
            ELCenterImgOverlay *overlay = [[ELCenterImgOverlay alloc]initWithImageFrame:CGRectMake(0, 0, 250, 250) Title:sself.model.nickname SubTitle:[NSString stringWithFormat:@"%@%@%@",@"扫一扫，和学生",sself.model.nickname, @"绑定"] ImageUrl:sself.model.qrcode];
            [overlay showHighlightView];
        };
        model;
    })];
}
- (void)setupView{
    self.backgroundColor = [UIColor f6f6f6];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(20, 20, 20, 20));;
    }];
}

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame: self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.layer.cornerRadius = 10;
        _tableView.layer.masksToBounds = YES;
    }
    return _tableView;
}

//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    UIView *hitView = [super hitTest:point withEvent:event];
//    if(hitView == self){
//        return nil;
//    }
//    return hitView;
//}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"settingDataTableViewCell";
    SettingDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];

    NSUInteger row = [indexPath row];
//    if(row!=3&&row!=7)
//        cell.userInteractionEnabled = NO;
    SettingDataModel *model = self.models[row];
    if (!cell) {
        cell = [[SettingDataTableViewCell alloc]                        initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:id data:model];
    }
    cell.data = model;
    [cell loadData];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    if(self.models[row].accessoryType==SettingTableViewCellType_Image)
        return 90;
    return 56;
}


- (void) getChosenTitle:(NSString *)title{
    [_models objectAtIndex:4].detailText = title;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)quitTeamNetwork:(nullable void (^)())success{
    
    [BasicInfo DELETE:
     [NSString stringWithFormat:@"%@%ld%@%ld",
      [BasicInfo url:@"/team/"],
      (long)_model.teamId,
      @"/quit/",
      _model.id] success:success];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
       if ([view isKindOfClass:[self.contentView class]]) {
           if ([[view superview] isKindOfClass:[SettingDataTableViewCell class]]){
               SettingDataTableViewCell *cell = (SettingDataTableViewCell *)[view superview];
               if(cell.data.clickBlock==nil)
                   return self;
           }
       }
       return [super hitTest:point withEvent:event];
}
@end
