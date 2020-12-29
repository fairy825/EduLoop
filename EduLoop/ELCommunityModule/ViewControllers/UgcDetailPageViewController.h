//
//  UgcDetailPageViewController.h
//  EduLoop
//
//  Created by mijika on 2020/12/21.
//

#import <UIKit/UIKit.h>
#import "UgcCard.h"
#import "CommentEditView.h"
#import "CommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UgcDetailPageViewController : UIViewController

@property(nonatomic,strong,readwrite) UgcCard *summaryUgcCard;
@property(nonatomic,strong,readwrite) UITableView *commentTableView;
@property(nonatomic,strong,readwrite) CommentEditView *commentEditView;
@property(nonatomic,strong,readwrite) NSMutableArray<CommentModel *>* commentModels;
@property(nonatomic,strong,readwrite) UgcModel* ugcModel;
- (instancetype)initWithModel:(UgcModel *)model;
@end

NS_ASSUME_NONNULL_END
