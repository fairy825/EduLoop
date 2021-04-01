//
//  ReviewCard.h
//  EduLoop
//
//  Created by mijika on 2021/3/30.
//

#import <UIKit/UIKit.h>
#import "ReviewModel.h"
#import "ELBottomView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol ReviewCardDelegate;

@interface ReviewCard : UIView
@property (nonatomic, strong, readwrite) ReviewModel *data;
@property(nonatomic,strong,readwrite) UIView *bgView;
@property(nonatomic,strong,readwrite) UILabel *detailLabel;
@property(nonatomic,strong,readwrite) UILabel *teacherLabel;
@property(nonatomic,strong,readwrite) UILabel *scoreLabel;
@property(nonatomic,strong,readwrite) UIButton *updateButton;
@property(nonatomic,weak,readwrite) id<ReviewCardDelegate> delegate;

- (void)loadData:(ReviewModel *)data;
@end

@protocol ReviewCardDelegate<NSObject>
-(void)clickUpdateBtn:(ReviewCard *)reviewCard ;
@end
NS_ASSUME_NONNULL_END
