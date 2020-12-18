//
//  MineInfoCard.h
//  EduLoop
//
//  Created by mijika on 2020/12/2.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface MineInfoCard : UIView
@property(nonatomic,strong,readwrite) UIImageView *avatarView;
@property(nonatomic,strong,readwrite) UIView *identityTag;
@property(nonatomic,strong,readwrite) UILabel *nameLabel;
@property(nonatomic,strong,readwrite) UILabel *schoolLabel;
@property(nonatomic,strong,readwrite) UILabel *gradeLabel;
@property(nonatomic,strong,readwrite) UIImageView *arrowImage;

@end

NS_ASSUME_NONNULL_END
