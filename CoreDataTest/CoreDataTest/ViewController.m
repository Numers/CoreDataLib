//
//  ViewController.m
//  CoreDataTest
//
//  Created by baolicheng on 16/7/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "ViewController.h"
#import "UserVo.h"
#import "CoreDataLib.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UserVo *user = [[UserVo alloc] init];
    [user setValue:@"aa" forKeyPath:@"name"];
    [user setValue:@"男" forKeyPath:@"sex"];
    [user setValue:@(15) forKeyPath:@"age"];
    [[CoreDataLib shareInstance] saveObject:user completion:^(BOOL result, NSError *error) {
        if (result) {
            NSLog(@"保存%@成功",user.name);
        }else{
            NSLog(@"保存%@失败, 原因:%@",user.name,error);
        }
    }];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [[CoreDataLib shareInstance] selectObjects:[UserVo class] sort:sortDescriptors completion:^(NSArray *result, NSError *error) {
        for (id obj in result) {
            UserVo *userVo = [[UserVo alloc] init];
            [[CoreDataLib shareInstance] copyAllPropertyValueFrom:obj to:userVo];
            NSLog(@"%@",userVo);
            
        }
    }];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == 'aa'"];
    user.age = @(18);
    [[CoreDataLib shareInstance] updateObject:user withPredicate:predicate completion:^(BOOL result, NSError *error) {
        if (result) {
            NSLog(@"修改%@成功",user.name);
        }else{
            NSLog(@"修改%@失败, 原因:%@",user.name,error);
        }
    }];
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors1 = [NSArray arrayWithObject:sortDescriptor1];
    [[CoreDataLib shareInstance] selectObjects:[UserVo class] sort:sortDescriptors1 completion:^(NSArray *result, NSError *error) {
        NSLog(@"%@",result);
    }];
    
    [[CoreDataLib shareInstance] deleteObjects:[UserVo class] withPredicate:predicate completion:^(BOOL result, NSError *error) {
        if (result) {
            NSLog(@"删除aa成功");
        }else{
            NSLog(@"修改aa失败, 原因:%@",error);
        }
    }];
    
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors2 = [NSArray arrayWithObject:sortDescriptor2];
    [[CoreDataLib shareInstance] selectObjects:[UserVo class] sort:sortDescriptors2 completion:^(NSArray *result, NSError *error) {
        NSLog(@"%@",result);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
