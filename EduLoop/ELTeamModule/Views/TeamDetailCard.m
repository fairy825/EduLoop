//
//  TeamDetailCard.m
//  EduLoop
//
//  Created by mijika on 2021/4/25.
//

#import "TeamDetailCard.h"
#import <Masonry/Masonry.h>

@implementation TeamDetailCard
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];

    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;

    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(20, 20, 20, 20));
    }];

    [self.bgView addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.bgView).offset(30);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.avatarImage.mas_right).offset(40);
        make.right.lessThanOrEqualTo(self.bgView);
        make.height.equalTo(@20);
    }];
    
    [self.bgView addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.equalTo(self.bgView);
        make.bottom.equalTo(self.bgView);
    }];
}

- (void)loadData:(TeamModel *)data{
    _data = data;
    _titleLabel.text = _data.name;
    _codeLabel.text = _data.code;
    _avatarImage.image = [UIImage imageNamed:@"icon_team"];
}

#pragma mark - View
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
        _avatarImage.layer.cornerRadius = 20;
        _avatarImage.layer.masksToBounds = YES;
        
    }
    return _avatarImage;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)codeLabel{
    if(!_codeLabel){
        _codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,100,20)];
        _codeLabel.font = [UIFont systemFontOfSize:16.f];
        _codeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _codeLabel.textAlignment = NSTextAlignmentLeft;
        _codeLabel.numberOfLines = 1;
        [_codeLabel sizeToFit];
    }
    return _codeLabel;
}

@end
