//
//  UgcTextImgCardTableViewCell.h
//  EduLoop
//
//  Created by mijika on 2020/12/21.
//

#import "UgcCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface UgcTextImgCard : UgcCard

@property(nonatomic,strong,readwrite) UIButton *thumbButton;
@property(nonatomic,strong,readwrite) UIButton *commentButton;
@property(nonatomic,strong,readwrite) UILabel *detailLabel;
@property(nonatomic,strong,readwrite) UIStackView *imgStackView;

@end

NS_ASSUME_NONNULL_END
