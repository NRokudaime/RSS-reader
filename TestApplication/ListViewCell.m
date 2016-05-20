//
//  ListViewCell.m
//  TestApplication
//
//  Created by NRokudaime on 17.05.16.
//  Copyright © 2016 NRokudaime. All rights reserved.
//

#import "ListViewCell.h"
#import "Feed.h"
#import "Chanels.h"
@implementation ListViewCell

-(void)buildWithFeed:(Feed*)feed
{
    [titleLabel setText:feed.title];
}

-(void)buildWithChanel:(Chanels*)chanel
{
    [titleLabel setText:chanel.title];
}

@end
