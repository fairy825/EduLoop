//
//  SettingDataView.h
//  EduLoop
//
//  Created by mijika on 2020/12/8.
//

#import <UIKit/UIKit.h>
#import <PGDatePicker/PGDatePickManager.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, SettingTableViewCellType)
{
    SettingTableViewCellType_Text,           // 仅仅包含文本
    SettingTableViewCellType_InlineTextField,
    SettingTableViewCellType_BigTextField,
    SettingTableViewCellType_Image,          // 文件+image
    SettingTableViewCellType_Switch,
    SettingTableViewCellType_Date,
    SettingTableViewCellType_Choices,
};

@protocol SettingDataTableViewCellDelegate<NSObject>
-(void)settingDataTableViewCell:(UITableViewCell *)cell ;
@end

@interface SettingDataModel : NSObject
@property (nonatomic, assign) SettingTableViewCellType accessoryType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, copy) NSString *detailDefaultText;
@property (nonatomic,readwrite) int maxLength;

@property (nonatomic, copy) NSString *aChoiceText;
@property (nonatomic, copy) NSString *bChoiceText;

@property (nonatomic, copy) NSString *avatarImageUrl;
@property (nonatomic, strong) UIImage *defaultAvatarImage;

// 是否显示箭头，默认为YES
@property (nonatomic, assign) BOOL showArrow;

// 是否switch开，默认为YES
@property (nonatomic, assign) BOOL switchOpen;
@property(nonatomic,copy,readwrite) dispatch_block_t clickBlock;

@end

@interface SettingDataTableViewCell : UITableViewCell
@property (nonatomic, strong, readwrite) SettingDataModel *data;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *subtitleLabel;
@property (nonatomic, strong, readwrite) UILabel *detailLabel;
@property (nonatomic, strong, readwrite) UITextField *detailTextfield;
@property (nonatomic, strong, readwrite) UITextView *detailTextView;
@property (nonatomic, strong, readwrite) UILabel *detailTextViewLengthLabel;

@property(nonatomic,strong,readwrite) UITextField *aTextField;
@property(nonatomic,strong,readwrite) UITextField *bTextField;

@property (nonatomic, strong, readwrite) UISwitch *aSwitch;
@property (nonatomic, strong, readwrite) PGDatePicker *datePicker;
@property (nonatomic, strong, readwrite) UIImageView *arrowImage;
@property(nonatomic,strong,readwrite) UIImageView *avatarView;
@property(nonatomic,weak,readwrite) id<SettingDataTableViewCellDelegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier data:(SettingDataModel *)model;
- (void)loadData;
@end
NS_ASSUME_NONNULL_END
