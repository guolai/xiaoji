//
//  CoreDataManager.h
//  WidgetPush
//
//  Created by Marin on 9/1/11.
//  Copyright (c) 2011 mneorr.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject


@property (readonly, nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (readonly, nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (readonly, nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (retain, nonatomic) NSString *databaseName;
@property (retain, nonatomic) NSString *modelName;

+ (id)instance;
- (BOOL)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
