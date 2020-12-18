//
//  ELStackCardItem.m
//  EduLoop
//
//  Created by mijika on 2020/12/17.
//

#import "ELStackCardItem.h"
#import <Masonry/Masonry.h>
@implementation ELStackCardItem
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    [self addSubview:self.subTitleLabel];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel).offset(20);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
}
- (UICollectionView *)collectionView{
    if(!_collectionView){
        //先设置layout用于生成collectionview的布局信息
           UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
           layout.minimumInteritemSpacing=10;
           layout.minimumLineSpacing=20;
           layout.itemSize = CGSizeMake(100, 20);

         //创建UICollectionView
           _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];

         //再注册cell
           [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}
- (UILabel *)subTitleLabel{
    if(!_subTitleLabel){
        _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _subTitleLabel.font = [UIFont fontWithName:@"PingFangSC" size:20.f];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.backgroundColor = [UIColor redColor];
        [_subTitleLabel sizeToFit];
    }
    return _subTitleLabel;
}
@end
