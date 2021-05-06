//
//  MessageRecordTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2021/1/13.
//


#import "MessageRecordTableViewCell.h"
#import "ELScreen.h"
#import <Masonry/Masonry.h>
#import <SDWebImage.h>
#import "ELUserInfo.h"
@implementation MessageRecordTableViewCell
//必须配合loadData方法使用
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)rect data:(MessageModel *)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageModel = model;
       // [self loadData];
    }
    return self;
}

- (void)setupView{
    self.bubble = [[MessageBubble alloc]initWithFrame:CGRectZero message:self.messageModel.messageStr isLeft:self.isFrom];
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.bubble];
    self.avatarImage.frame = CGRectMake(10, 10, 40, 40);

    self.bubble.frame = CGRectMake(self.avatarImage.frame.origin.x+self.avatarImage.frame.size.width+10, self.avatarImage.frame.origin.y, self.bubble.frame.size.width, self.bubble.frame.size.height);
    if(!self.isFrom){
        self.avatarImage.frame = CGRectMake(SCREEN_WIDTH-10-40, 10, 40, 40);
        self.bubble.frame = CGRectMake(self.avatarImage.frame.origin.x-10-self.bubble.frame.size.width, self.avatarImage.frame.origin.y,self.bubble.frame.size.width,self.bubble.frame.size.height );
    }
    
    [self.bubble mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView).offset(-20);
        make.left.mas_equalTo(self.contentView).offset(self.bubble.frame.origin.x);
        make.size.mas_equalTo(self.bubble.frame.size);
    }];
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bubble);
        make.left.mas_equalTo(self.contentView).offset(self.avatarImage.frame.origin.x);
        make.size.mas_equalTo(self.avatarImage.frame.size);
    }];
}

//每一次数据变更
- (void)loadData{
    self.isFrom = self.messageModel.toId ==[ELUserInfo sharedUser].id;
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString: self.messageModel.avatar] placeholderImage:[UIImage imageNamed:@"avatar-4"]];
    [self setupView];
}

- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]init];
        _avatarImage.frame = CGRectMake(10, 10, 40, 40);
    }
    return _avatarImage;
}
@end
