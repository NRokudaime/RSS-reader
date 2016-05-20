//
//  ObjectViewController.m
//  TestApplication
//
//  Created by NRokudaime on 17.05.16.
//  Copyright © 2016 NRokudaime. All rights reserved.
//

#import "ObjectViewController.h"

@implementation ObjectViewController

-(void)viewDidLoad
{
    self.title = @"Новость";
    [webView loadHTMLString:self.info baseURL:nil];
}

@end
