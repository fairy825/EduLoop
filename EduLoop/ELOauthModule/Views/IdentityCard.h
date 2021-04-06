//
//  IdentityCard.h
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import <UIKit/UIKit.h>
#import <DLRadioButton.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, UserIdentityType)
{
    USER_IDENTITY_PARENT,
    USER_IDENTITY_TEACHER,
};
@protocol IdentityCardProtocol;

@interface IdentityCard : UIView
@property(nonatomic,readwrite) UserIdentityType identity;
@property(nonatomic,strong,readwrite) UIImageView *imageView;
@property(nonatomic,strong,readwrite) UILabel *detailLabel;
@property(nonatomic,strong,readwrite) DLRadioButton *radioBtn;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,weak,readwrite) id<IdentityCardProtocol> delegate;

- (instancetype)initWithFrame:(CGRect)frame Type:(UserIdentityType) identity;
@end

@protocol IdentityCardProtocol <NSObject>

- (void)clickIdentityCard:(IdentityCard *)card;

@end
NS_ASSUME_NONNULL_END
