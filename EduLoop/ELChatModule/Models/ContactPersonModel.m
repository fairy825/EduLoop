//
//  ContactPerson.m
//  EduLoop
//
//  Created by mijika on 2021/1/5.
//

#import "ContactPersonModel.h"

@implementation ContactPersonModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)appInfoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
+ (NSArray *)appinfoArrayWithArray:(NSArray *)arr
{
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (NSDictionary *dict in arr) {
        [arrayM addObject:[self appInfoWithDict:dict]];
    }
    return arrayM;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_id forKey:@"id"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_nickname forKey:@"nickname"];
    [aCoder encodeObject:_identity forKey:@"identity"];
    [aCoder encodeObject:_symbol forKey:@"symbol"];
    [aCoder encodeObject:_avatar forKey:@"avatar"];
}

- (id)initWithCoder:(NSCoder*)aDecoder

{
    
    if (self = [super init]) {
        _id = [aDecoder decodeObjectForKey:@"id"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _nickname = [aDecoder decodeObjectForKey:@"nickname"];
        _identity = [aDecoder decodeObjectForKey:@"identity"];
        _symbol = [aDecoder decodeObjectForKey:@"symbol"];
        _avatar = [aDecoder decodeObjectForKey:@"avatar"];
    }
    
    return self;
    
}
@end
