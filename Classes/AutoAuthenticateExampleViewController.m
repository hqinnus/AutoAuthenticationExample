//
//  AutoAuthenticateExampleViewController.m
//  AutoAuthenticateExample
//
//  Created by HQ on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AutoAuthenticateExampleViewController.h"

//for lapi issue
#import <Security/Security.h>
#import "SFHFKeychainUtils.h"


#define SERVER_URL @"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"
#define USERNAME @"u0807275"
#define PASSWORD @"hq.nusinml128"

@implementation AutoAuthenticateExampleViewController

@synthesize theWeb;

#pragma mark -
#pragma mark view life cycle

- (void)viewDidLoad{
	//Lapi issue
	NSURL *url = [NSURL URLWithString:SERVER_URL];
	NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
	theWeb.delegate = self;
	[theWeb loadRequest:requestObj];
	
	//secure password
	[[NSUserDefaults standardUserDefaults] setObject:USERNAME forKey:@"username"];
	[SFHFKeychainUtils storeUsername:USERNAME andPassword:PASSWORD forServiceName:@"MyService" updateExisting:YES error:nil];
	
	[self.view	addSubview:theWeb];
}


#pragma mark -
#pragma mark web view for authentication
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType; {
	
    //save form data
	NSURL *url = [self.theWeb.request URL];
	NSLog(@"Check the host: %@", url.absoluteString);
    if(navigationType == UIWebViewNavigationTypeFormSubmitted) {
		NSLog(@"Navigation Confirmed" );
		
        //store values locally
        [[NSUserDefaults standardUserDefaults] setObject:USERNAME forKey:@"UserID"];
        [SFHFKeychainUtils storeUsername:USERNAME andPassword:PASSWORD forServiceName:@"MyService" updateExisting:YES error:nil];
		
    }    
	return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
	//can do nothing
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
	
    //verify view is on the login page of the site (simplified)
    NSURL *requestURL = [self.theWeb.request URL];
	NSLog(@"Get returned host: %@", requestURL.absoluteString);
	if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/?apikey=K6vDt3tA51QC3gotLvPYf"]) {
		//try to auto fill the form and load
		NSString *loadUsernameJS = [NSString stringWithFormat:@"document.forms['frm'].userid.value ='%@'", USERNAME];
		NSString *password = [SFHFKeychainUtils getPasswordForUsername: USERNAME andServiceName:@"MyService" error:nil];
		NSString *loadPasswordJS = [NSString stringWithFormat:@"document.forms['frm'].password.value ='%@'", PASSWORD];
		NSLog(@"password");
		
		//autofill the form
		[self.theWeb stringByEvaluatingJavaScriptFromString: loadUsernameJS];
		[self.theWeb stringByEvaluatingJavaScriptFromString: loadPasswordJS];
		
		NSString *clickLogin = [NSString stringWithFormat:@"document.forms['frm'].submit()"];
		
		[self.theWeb stringByEvaluatingJavaScriptFromString:clickLogin];
	}else if ([requestURL.absoluteString isEqualToString:@"https://ivle.nus.edu.sg/api/login/login_result.ashx?apikey=K6vDt3tA51QC3gotLvPYf&r=0"]) {
		NSString *webContent = [self.theWeb stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
		NSLog(@"Great!!!!!!!!!!!!! Token is %@", webContent);
    }
}

#pragma mark -
#pragma mark memory management


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	theWeb.delegate = nil;
}


- (void)dealloc {
	[theWeb release];
    [super dealloc];
}

@end
