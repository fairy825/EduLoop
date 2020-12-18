//
//  ELStackCardItem.h
//  EduLoop
//
//  Created by mijika on 2020/12/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ELStackCardItem : UIView
@property(nonatomic,strong,readwrite) UILabel *subTitleLabel;
@property(nonatomic,strong,readwrite) UICollectionView *collectionView;
@property(nonatomic,strong,readwrite) NSArray<NSString *>*btnStrs;

@end

NS_ASSUME_NONNULL_END
