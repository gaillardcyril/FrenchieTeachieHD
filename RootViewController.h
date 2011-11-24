//
//  RootViewController.h
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 10/09/11.
//  Copyright Voila Design 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "GADBannerView.h"
#import <iAd/iad.h>


@interface RootViewController : UIViewController<MFMailComposeViewControllerDelegate,ADBannerViewDelegate> {
    NSMutableDictionary *pListContent;
    GADBannerView *gADBbannerView;
    ADBannerView *adView;
    NSMutableArray *arrayIndexes;
}
-(void)displayComposer;
-(void) addAdMobBanner:(CGSize)adSize;
-(void)removeAdMobBanner;
-(void)removeAdView;
-(void) addBannerView;
-(void)initStatusFile;
@end
