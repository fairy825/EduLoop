//
//  AvatarCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AvatarCard : UIView
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,strong,readwrite) UILabel *publishTimeLabel;
@property(nonatomic,strong,readwrite) UILabel *nameLabel;
@end

NS_ASSUME_NONNULL_END
