//
//  HomeworkCard.h
//  EduLoop
//
//  Created by mijika on 2021/3/30.
//

#import <UIKit/UIKit.h>
#import "HomeworkModel.h"
#import "ELCustomLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeworkCard : UIView
@property (nonatomic, strong, readwrite) HomeworkModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UIImageView *avatarImage;
@property(nonatomic,strong,readwrite) UILabel *detailLabel;
@property(nonatomic,strong,readwrite) UILabel *timeLabel;
@property(nonatomic,strong,readwrite) ELCustomLabel *finishTag;
@property(nonatomic,strong,readwrite) UILabel *studentLabel;
@property(nonatomic,strong,readwrite) UILabel *parentLabel;
- (void)loadData:(HomeworkModel *)data;
@end

NS_ASSUME_NONNULL_END
