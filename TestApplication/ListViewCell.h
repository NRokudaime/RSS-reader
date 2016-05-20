//
//  ListViewCell.h
//  TestApplication
//
//  Created by NRokudaime on 17.05.16.
//  Copyright © 2016 NRokudaime. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Feed;
@class Chanels;
@interface ListViewCell : UITableViewCell
{
    IBOutlet UILabel *titleLabel;
}

-(void)buildWithFeed:(Feed*)feed;

-(void)buildWithChanel:(Chanels*)chanel;

@end
