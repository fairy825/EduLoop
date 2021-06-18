//
//  MineToolCardItem.m
//  EduLoop
//
//  Created by mijika on 2020/12/3.
//

#import "MineToolCardItem.h"
#import <Masonry/Masonry.h>
#import "CommunityViewController.h"
@implementation MineToolCardItem
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon index:(int)index
{
    self = [super init];
    if (self) {
        self.index = index;
        
        self.icon = [UIImageView new];
        self.icon.image = [UIImage imageNamed:icon];
        self.icon.contentMode = UIViewContentModeScaleAspectFit;
        
        self.title = [UILabel new];
        self.title.numberOfLines = 1;
        self.title.lineBreakMode = NSLineBreakByTruncatingTail;
        self.title.text = title;
        self.title.textColor = [UIColor grayColor];
        self.title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];

        UIStackView * stack = [UIStackView new];
        stack.axis = UILayoutConstraintAxisVertical;
        stack.spacing = 6;
        stack.alignment = UIStackViewAlignmentCenter;
        
        [stack addArrangedSubview:self.icon];
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
        [stack addArrangedSubview:self.title];

        [self addSubview:stack];
        [stack mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.edges.equalTo(self);
        }];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMineToolCardItem)];
    [self addGestureRecognizer:tapGesture];
    return self;
}

+(instancetype)emptyItem {
    return [[MineToolCardItem alloc] initWithTitle:@"" icon:@"" index:-1];
}
@end
