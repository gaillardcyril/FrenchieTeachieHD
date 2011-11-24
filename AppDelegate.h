//
//  AppDelegate.h
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 10/09/11.
//  Copyright Voila Design 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;
-(void)sendEmail;
-(void)displayGoogleAd:(CGSize)adSize;
-(void)removeGoogleAd;
-(void)displayIAd;
-(void)removeIAd;

@end
