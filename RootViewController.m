//
//  RootViewController.m
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 10/09/11.
//  Copyright Voila Design 2011. All rights reserved.
//

//
// RootViewController + iAd
// If you want to support iAd, use this class as the controller of your iAd
//

#import "cocos2d.h"

#import "RootViewController.h"
#import "GameConfig.h"
#import "GameStatus.h"
#import "FTIAPHelper.h"
#import "Reachability.h"
#import "GameSelection.h"

@implementation RootViewController


-(void)timeout:(id)sender{
    NSLog(@"cannot connect to the app store");
    [[FTIAPHelper sharedHelper]setProductsRqstSuccessFul:[NSNumber numberWithInt:0]];
}

-(void)removeAdMobBanner{
    NSLog(@"calling removeadbanner");
    //NSLog(@"remove google ad");
    [gADBbannerView removeFromSuperview];
    [gADBbannerView release]; 
    //gADBbannerView=nil;
}

-(void) addAdMobBanner:(CGSize)adSize{
    //NSLog(@"adding Admob");
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    // Create a view of the standard size at the bottom of the screen.
    gADBbannerView = [[GADBannerView alloc]
                      initWithFrame:CGRectMake(winSize.width-adSize.width, winSize.height-adSize.height,
                                               
                                               adSize.width,
                                               adSize.height)];
    
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    gADBbannerView.adUnitID = @"a14e9a6ac2c1203";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    gADBbannerView.rootViewController = self;
    
    [self.view addSubview:gADBbannerView];
    
    [gADBbannerView loadRequest:[GADRequest request]];
    
}

- (void)adView:(GADBannerView *)bannerView
didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"adView:didFailToReceiveAdWithError:%@", [error localizedDescription]);
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    [UIView beginAnimations:@"BannerSlide" context:nil];
    bannerView.frame = CGRectMake(0.0,
                                  self.view.frame.size.height -
                                  bannerView.frame.size.height,
                                  bannerView.frame.size.width,
                                  bannerView.frame.size.height);
    [UIView commitAnimations];
}


-(void) addBannerView{
    //NSLog(@"try add");
    adView = [[ADBannerView alloc]initWithFrame:CGRectZero];
    adView.delegate=self;
    adView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierLandscape,ADBannerContentSizeIdentifierLandscape, nil];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    [[[CCDirector sharedDirector]openGLView]addSubview:adView];
    CGSize windowSize =[[CCDirector sharedDirector]winSize];
    adView.center = CGPointMake(windowSize.width/2,windowSize.height-34 );
    adView.hidden=YES;
    //CCLOG(@"%@", NSStringFromCGSize([adView contentSize]));
}
-(void)removeAdView{
[adView removeFromSuperview];
[adView release];
}
-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    adView.hidden=NO;
    
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    adView.hidden=YES;
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    [[UIApplication sharedApplication]setStatusBarOrientation:[[CCDirector sharedDirector]deviceOrientation]];
}
-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    return YES;
}  


#pragma mark -
#pragma mark Compose Mail
- (void)setUpMailAccount {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"System Error"
													message:@"Please setup a mail account first."
												   delegate:self 
										  cancelButtonTitle:@"Dismiss"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark Compose Mail
// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet {
	if(![MFMailComposeViewController canSendMail]) {
		[self setUpMailAccount];
		return;
	}
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    [picker setToRecipients:[NSArray arrayWithObject:@"info@voiladesign.com.au"]];
    [picker setSubject:@"Frenchie Teachie Ipad Suggestion/Comment/Problem"];
	[self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)displayComposer {
	//NSLog(@"pop-up email here");
	[self displayComposerSheet];
}

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			break;
		case MFMailComposeResultFailed:
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	// Custom initialization
	}
	return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

- (void) copyStatusFile{
    
    BOOL success;
    NSError *error;
    //NSLog(@"will copy file");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"GamesStatus.plist"];
    
    NSString *pListName = @"GamesStatus";
    NSString *path = [[NSBundle mainBundle] pathForResource:pListName ofType:@"plist"];
    
    //success = [fileManager fileExistsAtPath:filePath];
    
    success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
    if (success) {
        NSLog(@"the file has been copied");
    }
    
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
     NSLog(@"view did load");
	[super viewDidLoad];
     
 }

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];	
    NetworkStatus netStatus = [reach currentReachabilityStatus]; 
    if (netStatus == NotReachable) {        
        NSLog(@"No internet connection!");        
    } else {        
        if ([FTIAPHelper sharedHelper].products == nil) {            
            [[FTIAPHelper sharedHelper] requestProducts];
            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
        }        
    }
}

