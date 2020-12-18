//
//  UgcCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/18.
//

#import <UIKit/UIKit.h>
#import "AvatarCard.h"
#import "UgcModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UgcCard : UITableViewCell

@property (nonatomic, strong, readwrite) UgcModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIView *seperateView;
@property(nonatomic,strong,readwrite) UIButton *thumbButton;
@property(nonatomic,strong,readwrite) UIButton *commentButton;
@property(nonatomic,strong,readwrite) AvatarCard *avatarCard;
@property(nonatomic,strong,readwrite) UILabel *detailLabel;
//@property(nonatomic,weak,readwrite) id<HomeworkShowTableViewCellDelegate> delegate;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(UgcModel *)model;
@end

NS_ASSUME_NONNULL_END
