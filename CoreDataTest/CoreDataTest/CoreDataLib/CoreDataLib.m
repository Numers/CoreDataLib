//
//  CoreDataLib.m
//  CoreDataTest
//
//  Created by baolicheng on 16/7/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "CoreDataLib.h"
#import "AppDelegate.h"

#import <objc/runtime.h>
#import <objc/message.h>

static AppDelegate *appDelegate;
@implementation CoreDataLib
+(instancetype)shareInstance
{
    static CoreDataLib *coreDataLib = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataLib = [[CoreDataLib alloc] init];
        appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    });
    return coreDataLib;
}

-(void)saveObject:(id)obj completion:(void (^)(BOOL result, NSError *error))completion
{
    const char *name = class_getName([obj class]);
    NSString *voName = [NSString stringWithUTF8String:name];
    NSString *entityClassName = [voName substringToIndex:voName.length - 2];
    id relationObj = (id)[NSEntityDescription insertNewObjectForEntityForName:entityClassName inManagedObjectContext:appDelegate.managedObjectContext];
    [self copyAllPropertyValueFrom:obj to:relationObj];
    NSError *error;
    BOOL result = [appDelegate.managedObjectContext save:&error];
    completion(result, error);
}

-(void)updateObject:(id)obj withPredicate:(NSPredicate *)predicate completion:(void (^)(BOOL result, NSError *error))completion
{
    const char *name = class_getName([obj class]);
    NSString *voName = [NSString stringWithUTF8String:name];
    NSString *entityClassName = [voName substringToIndex:voName.length - 2];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityClassName inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entityDescription];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error;
    NSArray *fetchResult = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResult == nil) {
        completion(NO, error);
        return;
    }
    
    for (id relationObj in fetchResult) {
        [self copyAllPropertyValueFrom:obj to:relationObj];
    }
    
    BOOL result = [appDelegate.managedObjectContext save:&error];
    completion(result,error);
}

-(void)selectObjects:(Class)objClass sort:(NSArray *)sortDescriptors completion:(void (^)(NSArray *result, NSError *error))completion
{
    const char *name = class_getName(objClass);
    NSString *voName = [NSString stringWithUTF8String:name];
    NSString *entityClassName = [voName substringToIndex:voName.length - 2];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityClassName inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entityDescription];
    
    if (sortDescriptors && sortDescriptors.count > 0) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    NSError *error;
    NSArray *fetchResult = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    completion(fetchResult, error);
}

-(void)deleteObjects:(Class)objClass withPredicate:(NSPredicate *)predicate completion:(void (^)(BOOL result, NSError *error))completion
{
    const char *name = class_getName(objClass);
    NSString *voName = [NSString stringWithUTF8String:name];
    NSString *entityClassName = [voName substringToIndex:voName.length - 2];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityClassName inManagedObjectContext:appDelegate.managedObjectContext];
    [request setEntity:entityDescription];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error;
    NSArray *fetchResult = [appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchResult == nil) {
        if (error != nil) {
            completion(NO, error);
        }else{
            completion(YES,error);
        }
        return;
    }
    
    for (id relationObj in fetchResult) {
        [appDelegate.managedObjectContext deleteObject:relationObj];
    }
    
    BOOL result = [appDelegate.managedObjectContext save:&error];
    completion(result, error);
}

-(void)copyAllPropertyValueFrom:(id)obj to:(id)relationObj
{
    NSString *entityClassName, *relationClassName;
    const char *name = class_getName([obj class]);
    NSString *objName = [NSString stringWithUTF8String:name];
    
    const char *relationName = class_getName([relationObj class]);
    NSString *relationObjName = [NSString stringWithUTF8String:relationName];

    if (objName.length == relationObjName.length - 2) {
        entityClassName = objName;
        relationClassName = [relationObjName substringToIndex:relationObjName.length - 2];
    }else if(objName.length == relationObjName.length + 2){
        entityClassName = relationObjName;
        relationClassName = [objName substringToIndex:objName.length - 2];
    }
    if ([entityClassName isEqualToString:relationClassName]) {
        unsigned int proCount;
        objc_property_t *properties = class_copyPropertyList([relationObj class], &proCount);
        for (int i = 0; i < proCount; i++) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *keyPath = [NSString stringWithUTF8String:propertyName];
            id value = [obj valueForKeyPath:keyPath];
            
            [relationObj setValue:value forKeyPath:keyPath];
            
            //            NSString *capStrForKey = [keyPath capitalizedString];
            //            SEL setMethod = NSSelectorFromString([NSString stringWithFormat:@"set%@:",capStrForKey]);
            //            objc_msgSend(relationObj, setMethod,value);
        }
    }
}
@end
