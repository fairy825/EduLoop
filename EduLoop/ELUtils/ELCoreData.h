//
//  ELCoreData.h
//  EduLoop
//
//  Created by mijika on 2021/6/23.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "../../Person+CoreDataClass.h"
NS_ASSUME_NONNULL_BEGIN

@interface ELCoreData : NSObject
@property(nonatomic,strong,readwrite) NSManagedObjectContext * context;
- (void)createSqlite;
- (void)insertClicked;
- (void)deleteClicked;
- (void)updateClicked;
- (void)readClicked;
@end

NS_ASSUME_NONNULL_END
