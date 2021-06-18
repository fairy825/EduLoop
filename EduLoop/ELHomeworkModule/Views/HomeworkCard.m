//
//  HomeworkCard.m
//  EduLoop
//
//  Created by mijika on 2021/3/30.
//

#import "HomeworkCard.h"
#import <Masonry/Masonry.h>
#import <SDWebImage.h>
#import "ELScreen.h"
#import "ELPublishImage.h"
#import "ELImageManager.h"
@implementation HomeworkCard
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

-(void)reload{
    [self loadData];
    [self setupSubviews];
}

- (void)loadData{
    _detailLabel.text = _data.detail;
    _timeLabel.text = _data.publishTime;
    _parentLabel.text = [NSString stringWithFormat:@"%@%@",@"家长：",_data.authorName];
    _studentLabel.text = _data.student.name;
    _finishTag.text = _data.delay?@"按时完成":@"未按时完成";
    [_avatarImage sd_setImageWithURL:[NSURL URLWithString: _data.student.faceImage] placeholderImage:[UIImage imageNamed:@"avatar-4"]];
    int i=0;
    CGFloat imgWidth = (SCREEN_WIDTH-40-15*2)/3;

    for(UIView *view in [self.imgStackView arrangedSubviews]){
//        [self.imgStackView removeArrangedSubview:view];
        [view removeFromSuperview];
    }
    for(NSString *str in self.data.imgs){
        UIImageView *photo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        [photo sd_setImageWithURL:[NSURL URLWithString:str]];
        photo.contentMode = UIViewContentModeScaleAspectFill;
        photo.clipsToBounds = YES;
        photo.tag=5000+i;
        //允许用户交互
        photo.userInteractionEnabled = YES;
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_tapPhoto:)];
        [photo addGestureRecognizer:tapGesture];
        [self.imgStackView addArrangedSubview:photo];
        [photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(imgWidth,imgWidth));
        }];
        i++;
    }
    if(self.data.imgs.count>0){
        while(i<3){
            [self.imgStackView addArrangedSubview:[ELPublishImage emptyItem:CGRectMake(0, 0, imgWidth, imgWidth)]];
            i++;
        }
    }

}

- (void)_tapPhoto:(UITapGestureRecognizer *)tapGesture{
    [[ELImageManager sharedManager]showImageView:[self.data.imgs objectAtIndex:tapGesture.view.tag-5000]];

}
- (void)setupSubviews{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).mas_offset(UIEdgeInsetsMake(10, 20, 20, 10));
    }];
    
    [self.bgView addSubview:self.avatarImage];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.bgView addSubview:self.studentLabel];
    [self.studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView).offset(5);
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
    }];
    
    [self.bgView addSubview:self.parentLabel];
    [self.parentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avatarImage).offset(-5);
        make.left.equalTo(self.studentLabel);
    }];
    
    [self.bgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImage.mas_bottom).offset(15);
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.imgStackView];
    CGFloat imgWidth = (SCREEN_WIDTH-40-15*2)/3;
    CGFloat height = 0;
    CGFloat offset=0;
    if(self.data.imgs.count!=0){
        offset = 10;
        self.imgStackView.alpha=1;
        height = imgWidth;
    }else{
        self.imgStackView.alpha=0;
        height=0;
    }
    [self.imgStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.detailLabel.mas_bottom).offset(offset);
        make.height.mas_equalTo(height);
    }];
    
    [self.bgView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgStackView.mas_bottom).offset(10);
        make.bottom.equalTo(self.bgView);
        make.left.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.finishTag];
    [self.finishTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel);
        make.left.equalTo(self.timeLabel.mas_right).offset(5);
    }];
    
}
#pragma mark - View
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIStackView *)imgStackView{
    if(!_imgStackView){
        CGFloat imgWidth = (self.bgView.bounds.size.width-40-15*2)/3;

        _imgStackView = [[UIStackView alloc]initWithFrame:CGRectMake(20,self.bgView.bounds.size.height-imgWidth-10, self.bgView.frame.size.width-40, imgWidth)];
        _imgStackView.spacing = 15;
        _imgStackView.distribution = UIStackViewDistributionFillEqually;
        _imgStackView.backgroundColor = [UIColor whiteColor];
    }
    return _imgStackView;
}

- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _avatarImage.contentMode = UIViewContentModeScaleToFill;
        _avatarImage.layer.cornerRadius = 25;
        _avatarImage.layer.masksToBounds = YES;
        
    }
    return _avatarImage;
}

- (UILabel *)studentLabel{
    if(!_studentLabel){
        _studentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _studentLabel.text = @"dd";
        _studentLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        _studentLabel.textColor = [UIColor blackColor];
        [_studentLabel sizeToFit];
    }
    return _studentLabel;
}

- (UILabel *)parentLabel{
    if(!_parentLabel){
        _parentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,50,20)];
        _parentLabel.text = [NSString stringWithFormat:@"%@%@",@"家长：",@"abc"];
        _parentLabel.font = [UIFont fontWithName:@"PingFangSC" size:16.f];
        _parentLabel.textColor = [UIColor grayColor];
        [_parentLabel sizeToFit];
    }
    return _parentLabel;
}

- (UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _timeLabel.font = [UIFont fontWithName:@"PingFangSC" size:14.f];
        _timeLabel.textColor = [UIColor grayColor];
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,100,20)];
        _detailLabel.font = [UIFont systemFontOfSize:18.f];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 3;
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

- (ELCustomLabel *)finishTag{
    if(!_finishTag){
        _finishTag =  [[ELCustomLabel alloc]init];
        _finishTag.backgroundColor = [UIColor clearColor];
        _finishTag.font = [UIFont systemFontOfSize:14.f];
        _finishTag.layer.cornerRadius = 5;
        _finishTag.layer.masksToBounds = YES;
        _finishTag.layer.borderWidth = 2;
        _finishTag.layer.borderColor = [UIColor redColor].CGColor;
        _finishTag.textAlignment = NSTextAlignmentCenter;
        [_finishTag setTextInsets:UIEdgeInsetsMake(3, 5, 3, 5)];
        [_finishTag sizeToFit];
        _finishTag.textColor = [UIColor orangeColor];
    }
    return _finishTag;
}

@end
