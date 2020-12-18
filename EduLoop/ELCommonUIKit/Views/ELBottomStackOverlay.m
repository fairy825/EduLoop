//
//  ELBottomStackOverlay.m
//  EduLoop
//
//  Created by mijika on 2020/12/17.
//

#import "ELBottomStackOverlay.h"
#import <Masonry/Masonry.h>
#import "UIColor+EHTheme.h"
#import "ELStackCardItem.h"
@interface ELBottomStackOverlay()<UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation ELBottomStackOverlay
- (void)showHighlightView{
    [self showHighlightViewFromPoint:CGPointMake(0,self.coverHeight) ToPoint:CGPointMake(self.coverWidth/2,self.coverHeight-self.container.bounds.size.height/2) Animation:YES];
}

- (void)showHighlightViewFromPoint:(CGPoint) point ToPoint:(CGPoint) point2 Animation:(BOOL)animated{
    if(animated){
        self.container.frame = CGRectMake(point.x, point.y,  self.coverWidth,self.coverHeight*2/3);
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        [UIView animateWithDuration:1.f delay:0.f usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.container.center = point2;

        } completion:nil];
    }else{
        [UIApplication.sharedApplication.windows.lastObject addSubview:self];
        self.container.center = point2;
    }
}
- (instancetype)initWithFrame:(CGRect)frame Data:(NSDictionary *)data SubTitles:(NSArray *)subtitles{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self = [super initWithFrame:screenRect];
    if (self) {
        self.coverWidth = screenWidth;
        self.coverHeight = screenHeight;
        _dic = data;
        _subTitles = subtitles;
        [self setUpSubviews];
    }
    return self;
}

- (void)setUpSubviews{
    [self layoutContainer];
    [self addSubview:self.backgroundView];
    [self addSubview:self.container];
}

- (UIView *)container{
    if(!_container){
        _container = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.coverWidth,self.coverHeight*2/3)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_container.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(25, 25)];

        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = _container.bounds;
        maskLayer.path = maskPath.CGPath;
        _container.layer.mask = maskLayer;
        _container.backgroundColor = [UIColor whiteColor];
    }
    return _container;
}

- (UIView *)innerContainer{
    if(!_innerContainer){
        _innerContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.coverWidth,400)];
    }
    return _innerContainer;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,100,20)];
        _titleLabel.text = @"年级";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22.f];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (void)layoutContainer{
    [self.container addSubview:self.innerContainer];
    [self.innerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container).mas_offset(UIEdgeInsetsMake(30, 20, 20, 20));
    }];
    
    [self.innerContainer addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.innerContainer);
        make.left.equalTo(self.innerContainer);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [self scanDictionary];
}
- (void)scanDictionary{
    UIStackView * stack = [UIStackView new];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.alignment = UIStackViewAlignmentFill;
    stack.distribution = UIStackViewDistributionFillEqually;
    for(int i=0;i< _dic.count;i++){
        NSString * subTitle = [_subTitles objectAtIndex:i];
        ELStackCardItem *item = [[ELStackCardItem alloc]initWithFrame: CGRectMake(0, 0, self.innerContainer.bounds.size.width, 300)];
        item.subTitleLabel.text = subTitle;
        
        item.collectionView.dataSource = self;
        item.collectionView.delegate = self;
        [stack addArrangedSubview:item];
    }
    [self.innerContainer addSubview:stack];
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.titleLabel);
        make.width.equalTo(self.innerContainer);
        make.bottom.equalTo(self.innerContainer);
    }];
}

//UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
//    [_dic objectForKey:[_subTitles objectAtIndex:idx]].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
    
//            for(NSString *str in btnStrs){
//                UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 20)];
//                btn.backgroundColor = [UIColor eh_999999];
//                [btn setTitle:str forState:UIControlStateNormal];
//                [btn setTitleColor:[UIColor eh_333333] forState:UIControlStateNormal];
//                [btn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC" size:18]];
//                btn.layer.cornerRadius = 10;
//                btn.layer.masksToBounds = YES;
 //            [btn addTarget:self action:@selector(clickHomeworkMenu) forControlEvents:UIControlEventTouchUpInside];
//                    [stack addArrangedSubview:btn];
//            }
    return cell;
}

//UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
       return  CGSizeMake(100, 30);
    
}


@end
