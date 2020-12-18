//
//  MineMiscCard.m
//  EduLoop
//
//  Created by mijika on 2020/12/4.
//

#import "MineMiscCard.h"
#import <Masonry/Masonry.h>

@implementation MineMiscCard

- (instancetype)init
{
    self = [super init];
    if (self) {
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
    
    self.miscTableView = [[UITableView alloc]init];
    self.miscTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.miscTableView.scrollEnabled = NO;
    [shadow addSubview:self.miscTableView];
    [self.miscTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(shadow).mas_offset(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
    
}
@end
