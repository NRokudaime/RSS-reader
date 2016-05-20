//
//  ListViewController.h
//  TestApplication
//
//  Created by NRokudaime on 17.05.16.
//  Copyright © 2016 NRokudaime. All rights reserved.
//

#import "BaseViewController.h"
#import "Chanels+CoreDataProperties.h"
#import "Feed+CoreDataProperties.h"
#import "AppDelegate.h"

@interface ListViewController : BaseViewController<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *mainTable;
    IBOutlet UITextField *linkNew;
    IBOutlet UIView *addView;
    IBOutlet UITextField *nameNew;
    NSMutableArray *feed;
    NSXMLParser *parser;
    NSString *currentChanel;
    AppDelegate *appDelegate;
}

-(void)setChanel:(NSString *)chanel;
@end