- (void)updateInterfaceWithReachability: (Reachability*) curReach {
}

- (void)productPurchased:(NSNotification *)notification {
    //NSLog(@"j'ai achte");
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [[[GameStatus sharedGameStatus] gameStatusList]setObject:[NSNumber numberWithInt:1] forKey:@"Purchased"];
    [[GameStatus sharedGameStatus] updatePListFile];
    
    [[CCDirector sharedDirector] replaceScene:[GameSelection scene]];
    
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //NSLog(@"the products %@",[FTIAPHelper sharedHelper].products);
    
}
- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;    
    if (transaction.error.code != SKErrorPaymentCancelled) {    
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!" 
                                                         message:transaction.error.localizedDescription 
                                                        delegate:nil 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    }
    
}

-(void)initStatusFile{
    //NSLog(@"view will appear");
    [self copyStatusFile];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];        
    NSString *statusPlistPath = [documentsDirectory stringByAppendingPathComponent:@"GamesStatus.plist"];
    pListContent = [[NSMutableDictionary alloc] initWithContentsOfFile:statusPlistPath];
    [[GameStatus sharedGameStatus]setGameStatusList:pListContent];
    NSLog(@"the string is %@",statusPlistPath);
    [[GameStatus sharedGameStatus]setStatusPlistPath:statusPlistPath];
    [[GameStatus sharedGameStatus]setNames:[NSArray arrayWithObjects:@"Treats",@"Kitchen",@"Farm Animals",@"Numbers",@"Fruits",@"Vegetables",@"Wild Animals",@"Alphabet",@"Bedroom",@"Colors",@"Sea Creatures",@"Vehicles",nil]];
    arrayIndexes=[[NSMutableArray alloc] init];    
    [GameStatus sharedGameStatus].idxArray=arrayIndexes;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"voiceChoice"]==nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"voiceChoice"];
    }   
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	
	//
	// There are 2 ways to support auto-rotation:
	//  - The OpenGL / cocos2d way
	//     - Faster, but doesn't rotate the UIKit objects
	//  - The ViewController way
	//    - A bit slower, but the UiKit objects are placed in the right place
	//
	
#if GAME_AUTOROTATION==kGameAutorotationNone
	//
	// EAGLView won't be autorotated.
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	//
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION==kGameAutorotationCCDirector
	//
	// EAGLView will be rotated by cocos2d
	//
	// Sample: Autorotate only in landscape mode
	//
	if( interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeRight];
	} else if( interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[[CCDirector sharedDirector] setDeviceOrientation: kCCDeviceOrientationLandscapeLeft];
	}
	
	// Since this method should return YES in at least 1 orientation, 
	// we return YES only in the Portrait orientation
	return ( interfaceOrientation == UIInterfaceOrientationPortrait );
	
#elif GAME_AUTOROTATION == kGameAutorotationUIViewController
	//
	// EAGLView will be rotated by the UIViewController
	//
	// Sample: Autorotate only in landscpe mode
	//
	// return YES for the supported orientations
	
	return ( UIInterfaceOrientationIsLandscape( interfaceOrientation ) );
	
#else
#error Unknown value in GAME_AUTOROTATION
	
#endif // GAME_AUTOROTATION
	
	
	// Shold not happen
	return NO;
}

//
// This callback only will be called when GAME_AUTOROTATION == kGameAutorotationUIViewController
//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	//
	// Assuming that the main window has the size of the screen
	// BUG: This won't work if the EAGLView is not fullscreen
	///
	CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGRect rect = CGRectZero;

	
	if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)		
		rect = screenRect;
	
	else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		rect.size = CGSizeMake( screenRect.size.height, screenRect.size.width );
	
	CCDirector *director = [CCDirector sharedDirector];
	EAGLView *glView = [director openGLView];
	float contentScaleFactor = [director contentScaleFactor];
	
	if( contentScaleFactor != 1 ) {
		rect.size.width *= contentScaleFactor;
		rect.size.height *= contentScaleFactor;
	}
	glView.frame = rect;
}
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

