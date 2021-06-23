//
//  ELCoreData.m
//  EduLoop
//
//  Created by mijika on 2021/6/23.
//

#import "ELCoreData.h"

@implementation ELCoreData
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createSqlite];
    }
    return self;
}
- (void)createSqlite{
    // 创建上下文对象，并发队列设置为主队列
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

    // 创建托管对象模型，并使用Company.momd路径当做初始化参数
    NSURL *modelPath = [[NSBundle mainBundle] URLForResource:@"ELModel" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelPath];

    // 创建持久化存储调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

    // 创建并关联SQLite数据库文件，如果已经存在则不会重复创建
    NSString *dataPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    dataPath = [dataPath stringByAppendingFormat:@"/%@.sqlite", @"coredata"];
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:dataPath] options:nil error:nil];

    // 上下文对象设置属性为持久化存储器
    context.persistentStoreCoordinator = coordinator;
    _context = context;
}


#pragma mark -- Event Handle

- (void)insertClicked{
    [self insertData];
}
- (void)deleteClicked{
    [self deleteData];
}
- (void)updateClicked{
    [self updateData];
}
- (void)readClicked{
    [self readData];
}


#pragma mark -- 数据处理

//插入数据
- (void)insertData{
    
    
    // 1.根据Entity名称和NSManagedObjectContext获取一个新的继承于NSManagedObject的子类Student
    
    Person * student = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Person"
                         inManagedObjectContext:_context];
    
    //  2.根据表Student中的键值，给NSManagedObject对象赋值
    student.name = [NSString stringWithFormat:@"Mr-%d",arc4random()%100];
//    student.id = 1;
    //查询所有数据的请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    NSLog(@"");
}

//删除
- (void)deleteData{
    
    //创建删除请求
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    //删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"id < %d", 10];
    deleRequest.predicate = pre;
    
    //返回需要删除的对象数组
    NSArray *deleArray = [_context executeFetchRequest:deleRequest error:nil];
    
    //从数据库中删除
    for (Person *stu in deleArray) {
        [_context deleteObject:stu];
    }
    
    //没有任何条件就是读取所有的数据
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    NSLog(@"");
    
}

//更新，修改
- (void)updateData{
    
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"id = %@", @"1"];
    request.predicate = pre;
    
    //发送请求
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    
    //修改
    for (Person *stu in resArray) {
        stu.name = @"且行且珍惜_iOS";
    }    
    
}

//读取查询
- (void)readData{
    
    
    /* 谓词的条件指令
     1.比较运算符 > 、< 、== 、>= 、<= 、!=
     例：@"number >= 99"
     
     2.范围运算符：IN 、BETWEEN
     例：@"number BETWEEN {1,5}"
     @"address IN {'shanghai','nanjing'}"
     
     3.字符串本身:SELF
     例：@"SELF == 'APPLE'"
     
     4.字符串相关：BEGINSWITH、ENDSWITH、CONTAINS
     例：  @"name CONTAIN[cd] 'ang'"  //包含某个字符串
     @"name BEGINSWITH[c] 'sh'"    //以某个字符串开头
     @"name ENDSWITH[d] 'ang'"    //以某个字符串结束
     
     5.通配符：LIKE
     例：@"name LIKE[cd] '*er*'"   //*代表通配符,Like也接受[cd].
     @"name LIKE[cd] '???er*'"
     
     *注*: 星号 "*" : 代表0个或多个字符
     问号 "?" : 代表一个字符
     
     6.正则表达式：MATCHES
     例：NSString *regex = @"^A.+e$"; //以A开头，e结尾
     @"name MATCHES %@",regex
     
     注:[c]*不区分大小写 , [d]不区分发音符号即没有重音符号, [cd]既不区分大小写，也不区分发音符号。
     
     7. 合计操作
     ANY，SOME：指定下列表达式中的任意元素。比如，ANY children.age < 18。
     ALL：指定下列表达式中的所有元素。比如，ALL children.age < 18。
     NONE：指定下列表达式中没有的元素。比如，NONE children.age < 18。它在逻辑上等于NOT (ANY ...)。
     IN：等于SQL的IN操作，左边的表达必须出现在右边指定的集合中。比如，name IN { 'Ben', 'Melissa', 'Nick' }。
     
     提示:
     1. 谓词中的匹配指令关键字通常使用大写字母
     2. 谓词中可以使用格式字符串
     3. 如果通过对象的key
     path指定匹配条件，需要使用%K
     
     */
    
    
    //创建查询请求
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Student"];
    
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"sex = %@", @"美女"];
    request.predicate = pre;
    
    
    // 从第几页开始显示
    // 通过这个属性实现分页
    //request.fetchOffset = 0;
    
    // 每页显示多少条数据
    //request.fetchLimit = 6;
  
    
    //发送查询请求,并返回结果
    NSArray *resArray = [_context executeFetchRequest:request error:nil];
    
    
}


@end
