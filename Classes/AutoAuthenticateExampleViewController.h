//
//  AutoAuthenticateExampleViewController.h
//  AutoAuthenticateExample
//
//  Created by HQ on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoAuthenticateExampleViewController : UIViewController <UIWebViewDelegate>{
	IBOutlet UIWebView *theWeb;
}

@property (nonatomic, retain) IBOutlet UIWebView *theWeb;

@end

