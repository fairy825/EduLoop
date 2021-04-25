//
//  ELBottomSelectOverlay.m
//  EduLoop
//
//  Created by mijika on 2021/3/23.
//

#import "ELBottomSelectOverlay.h"
#import <Masonry/Masonry.h>
#import "UIColor+MyTheme.h"
#import "ELStackCardItem.h"
#import "ELScreen.h"
#import "TeamModel.h"
#import "ELBottomSelectOverlayCell.h"
@interface ELBottomSelectOverlay ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ELBottomSelectOverlay
- (void)showHighlightView{
    [self showHighlightViewFromPoint:CGPointMake(0,self.coverHeight) ToPoint:CGPointMake(self.coverWidth/2,self.coverHeight-self.container.bounds.size.height/2) Animation:YES];
    
    for(NSNumber *i in _selectedIdxs)
        if(i.integerValue>=0)
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i.integerValue inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

}

- (void)showHighlightViewFromPoint:(CGPoint) point ToPoint:(CGPoint) point2 Animation:(BOOL)animated{
    if(animated){
        self.container.frame = CGRectMake(point.x, point.y,  self.coverWidth,self.coverHeight*2/3);
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        [UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.container.center = point2;

        } completion:nil];
    }else{
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        self.container.center = point2;
    }
}
- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = SCREEN_WIDTH;
    CGFloat screenHeight = SCREEN_HEIGHT;
    self = [super initWithFrame:screenRect];
    if (self) {
        self.coverWidth = screenWidth;
        self.coverHeight = screenHeight;
        _title = title;
        _selectedIdxs = @[];
        _isSingle = YES;
//        _subTitles = subtitles;
        [self setUpSubviews];
    }
    return self;
}

- (void)reload{
    [self setUpSubviews];
}

- (void)setUpSubviews{
    [self layoutContainer];
    [self addSubview:self.backgroundView];
    [self addSubview:self.container];
}

- (UIView *)container{
    if(!_container){
        _container = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.coverWidth,self.coverHeight*2/3)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(25, 25)];

        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _container.bounds;
        maskLayer.path = maskPath.CGPath;
        _container.layer.mask = maskLayer;
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

- (UIView *)innerContainer{
    if(!_innerContainer){
        _innerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.coverWidth,400)];
    }
    return _innerContainer;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _titleLabel.text = _title;
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22.f];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}


- (void)layoutContainer{
    [self.container addSubview:self.innerContainer];
    [self.innerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container).mas_offset(UIEdgeInsetsMake(30, 20, 20, 20));
    }];
    
    [self.innerContainer addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.innerContainer);
        make.left.equalTo(self.innerContainer);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor whiteColor];
//    self.tableView.showsVerticalScrollIndicator=NO;
//    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.editing = YES;
    if(_isSingle==YES){
        [self.tableView setAllowsMultipleSelectionDuringEditing:NO];
    }else{
        [self.tableView setAllowsMultipleSelectionDuringEditing:YES];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.innerContainer addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.innerContainer);
        make.right.equalTo(self.innerContainer);
        make.bottom.equalTo(self.innerContainer);
    }];
//    [self scanDictionary];
}

//- (void)scanDictionary{
//    UIStackView * stack = [UIStackView new];
//    stack.axis = UILayoutConstraintAxisVertical;
//    stack.alignment = UIStackViewAlignmentFill;
//    stack.distribution = UIStackViewDistributionFillEqually;
//    for(int i=0;i< _dic.count;i++){
//        NSString * subTitle = [_subTitles objectAtIndex:i];
//        ELStackCardItem *item = [[ELStackCardItem alloc]initWithFrame: CGRectMake(0, 0, self.innerContainer.bounds.size.width, 300)];
//        item.subTitleLabel.text = subTitle;
//
//        item.collectionView.dataSource = self;
//        item.collectionView.delegate = self;
//        [stack addArrangedSubview:item];
//    }
//    [self.innerContainer addSubview:stack];
//    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
//        make.left.equalTo(self.titleLabel);
//        make.width.equalTo(self.innerContainer);
//        make.bottom.equalTo(self.innerContainer);
//    }];
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _subTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *id =@"ELBottomSelectOverlayCell";
    ELBottomSelectOverlayCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    NSUInteger idx = [indexPath row];
    if (!cell) {
        cell = [[ELBottomSelectOverlayCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:id];
    }
    cell.selectedBackgroundView = [[UIView alloc]init];
    cell.data = (NSString *)[self.subTitles objectAtIndex:idx];
//    cell.checkBox.delegate = self;
    [cell loadData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];
    if(_isSingle){
        [self.delegate ELBottomSelectOverlay:self singleUpdateChosedTeams:idx Add:YES];
    }else{
        [self.delegate ELBottomSelectOverlay:self updateChosedTeams:idx Add:YES];
    }
    for(NSInteger i=0;i< _subTitles.count;i++)
    [tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:NO];
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger idx = [indexPath row];
    if(_isSingle){
        [self.delegate ELBottomSelectOverlay:self singleUpdateChosedTeams:idx Add:NO];
    }else{
        [self.delegate ELBottomSelectOverlay:self updateChosedTeams:idx Add:NO];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

@end

