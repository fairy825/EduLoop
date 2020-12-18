//
//  MineMiscCardTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2020/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineMiscCardTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *detail;
@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic) NSInteger index;
-(instancetype)initWithIndex:(int)index title:(NSString *)title detail:(NSString *)detail;
@end

NS_ASSUME_NONNULL_END
