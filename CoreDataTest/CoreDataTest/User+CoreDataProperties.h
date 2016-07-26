//
//  User+CoreDataProperties.h
//  CoreDataTest
//
//  Created by baolicheng on 16/7/26.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *sex;

@end

NS_ASSUME_NONNULL_END
