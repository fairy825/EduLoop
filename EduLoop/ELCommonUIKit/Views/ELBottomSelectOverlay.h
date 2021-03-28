//
//  ELBottomSelectOverlay.h
//  EduLoop
//
//  Created by mijika on 2021/3/23.
//

#import <UIKit/UIKit.h>
#import "ELOverlay.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ELBottomSelectOverlayDelegate<NSObject>
@optional
-(void)updateChosedTeams:(int)idx Add:(BOOL)isAdd;
@end

@interface ELBottomSelectOverlay : ELBottomOverlay
@property(nonatomic,strong,readwrite) NSString *title;
@property(nonatomic,strong,readwrite) NSArray *subTitles;
@property(nonatomic,strong,readwrite) UIView *container;
@property(nonatomic,strong,readwrite) UIView *innerContainer;
@property(nonatomic,strong,readwrite) UITableView *tableView;
@property(nonatomic,strong,readwrite) UILabel *titleLabel;
@property(nonatomic,weak,readwrite) id<ELBottomSelectOverlayDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title;
- (void)reload;
@end

NS_ASSUME_NONNULL_END
