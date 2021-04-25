//
//  TeamDetailCard.h
//  EduLoop
//
//  Created by mijika on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "TeamModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface TeamDetailCard : UIView

@property (nonatomic, strong, readwrite) TeamModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,strong,readwrite) UILabel *codeLabel;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
- (void)loadData:(TeamModel *)data;
@end

NS_ASSUME_NONNULL_END
