//
//  AutoAuthenticateExampleAppDelegate.h
//  AutoAuthenticateExample
//
//  Created by HQ on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutoAuthenticateExampleViewController;

@interface AutoAuthenticateExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    AutoAuthenticateExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet AutoAuthenticateExampleViewController *viewController;

@end

