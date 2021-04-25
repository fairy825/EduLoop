//
//  ELCenterImgOverlay.m
//  EduLoop
//
//  Created by mijika on 2021/4/17.
//

#import "ELCenterImgOverlay.h"
#import <Masonry/Masonry.h>
#import "UIColor+MyTheme.h"
#import <SDWebImage/SDWebImage.h>
@implementation ELCenterImgOverlay

- (instancetype)initWithImageFrame:(CGRect)frame Title:(NSString *)title SubTitle:(NSString *)subtitle ImageUrl:(NSString *)imageUrl
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self = [super initWithFrame:screenRect];
    if (self) {
        self.coverWidth = screenWidth;
        self.coverHeight = screenHeight;
        _imgFrame = frame;
        _titleStr = title;
        _subtitleStr = subtitle;
        _imageUrl = imageUrl;
        [self setUpSubviews];
        [self loadData];
    }
    return self;
}


- (void)loadData{
    _titleLabel.text = _titleStr;
    _subTitleLabel.text = _subtitleStr;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage: [UIImage imageNamed:@"avatar-4"] options:SDWebImageRefreshCached];
}

- (void)setUpSubviews{
    [self addSubview:self.backgroundView];
    [self addSubview:self.alertView];
}

- (void)showHighlightViewFromPoint:(CGPoint) point ToPoint:(CGPoint) point2 Animation:(BOOL)animated{
    if(animated){
        self.alertView.frame = CGRectMake(point.x, point.y,  self.alertView.frame.size.width,self.alertView.frame.size.height);
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        [UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.alertView.center = point2;

        } completion:nil];
    }else{
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        self.alertView.center = point2;
    }
}

- (void)showHighlightView{
    [self showHighlightViewFromPoint:CGPointZero ToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) Animation:NO];
}

#pragma mark - View
- (UIView *)backgroundView{
    if(!_backgroundView){
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _coverWidth, _coverHeight)];
        self.backgroundView.backgroundColor = [UIColor grayColor];
        self.backgroundView.alpha = 0.5;
    }
    return _backgroundView;
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}

- (UIView *)alertView{
    if(!_alertView){
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,_imgFrame.size.width+40 ,_imgFrame.size.height+120)];
        _alertView.layer.cornerRadius = 15;
        _alertView.layer.masksToBounds = YES;
        _alertView.backgroundColor = [UIColor whiteColor];
        UIView *bgView = [[UIView alloc]init];
        [self.alertView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.alertView);
        }];
        
        [self.alertView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bgView).offset(20);
            make.left.equalTo(bgView).offset(20);
            make.height.equalTo(@30);
//            make.centerX.equalTo(self.alertView);
//            make.width.equalTo(@(self.alertView.bounds.size.width-30));
        }];
        
        [self.alertView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(bgView).offset(-20);
            make.top.equalTo(bgView).offset(20);
            make.size.mas_equalTo(CGSizeMake(20,20));
        }];
        
        [self.alertView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.left.equalTo(bgView).offset(20);
            make.right.equalTo(bgView).offset(-20);
            make.size.mas_equalTo(self.imgFrame.size);
        }];
        
        [self.alertView addSubview:self.subTitleLabel];
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(15);
            make.bottom.equalTo(bgView).offset(-20);
            make.centerX.equalTo(bgView);
            make.height.equalTo(@20);
        }];
    }
    return _alertView;
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
#pragma mark - action

- (void)dismissOverlay{
    [self removeFromSuperview];
}

@end

