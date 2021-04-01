//
//  ReviewViewController.h
//  EduLoop
//
//  Created by mijika on 2021/3/30.
//

#import <UIKit/UIKit.h>
#import "HomeworkModel.h"
#import "ReviewModel.h"
#import "HomeworkCard.h"
#import "ReviewCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReviewViewController : UIViewController
@property(nonatomic,strong,readwrite) HomeworkModel *homework;
@property(nonatomic,strong,readwrite) ReviewModel *review;
@property(nonatomic,strong,readwrite) UIScrollView *scrollView;
@property(nonatomic,strong,readwrite) HomeworkCard *homeworkCard;
@property(nonatomic,strong,readwrite) UIView *separateView;
@property(nonatomic,strong,readwrite) ReviewCard *reviewCard;
@property(nonatomic,strong,readwrite) UIButton *reviewBtn;
@property(nonatomic,strong,readwrite) UITextField *scoreField;
@property(nonatomic,strong,readwrite) UITextView *detailTextView;
- (instancetype)initWithHomeworkModel:(HomeworkModel *)model;
@end

NS_ASSUME_NONNULL_END
