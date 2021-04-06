//
//  IdentityCard.m
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import "IdentityCard.h"
#import <Masonry/Masonry.h>
#import "UIColor+MyTheme.h"
@implementation IdentityCard
- (instancetype)initWithFrame:(CGRect)frame Type:(UserIdentityType) identity
{
    self = [super initWithFrame:frame];
    if (self) {
        _identity = identity;
        [self setupViews];
        [self loadData];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

-(void)loadData{
    if(_identity==USER_IDENTITY_PARENT){
        _detailLabel.text = @"我是家长";
//        _radioBtn.titleLabel.text = @"我是家长";
        _imageView.image = [UIImage imageNamed:@"icon_parent"];
    }else{
        _detailLabel.text = @"我是老师";
//        _radioBtn.titleLabel.text = @"我是老师";
        _imageView.image = [UIImage imageNamed:@"icon_teacher"];
//        [_radioBtn setSelected:YES];
    }

}

- (void)setupViews{
    self.backgroundColor = [UIColor elColorWithHex:0xFFCC99 andAlpha:0.5];
    self.layer.cornerRadius = 10;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor yellowColor].CGColor;
    
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 0, 20, 20));
    }];
    
    [self.bgView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(30);
        make.bottom.equalTo(self.bgView).offset(-30);
        make.left.equalTo(self.bgView);
        make.width.equalTo(self.imageView.mas_height);
    }];
    
    [self.bgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.left.equalTo(self.imageView.mas_right).offset(20);
    }];
    
    [self.bgView addSubview:self.radioBtn];
    [self.radioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView.layer.cornerRadius = 25;
        _imageView.layer.masksToBounds = YES;
        
    }
    return _imageView;
}

- (DLRadioButton *)radioBtn{
    if(!_radioBtn){
        _radioBtn = [[DLRadioButton alloc]init];
        _radioBtn.iconColor = [UIColor blackColor];
        _radioBtn.indicatorColor = [UIColor blackColor];
        _radioBtn.animationDuration = 0.0;
//        _radioBtn.titleLabel.textColor = [UIColor blackColor];
//        _radioBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
    }
    return _radioBtn;
}

- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        _detailLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
        _detailLabel.textColor = [UIColor blackColor];
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

-(void)clickAction{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickIdentityCard:)]){
        [self.delegate clickIdentityCard:self];
    }
}
@end
