//
//  ObjectViewController.h
//  TestApplication
//
//  Created by NRokudaime on 17.05.16.
//  Copyright © 2016 NRokudaime. All rights reserved.
//

#import "BaseViewController.h"

@interface ObjectViewController : BaseViewController
{
    IBOutlet UIWebView *webView;
}
@property (nonatomic, weak) NSString *info;
@end
