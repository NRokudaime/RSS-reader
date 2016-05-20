//
//  Chanels+CoreDataProperties.h
//  
//
//  Created by NRokudaime on 20.05.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Chanels.h"

NS_ASSUME_NONNULL_BEGIN

@interface Chanels (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSSet<Feed *> *connect;

@end

@interface Chanels (CoreDataGeneratedAccessors)

- (void)addConnectObject:(Feed *)value;
- (void)removeConnectObject:(Feed *)value;
- (void)addConnect:(NSSet<Feed *> *)values;
- (void)removeConnect:(NSSet<Feed *> *)values;

@end

NS_ASSUME_NONNULL_END
