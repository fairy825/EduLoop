//
//  MineToolCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/3.
//

#import "MineToolCard.h"
#import <Masonry/Masonry.h>

@implementation MineToolCard
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSArray *iconArr = @[@"profile_trends-1",@"profile_feed-1",@"profile_history-2",@"profile_favorites-1"];
        NSArray *titleArr = @[@"我的动态",@"作业反馈",@"观看记录",@"收藏夹"];
        
        NSMutableArray<MineToolCardItem*> * views = [NSMutableArray array];
        for(int i=0;i<4;i++){
            MineToolCardItem *item = [[MineToolCardItem alloc]initWithTitle:titleArr[i] icon:iconArr[i] index:i];
            [views addObject:item];
        }
        _items = views;
        [self setupView];
    }
    return self;
}

- (void)setupView{
    UIView * shadow = [UIView new];
    shadow.backgroundColor = [UIColor whiteColor];
    shadow.layer.shadowOpacity = 1;
    shadow.layer.cornerRadius = 12;
    shadow.layer.shadowOffset = CGSizeZero;
    shadow.layer.shadowRadius = 22;
    shadow.layer.shadowColor = [UIColor colorWithRed:0.742 green:0.742 blue:0.742 alpha:0.25].CGColor;

    [self insertSubview:shadow atIndex:0];
    [shadow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    UIStackView * stack = [UIStackView new];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.alignment = UIStackViewAlignmentCenter;
    stack.distribution = UIStackViewDistributionFillEqually;
    for(int i=0;i<_items.count;i++)
    [stack addArrangedSubview:_items[i]];

    [shadow addSubview:stack];
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(shadow).mas_offset(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
    
}

@end
