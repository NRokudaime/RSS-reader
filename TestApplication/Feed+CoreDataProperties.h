//
//  Feed+CoreDataProperties.h
//  
//
//  Created by NRokudaime on 20.05.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Feed.h"

NS_ASSUME_NONNULL_BEGIN

@interface Feed (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *link;
@property (nullable, nonatomic, retain) NSString *feed_description;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) Chanels *connect;

@end

NS_ASSUME_NONNULL_END
