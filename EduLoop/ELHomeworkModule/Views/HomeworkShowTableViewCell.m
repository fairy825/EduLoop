//
//  HomeworkShowTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import "HomeworkShowTableViewCell.h"
#import "UIColor+MyTheme.h"
#import <Masonry/Masonry.h>
#import "ELOverlay.h"
#import <SDWebImage.h>

@implementation HomeworkShowTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(JSONModel *)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _data = model;
        [self setupView];
        [self loadData];
//        [self addGestureRecognizer:({
//            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCell)];
//            recognizer;
//        })];
    }
    return self;
}

- (void)loadData{
    NSString *hintStr;
    UIColor *hintStrColor;
    if([_data isKindOfClass: TeacherTaskModel.class]){
        TeacherTaskModel *data = (TeacherTaskModel *)_data;
        _titleLabel.text = data.title;
        _detailLabel.text = data.content;
        _avatarCard.nameLabel.text=data.creatorName;
        _avatarCard.publishTimeLabel.text=data.timeDesc;
        [_avatarCard.avatarImage sd_setImageWithURL:[NSURL URLWithString:data.creatorAvatar] placeholderImage:[UIImage imageNamed:@"icon_teacher"]];
        hintStr=[NSString stringWithFormat:@"%@%ld/%ld",@"已提交",(long)data.realHomeworkNumber,(long)data.shouldHomeworkNumber];
       hintStrColor =[UIColor color555555];
       _otherButton.alpha = 0;
        _submitBtn.alpha=0;
    }else if([_data isKindOfClass: TaskModel.class]){
        TaskModel *data = (TaskModel *)_data;
        _titleLabel.text = data.title;
        _detailLabel.text = data.content;
        _avatarCard.nameLabel.text=data.creatorName;
        _avatarCard.publishTimeLabel.text=data.timeDesc;
        [_avatarCard.avatarImage sd_setImageWithURL:[NSURL URLWithString:data.creatorAvatar] placeholderImage:[UIImage imageNamed:@"icon_teacher"]];

         NSString *isFinish = data.finish;
        NSString *rightButtonTitle;
        UIColor *rightButtonColor;
       if([isFinish isEqual:@"FINISHED_AND_REVIEWED"]
            ||[isFinish isEqual:@"FINISHED_NOT_REVIEWED"]){
            if([isFinish isEqual:@"FINISHED_AND_REVIEWED"])
                rightButtonTitle=@"已批改";
            else if([isFinish isEqual:@"FINISHED_NOT_REVIEWED"])
                    rightButtonTitle=@"已完成未批改";
            rightButtonColor = [UIColor elColorWithHex:Color_finished];
            hintStr = @"点击查看作业详情";
            hintStrColor = [UIColor color999999];
//           [_submitBtn removeFromSuperview];
           _submitBtn.alpha=0;
           [self.submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
               make.width.mas_equalTo(@0);
           }];
        }else{
            hintStr = [NSString stringWithFormat:@"%@%@",@"作业提交截止时间为",data.endTime];
            hintStrColor = [UIColor elColorWithHex:Color_Red];
//            [_arrowImage removeFromSuperview];
            _arrowImage.alpha=0;

            if([isFinish isEqual:@"NOT_FINISH"]){
                rightButtonTitle=@"未完成";
                rightButtonColor = [UIColor elColorWithHex:Color_not_finished];
                _submitBtn.alpha = 1;
                [self.submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(@80);
                }];
            }
            else if([isFinish isEqual:@"DELAY_CAN_FINISH"]){
                rightButtonTitle=@"超时可提交";
                rightButtonColor = [UIColor elColorWithHex:Color_delay_can_finish];
                _submitBtn.alpha = 1;
                [self.submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(@80);
                }];
            }
            else if([isFinish isEqual:@"DELAY_CANNOT_FINISH"]){
                rightButtonTitle=@"超时不可提交";
                rightButtonColor = [UIColor elColorWithHex:Color_delay_cannot_finish];
//                [_submitBtn removeFromSuperview];
                _submitBtn.alpha = 0;
                [self.submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(@0);
                }];
            }
            if(data.delayAllowed){
                hintStr = [NSString stringWithFormat:@"%@%@",hintStr,@",允许延迟提交"];
            }
        }
        _otherButton.alpha = 1;
        _otherButton.text = rightButtonTitle;
        _otherButton.backgroundColor = rightButtonColor;
    }
    _hintLabel.text=hintStr;
    _hintLabel.textColor =hintStrColor;
}

