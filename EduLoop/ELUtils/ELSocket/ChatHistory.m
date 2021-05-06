//
//  ChatHistory.m
//  EduLoop
//
//  Created by mijika on 2021/4/29.
//

#import "ChatHistory.h"

@implementation ChatHistory

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
    [aCoder encodeObject:_flag forKey:@"flag"];
    [aCoder encodeObject:_chatMsg forKey:@"chatMsg"];
    [aCoder encodeObject:_myId forKey:@"myId"];
    [aCoder encodeObject:_friendId forKey:@"friendId"];
}

- (id)initWithCoder:(NSCoder*)aDecoder

{
    
    if (self = [super init]) {
        _myId = [aDecoder decodeObjectForKey:@"myId"];
        _friendId = [aDecoder decodeObjectForKey:@"friendId"];
        _chatMsg = [aDecoder decodeObjectForKey:@"chatMsg"];
        _flag = [aDecoder decodeObjectForKey:@"flag"];
    }
    
    return self;
    
}
@end
