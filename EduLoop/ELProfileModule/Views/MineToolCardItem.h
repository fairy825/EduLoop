//
//  MineToolCardItem.h
//  EduLoop
//
//  Created by mijika on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineToolCardItem : UIView

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic) int index;
- (instancetype)initWithTitle:(NSString *)title icon:(NSString *)icon index:(int)index;
+ (instancetype)emptyItem;
@end

NS_ASSUME_NONNULL_END
