//
//  NELCenterCustomOverlay.m
//  EduLoop
//
//  Created by bytedance on 2021/7/22.
//

#import "NELCenterCustomOverlay.h"
#import <Masonry/Masonry.h>
#import <SDWebImage/SDWebImage.h>

@interface NELCenterCustomOverlay()
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,strong,readwrite) UILabel *subTitleLabel;
@property(nonatomic,strong,readwrite) UIButton *closeBtn;
@property(nonatomic,strong,readwrite) UIImageView *imageView;
@end

@implementation NELCenterCustomOverlay

- (instancetype)initWithImageFrame:(CGRect)frame Title:(NSString *)title SubTitle:(NSString *)subtitle ImageUrl:(NSString *)imageUrl
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _imgFrame = frame;
        _titleStr = title;
        _subtitleStr = subtitle;
        _imageUrl = imageUrl;
        [self setUpSubviews];

        [self loadData];
    }
    return self;
}

- (void)setUpHighlightView{
//    self.highlightFrame = CGRectMake(0, 0,_imgFrame.size.width+40 ,_imgFrame.size.height+120);
//    self.highLightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,_imgFrame.size.width+40 ,_imgFrame.size.height+120)];
//    self.highLightView.backgroundColor = [UIColor whiteColor];
    UIView *bgView = [[UIView alloc]init];
    [self.highLightView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.highLightView);
    }];
    
    [bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(20);
        make.left.equalTo(bgView).offset(20);
        make.height.equalTo(@30);
//            make.centerX.equalTo(self.alertView);
//            make.width.equalTo(@(self.alertView.bounds.size.width-30));
    }];
    
    [bgView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-20);
        make.top.equalTo(bgView).offset(20);
        make.size.mas_equalTo(CGSizeMake(20,20));
    }];
    
    [bgView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.equalTo(bgView).offset(20);
        make.right.equalTo(bgView).offset(-20);
        make.size.mas_equalTo(self.imgFrame.size);
    }];
    
    [bgView addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
        make.bottom.equalTo(bgView).offset(-20);
        make.centerX.equalTo(bgView);
        make.height.equalTo(@20);
    }];
    
    // TODO: 当前highlightView.frame = 0,0,0,0
    
}
- (void)loadData{
    _titleLabel.text = _titleStr;
    _subTitleLabel.text = _subtitleStr;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage: [UIImage imageNamed:@"avatar-4"] options:SDWebImageRefreshCached];
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}
- ( UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20.f];
        _titleLabel.numberOfLines =1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- ( UILabel *)subTitleLabel{
    if(!_subTitleLabel){
        _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _subTitleLabel.font = [UIFont systemFontOfSize:16.f];
        _subTitleLabel.textColor = [UIColor grayColor];
        _subTitleLabel.numberOfLines =0;
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_subTitleLabel sizeToFit];
    }
    return _subTitleLabel;
}

- (UIButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_closeBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
//        [_closeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
        [_closeBtn addTarget:self action:@selector(dismissOverlay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
