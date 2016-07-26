//
//  CoreDataLib.h
//  CoreDataTest
//
//  Created by baolicheng on 16/7/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataLib : NSObject
+(instancetype)shareInstance;

-(void)saveObject:(id)obj completion:(void (^)(BOOL result, NSError *error))completion;

-(void)updateObject:(id)obj withPredicate:(NSPredicate *)predicate completion:(void (^ )(BOOL result, NSError *error))completion;

-(void)selectObjects:(Class)objClass sort:(NSArray *)sortDescriptors completion:(void (^)(NSArray *result, NSError *error))completion;

-(void)deleteObjects:(Class)objClass withPredicate:(NSPredicate *)predicate completion:(void (^)(BOOL result, NSError *error))completion;

-(void)copyAllPropertyValueFrom:(id)obj to:(id)relationObj;
@end
