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

- (void)loadData:(ChildModel *)data{
    _models = @[].mutableCopy;
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_Image;
        model.title =@"孩子头像";
        model.defaultAvatarImage = [UIImage imageNamed:@"avatar-4"];
        model.avatarImageUrl =data.avatarUrl;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_InlineTextField;
        model.showArrow = NO;
        model.title =@"孩子昵称";
        model.detailText = data.nickname;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.accessoryType = SettingTableViewCellType_InlineTextField;
        model.showArrow = NO;
        model.title =@"孩子学校";
        model.detailText = data.school;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"孩子年级";
        model.detailText = data.grade;
        model;
    })];
    [_models addObject:({
        SettingDataModel *model = [SettingDataModel new];
        model.title =@"孩子性别";
        model.detailText = data.sex;
        model.clickBlock = ^{
            ELBottomOverlay *overlay = [[ELBottomOverlay alloc]initWithFrame:self.bounds Data:@[({
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *id =@"settingDataTableViewCell";
    SettingDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger row = [indexPath row];
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
@end
