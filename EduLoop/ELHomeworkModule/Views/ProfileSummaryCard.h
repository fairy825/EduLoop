//
//  ProfileSummaryCard.h
//  EduLoop
//
//  Created by mijika on 2021/4/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileSummaryCard : UIView
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,strong,readwrite) UILabel *teamLabel;
@property(nonatomic,strong,readwrite) UILabel *nameLabel;
@end

NS_ASSUME_NONNULL_END
