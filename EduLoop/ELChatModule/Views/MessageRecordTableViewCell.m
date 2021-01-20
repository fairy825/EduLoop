//
//  MessageRecordTableViewCell.m
//  EduLoop
//
//  Created by mijika on 2021/1/13.
//


#import "MessageRecordTableViewCell.h"
#import "ELScreen.h"
@implementation MessageRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)rect data:(MessageModel *)model
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _messageModel = model;
        self.isFrom = [self.messageModel.toName isEqual:@"dd"];
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.width, self.frame.size.height);
        [self setupView];
        [self loadData];
    }
    return self;
}

- (void)setupView{
    self.bubble = [[MessageBubble alloc]initWithFrame:CGRectMake(self.avatarImage.frame.origin.x+self.avatarImage.frame.size.width+10, self.avatarImage.frame.origin.y, 200, 100)];
    [self.contentView addSubview:self.avatarImage];
    [self.contentView addSubview:self.bubble];
    
}

- (void)loadData{
    self.avatarImage.image =[UIImage imageNamed: self.messageModel.avatar];
    self.bubble.messageLabel.text = self.messageModel.messageStr;
    NSDictionary *attri = @{NSFontAttributeName: self.bubble.messageLabel.font};
    //自适应高度
    CGSize size = [self.bubble.messageLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH * 0.55, SCREEN_HEIGHT * 0.58) options:NSStringDrawingUsesLineFragmentOrigin attributes:attri context:nil].size;
    self.bubble.messageLabel.frame = CGRectMake(10,10, size.width, size.height);
    self.bubble.frame = CGRectMake(self.avatarImage.frame.origin.x+self.avatarImage.frame.size.width+10, self.avatarImage.frame.origin.y, size.width +20, size.height + 20);
    if(!self.isFrom){
        self.avatarImage.frame = CGRectMake(self.contentView.bounds.size.width-10-40, 10, 40, 40);
        self.bubble.frame = CGRectMake(self.avatarImage.frame.origin.x-10-self.bubble.frame.size.width, self.avatarImage.frame.origin.y, size.width +20, size.height + 20);
//        self.bubble.bgView.backgroundColor = [UIColor greenColor];
    }
}

- (UIImageView *)avatarImage{
    if(!_avatarImage){
        _avatarImage = [[UIImageView alloc]init];
        _avatarImage.frame = CGRectMake(10, 10, 40, 40);
    }
    return _avatarImage;
}

@end
