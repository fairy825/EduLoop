//
//  Person+CoreDataProperties.m
//  
//
//  Created by mijika on 2021/6/23.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Person"];
}

@dynamic id;
@dynamic name;

@end
