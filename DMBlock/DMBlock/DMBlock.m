//
//  DMBlock.m
//  DMBlock
//
//  Created by leoliu on 2018/5/21.
//  Copyright © 2018年 leoliu. All rights reserved.
//

#import "DMBlock.h"
@interface DMBlock(){
    int(^_aBlock)(int);
}
@property (nonatomic, copy) NSString *hello;
@property (nonatomic, assign) BOOL isAssign;
@property (nonatomic, copy) int(^copyBlock)(int);
@end
@implementation DMBlock

//全局变量
int global_var = 4;

//静态全局变量
static int static_global_var = 5;

- (instancetype)init
{
    self = [super init];
    return self;
}

- (void)dm_method{
    //基本数据类型的局部变量
    int var = 1;
    
    //对象类型的局部变量
    __unsafe_unretained id unsafe_obj = nil;
    __strong id strong_obj = nil;
    
    //局部静态变量
    static int static_var = 3;
    void(^Block)(void) = ^{
        NSLog(@"局部变量<基本数据类型> var %d",var);
        NSLog(@"局部变量<__unsafe_unretained 对象类型> var %@",unsafe_obj);
        NSLog(@"局部变量<__strong 对象类型> var %@",strong_obj);
        NSLog(@"静态变量 %d",static_var);
        
        NSLog(@"全局变量 %d",global_var);
        
        NSLog(@"静态全局变量 %d",static_global_var);
    };
    
    Block();
    
    /*
     static int static_global_var = 5;
     
     
     struct __DMBlock__dm_method_block_impl_0 {
     struct __block_impl impl;
     struct __DMBlock__dm_method_block_desc_0* Desc;
     //截获局部变量的值
     int var;
     //连同所有权修饰符一起截活
     __unsafe_unretained id unsafe_obj;
     __strong id strong_obj;
     // 以指针形式截获局部变量
     int *static_var;
     //对全局变量、静态全局变量不截获
     
     __DMBlock__dm_method_block_impl_0(void *fp, struct __DMBlock__dm_method_block_desc_0 *desc, int _var, __unsafe_unretained id _unsafe_obj, __strong id _strong_obj, int *_static_var, int flags=0) : var(_var), unsafe_obj(_unsafe_obj), strong_obj(_strong_obj), static_var(_static_var) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
     }
     };
     */
}

- (void)dm_methodA{
    int multipler = 5;
    int(^Block)(int) = ^int(int num){
        return multipler * num;
    };
    multipler = 4;
    int result = Block(2);//10
    NSLog(@"%d",result);
    NSLog(@"%@", Block);
}

- (void)dm_methodB{
    static int multipler = 5;
    int(^Block)(int) = ^int(int num){
        return multipler * num;
    };
    multipler = 4;
    int result = Block(2);//8
    NSLog(@"%d",result);
}

- (void)dm_methodC{
    __block int multipler = 5;
    int(^Block)(int) = ^int(int num){
        return multipler * num;
    };
    multipler = 4;
    int result = Block(2);//8
    NSLog(@"%d",result);
}

- (void)dm_methodD{
    int(^Block)(int) = ^int(int num){
        return global_var * num;
    };
    global_var = 5;
    int result = Block(2);//8
    NSLog(@"%d",result);
}

- (void)dm_methodE
{
    __block int multipler = 1;
    int(^Block)(int) = ^int(int num){
        return multipler * num;
    };
    
    multipler = 2;
    int result1 = Block(1);//2
    NSLog(@"result1 = %d",result1);
    
//    _aBlock = Block;
    self.copyBlock = Block;
    
    multipler = 3;
    int result2 = Block(1);//3
    NSLog(@"result2 = %d",result2);
    
    int result3 = self.copyBlock(1);//3
    NSLog(@"result3 = %d",result3);
}

- (void)dm_methodF
{
    int multipler = 1;
    int(^Block)(int) = ^int(int num){
        NSLog(@"%@",self.isAssign);
        return multipler * num;
    };
    
    self.copyBlock = Block;
}

- (void)dm_methodG
{
    __block id tmp = self;
    int multipler = 1;
    int(^Block)(int) = ^int(int num){
        NSLog(@"%@",tmp);
        return multipler * num;
    };
    
    self.copyBlock = Block;
}

- (void)dm_methodH
{
    //编译报错
//    const char text[] = "hello";
    const char *text = "hello";
    void(^Block)(void) = ^{
        printf("%c\n",text[2]);
    };
    Block();
}

- (void)dm_methodI
{
    id obj = [self getBlockArray];
    typedef void(^blk_t)(void);
    blk_t blk = (blk_t)[obj objectAtIndex:0];
    blk();
}

- (void)dm_methodJ
{
    __block int val = 0;
    void(^blk)(void) = [^{++val;} copy];
    ++val;
    blk();
    NSLog(@"%tu",val);//2
}

- (void)dm_methodK
{
    typedef void(^blk_t)(id obj);
    blk_t  blk;
    {
        id array1 = [[NSMutableArray alloc] init];
        __weak __block id array = array1; //与 __weak id array = array1;效果相同
        blk = [^(id obj){
            [array addObject:obj];
            NSLog(@"array count = %tu",[array count]);
        } copy];
    }
    
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    blk([[NSObject alloc] init]);
    /*
     array count = 0
     array count = 0
     array count = 0
     */
}

- (id)getBlockArray
{
    int val = 10;
    
    typedef void(^blk_t)(void);
    
//    NSLog(@"aaa:%@",[[[NSArray alloc] initWithObjects:
//                  ^{NSLog(@"block0:%tu",val);},
//                  ^{NSLog(@"block1:%tu",val);}, nil] objectAtIndex:0]);
//    return [[NSArray alloc] initWithObjects:
//            ^{NSLog(@"block0:%tu",val);},
//            ^{NSLog(@"block1:%tu",val);}, nil];
    
    blk_t a = ^(){
       NSLog(@"block0:%tu",val);
    };

    blk_t b = ^(){
        NSLog(@"block0:%tu",val);
    };
    return [[NSArray alloc] initWithObjects:
            a,
            b, nil];
}


- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
