//
//  Person+CoreDataProperties.h
//  
//
//  Created by mijika on 2021/6/23.
//
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nonatomic) int16_t id;
@property (nullable, nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
