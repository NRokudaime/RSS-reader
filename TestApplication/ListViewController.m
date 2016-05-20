//
//  ListViewController.m
//  TestApplication
//
//  Created by NRokudaime on 17.05.16.
//  Copyright © 2016 NRokudaime. All rights reserved.
//

#import "ListViewController.h"
#import "ObjectViewController.h"
#import "ListViewCell.h"
#import "AppDelegate.h"
@interface ListViewController()
{
    NSDateFormatter *dateFormatter;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *link;
    NSMutableString *description;
    NSString *element;
    NSMutableString *date;
}
@end

@implementation ListViewController
static NSString *cellIdentifier = @"ListViewCell";
static NSString *itemStatic = @"item";
static NSString *titleStatic = @"title";
static NSString *linkStatic = @"link";
static NSString *descriptionStatic = @"description";
static NSString *dateStatic = @"pubDate";

-(void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.title = @"Список";
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
    feed = [NSMutableArray array];
    if (currentChanel)
    {
        parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:currentChanel]];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:false];
        if (![parser parse])
        {
            [self populateChanels];
        }
    }
    else
    {
        [self setupChanels];
        [self loadChanelData];
    }
    [self showAddField];
}

-(void)showAddField
{
    [addView setHidden:!!currentChanel];
    
}

-(IBAction)addChannel:(id)sender
{
    Chanels *chanel = [NSEntityDescription insertNewObjectForEntityForName:@"Chanels"
                                                       inManagedObjectContext:appDelegate.managedObjectContext];
    
    chanel.title = nameNew.text;
    chanel.link = linkNew.text;
    [appDelegate.managedObjectContext save:nil];
    [self loadChanelData];

}

-(void)loadChanelData
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Chanels"];
    NSError *error;
    feed = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [mainTable reloadData];
}

-(void)setupChanels
{
    Chanels *lor = [NSEntityDescription insertNewObjectForEntityForName:@"Chanels"
                                                 inManagedObjectContext:appDelegate.managedObjectContext];
    lor.title = @"ЛОР";
    lor.link = @"https://www.linux.org.ru/section-rss.jsp";
    NSFetchRequest *fetchLOR = [NSFetchRequest fetchRequestWithEntityName:@"Chanels"];
    NSPredicate *predicateLor = [NSPredicate predicateWithFormat:@"title == %@", lor.title];
    [fetchLOR setPredicate:predicateLor];
    
    Chanels *habr = [NSEntityDescription insertNewObjectForEntityForName:@"Chanels"
                                                  inManagedObjectContext:appDelegate.managedObjectContext];
    habr.title = @"Хабр";
    habr.link = @"https://habrahabr.ru/rss/interesting/";
    NSFetchRequest *fetchHabr = [NSFetchRequest fetchRequestWithEntityName:@"Chanels"];
    NSPredicate *predicateHabr = [NSPredicate predicateWithFormat:@"title == %@", habr.title];
    [fetchHabr setPredicate:predicateHabr];
    
    Chanels *phnx = [NSEntityDescription insertNewObjectForEntityForName:@"Chanels"
                                                  inManagedObjectContext:appDelegate.managedObjectContext];
    phnx.title = @"Phoronix";
    phnx.link = @"http://www.phoronix.com/rss.php";
    NSFetchRequest *fetchPh = [NSFetchRequest fetchRequestWithEntityName:@"Chanels"];
    NSPredicate *predicatePh = [NSPredicate predicateWithFormat:@"title == %@", phnx.title];
    [fetchPh setPredicate:predicatePh];
    
    if (![self chanellExists:fetchLOR])
    {
        [appDelegate.managedObjectContext hasChanges];
        [appDelegate.managedObjectContext save:nil];
    }
    else
    {
        [appDelegate.managedObjectContext reset];
    }
}

-(BOOL)chanellExists:(NSFetchRequest *)fetchRequest
{
    return [appDelegate.managedObjectContext countForFetchRequest:fetchRequest error:nil] > 1;
}


-(void)populateChanels
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Feed"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:dateStatic ascending:YES];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"connect.link == %@", currentChanel];
    [fetchRequest setPredicate:predicate];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSError *error;
    feed = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [mainTable reloadData];
}

-(void)setChanel:(NSString *)chanel
{
    currentChanel = chanel;
}

#pragma mark TableView delegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return feed.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (currentChanel)
    {
        [cell buildWithFeed:[feed objectAtIndex:indexPath.row]];
    }
    else
    {
        [cell buildWithChanel:[feed objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentChanel)
    {
        [self performSegueWithIdentifier:@"showObjectSegue" sender:[feed objectAtIndex:indexPath.row]];
    }
    else
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ListViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ListViewController"];
        Chanels *chanel = [feed objectAtIndex:indexPath.row];
        [vc setChanel:chanel.link];
        [appDelegate.managedObjectContext reset];
        [self.navigationController pushViewController:vc animated:true];
    }
}

#pragma mark NSXMLParser delegates

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict
{
    element = elementName;
    
    if ([elementName isEqualToString:itemStatic])
    {
        item    = [NSMutableDictionary new];
        title   = [NSMutableString new];
        link    = [NSMutableString new];
        description = [NSMutableString new];
        date = [NSMutableString new];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([element isEqualToString:titleStatic]) {
        [title appendString:string];
    } else if ([element isEqualToString:linkStatic]) {
        [link appendString:string];
    } else if ([element isEqualToString:descriptionStatic]) {
        [description appendString:string];
    } else if ([element isEqualToString:dateStatic]) {
        [date appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:itemStatic]) {
        
        
        Chanels *chanel;
        NSArray *fetchedObjects;
        NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Chanels"  inManagedObjectContext: appDelegate.managedObjectContext];
        [fetch setEntity:entityDescription];
        [fetch setPredicate:[NSPredicate predicateWithFormat:@"link == %@",currentChanel]];
        NSError * error = nil;
        fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetch error:&error];
        
        if([fetchedObjects count] == 1)
            chanel =  [fetchedObjects objectAtIndex:0];
        
        
        Feed *feedCoreData = [NSEntityDescription insertNewObjectForEntityForName:@"Feed"
                                                                        inManagedObjectContext:appDelegate.managedObjectContext];
            
        [feedCoreData setValue:title forKey:titleStatic];
        [feedCoreData setValue:description forKey:@"feed_description"];
        [feedCoreData setValue:link forKey:linkStatic];
        [feedCoreData setValue:[dateFormatter dateFromString:date] forKey:dateStatic];
        [chanel addConnectObject:feedCoreData];
        [feed addObject:feedCoreData];
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Feed"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title == %@", title];
        [fetchRequest setPredicate:predicate];
        
        error = nil;
        NSUInteger count = [appDelegate.managedObjectContext countForFetchRequest:fetchRequest error:&error];
        
        if (count == 1)
        {
            if([appDelegate.managedObjectContext hasChanges] && ![appDelegate.managedObjectContext save:&error])
            {
                NSLog(@"%@", error);
                abort();
            }
        }
        else
        {
            return;
        }
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    [mainTable reloadData];
}

#pragma mark segues

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(Feed*)sender
{
    if (currentChanel)
    {
        ObjectViewController *controller = segue.destinationViewController;
        controller.info = sender.feed_description;
    }
    else
    {
        ListViewController *controller = segue.destinationViewController;
        [controller setChanel:nil];
    }
}
@end