- (void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.seperateView];
    [self.seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.height.equalTo(@10);
        make.width.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).mas_offset(UIEdgeInsetsMake(30, 20, 20, 20));
    }];
    
    [self.bgView addSubview:self.avatarCard];
    [self.avatarCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.height.equalTo(@60);
        make.width.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.otherButton];
    [self.otherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView);
        make.right.equalTo(self.bgView);
    }];
    
    [self.bgView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarCard.mas_bottom).offset(10);
        make.left.equalTo(self.avatarCard);
    }];
    
    [self.bgView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.titleLabel);
        make.width.equalTo(self.bgView);
        make.height.lessThanOrEqualTo(@70);
    }];
    
    [self.bgView addSubview:self.hintView];
    [self.hintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.bgView.mas_bottom);
        make.left.equalTo(self.detailLabel);
        make.width.equalTo(self.bgView);
//        make.height.lessThanOrEqualTo(@50);
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

- (UIView *)hintView{
    if(!_hintView){
        _hintView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 200)];
        _hintView.backgroundColor = [UIColor whiteColor];
        [self.hintView addSubview:self.arrowImage];
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.hintView.mas_centerY);
            make.right.equalTo(self.hintView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [self.hintView addSubview:self.submitBtn];
        [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.hintView.mas_centerY);
            make.right.equalTo(self.hintView);
            make.size.mas_equalTo(CGSizeMake(80, 20));
        }];
        
        [self.hintView addSubview:self.hintLabel];
        [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hintView);
            make.bottom.equalTo(self.hintView);
            make.left.equalTo(self.hintView);
            make.right.equalTo(self.submitBtn.mas_left).offset(-10);
        }];
       
    }
    return _hintView;
}

- (UIView *)seperateView{
    if(!_seperateView){
        _seperateView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 10)];
        _seperateView.backgroundColor = [UIColor f6f6f6];
    }
    return _seperateView;
}

- (UILabel *)hintLabel{
    if(!_hintLabel){
        _hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _hintLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16.f];
        _hintLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _hintLabel.textAlignment = NSTextAlignmentLeft;
        _hintLabel.numberOfLines = 0;
        [_hintLabel sizeToFit];
    }
    return _hintLabel;
}

- (UIImageView *)arrowImage{
    if(!_arrowImage){
        _arrowImage = [[UIImageView alloc]init];
        _arrowImage.image = [UIImage imageNamed:@"right_arrow_gray"];
        _arrowImage.contentMode = UIViewContentModeScaleToFill;
    }
    return _arrowImage;
}

- (AvatarCard *)avatarCard{
    if(!_avatarCard){
        _avatarCard = [[AvatarCard alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 70)];
    }
    return _avatarCard;
}

- (ELCustomLabel *)otherButton{
    if(!_otherButton){
        _otherButton =  [[ELCustomLabel alloc]init];
        _otherButton.backgroundColor = [UIColor clearColor];
        _otherButton.font = [UIFont systemFontOfSize:16.f];
        _otherButton.layer.cornerRadius = 10;
        _otherButton.layer.masksToBounds = YES;
        _otherButton.layer.borderWidth = 2;
        _otherButton.layer.borderColor = [UIColor whiteColor].CGColor;
        _otherButton.textAlignment = NSTextAlignmentCenter;
        [_otherButton setTextInsets:UIEdgeInsetsMake(3, 10, 3, 10)];
        [_otherButton sizeToFit];
//        _otherButton.text =@"...";
        _otherButton.textColor = [UIColor whiteColor];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickHomeworkMenu)];
        [_otherButton addGestureRecognizer:tapGesture];
    }
    return _otherButton;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18.f];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if(!_detailLabel){
        _detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,100,20)];
        _detailLabel.font = [UIFont systemFontOfSize:16.f];
        _detailLabel.textColor = [UIColor grayColor];
        _detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.numberOfLines = 2;
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

- (UIButton *)submitBtn{
    if(!_submitBtn){
        _submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
        [_submitBtn setTitleColor:[UIColor color5bb2ff] forState:UIControlStateNormal];
        [_submitBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:16]];
        [_submitBtn setTitle:@"提交作业" forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(clickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}


-(void)clickSubmitBtn{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickSubmitButtonTableViewCell:)]){
        [self.delegate clickSubmitButtonTableViewCell:self];
    }
}

-(void)clickHomeworkMenu{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(clickOtherButtonTableViewCell:)]){
        [self.delegate clickOtherButtonTableViewCell:self];
    }
}
@end
