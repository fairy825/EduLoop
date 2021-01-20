//
//  MessageRecordTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2021/1/13.
//


#import "MessageRecordTableViewCell.h"
#import "ELScreen.h"
@implementation MessageRecordTableViewCell
//必须配合loadData方法使用
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)rect data:(MessageModel *)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageModel = model;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width, self.frame.size.height);
       // [self loadData];
    }
    return self;
}

- (void)setupView{
    self.bubble = [[MessageBubble alloc]initWithFrame:CGRectZero message:self.messageModel.messageStr isLeft:self.isFrom];
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.bubble];
    self.avatarImage.image =[UIImage imageNamed: self.messageModel.avatar];
    self.bubble.frame = CGRectMake(self.avatarImage.frame.origin.x+self.avatarImage.frame.size.width+10, self.avatarImage.frame.origin.y, self.bubble.frame.size.width, self.bubble.frame.size.height);
    if(!self.isFrom){
        self.avatarImage.frame = CGRectMake(self.contentView.bounds.size.width-10-40, 10, 40, 40);
        self.bubble.frame = CGRectMake(self.avatarImage.frame.origin.x-10-self.bubble.frame.size.width, self.avatarImage.frame.origin.y,self.bubble.frame.size.width,self.bubble.frame.size.height );
    }
}
//每一次数据变更
- (void)loadData{
    self.isFrom = [self.messageModel.toName isEqual:@"dd"];
    self.avatarImage.image =[UIImage imageNamed: self.messageModel.avatar];
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
