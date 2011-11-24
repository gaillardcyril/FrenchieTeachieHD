//
//  HomePage.m
//  
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import "HomePage.h"
#import "GameSelection.h"
#import "LearnSelection.h"
#import "AppDelegate.h"
#import "Comptines.h"
#import "EndScene.h"
#import "SharedFunctions.h"
#import "SettingsPage.h"
#import "CreditsPage.h"
#import "GameStatus.h"
#import "SimpleAudioEngine.h"


#define MENU_ITEM_SIZE 60
@implementation HomePage

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HomePage *layer = [HomePage node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}
-(void)sayYoupi{
    [[SimpleAudioEngine sharedEngine] playEffect:@"youpi.mp3"];
}
-(void)onEnterTransitionDidFinish{
    [super onEnterTransitionDidFinish];
    // Load up the frames of our animation        
    CCAnimation *walkAnim = [CCAnimation animation];
    for(int i = 1; i <= 24; ++i) {
        [walkAnim addFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName :[NSString stringWithFormat:@"Crab%04d.png", i]]];
        //CCLOG(@"Moee%04d.png",i);
    }
    
    id walkAction = [CCAnimate actionWithDuration:0.25f animation:walkAnim restoreOriginalFrame:NO];
    
    CCSprite *crab = [CCSprite spriteWithSpriteFrameName:@"Crab0001.png"];
    crab.position = ccp(crab.contentSize.width/2, 70);
    [spritesNode addChild:crab z:3];
    //[crab setDisplayFrame:  //[self addChild:spriteSheet z:2];
    [crab runAction:[CCSequence actions:[CCRepeat actionWithAction:walkAction times:12],[CCCallFunc actionWithTarget:self selector:@selector(sayYoupi)],nil]];
    [crab runAction:[CCMoveTo actionWithDuration:3 position:ccp(winSize.width/2,70)]];
    crabSound=[[SimpleAudioEngine sharedEngine]playEffect:@"159.mp3" pitch:1 pan:0 gain:0.2];
    
}
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
        
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"159.mp3"];
        // ask director the the window size
		winSize = [[CCDirector sharedDirector] winSize];
		//[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];
                
        if(
           getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")
           ) {
            NSLog(@"--------------------------------------->NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
        }
        [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
        
        [CCTexture2D PVRImagesHavePremultipliedAlpha:YES];
        spritesNode = [CCSpriteBatchNode batchNodeWithFile:@"HomePage.pvr.ccz"];
        [self addChild:spritesNode];    
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"HomePage.plist"];
        CCSprite *background = [CCSprite spriteWithSpriteFrameName:@"homeBG.png"];
        [spritesNode addChild:background];
        background.position = ccp(winSize.width/2,winSize.height/2);

        CCSprite *sand = [CCSprite spriteWithSpriteFrameName:@"homeGnd.png"];
        [spritesNode addChild:sand z:2];
        sand.position = ccp(winSize.width/2,sand.contentSize.height/2);
        
        CCLabelBMFont *gameNLabel = [CCLabelBMFont labelWithString:@"Frenchie Teachie" fntFile:@"KidsFont110.fnt"];
        gameNLabel.position = ccp(winSize.width/2+25,winSize.height-80);
        [self addChild:gameNLabel z:1];
        
        CCLabelBMFont *learnLabel= [CCLabelBMFont labelWithString: NSLocalizedString(@"learn", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *learnItem = [CCMenuItemLabel itemWithLabel:learnLabel target:self selector:@selector(displayLearnSelection:)];
        
        CCLabelBMFont *startLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"play", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *startItem = [CCMenuItemLabel itemWithLabel:startLabel target:self selector:@selector(displayGameSelection:)];
      
        CCLabelBMFont *settingsLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"settings", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *settingsItem = [CCMenuItemLabel itemWithLabel:settingsLabel target:self selector:@selector(showSettingsPage:)];
        
        CCLabelBMFont *comptinesLabel= [CCLabelBMFont labelWithString:@"Comptines" fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *comptinesItem = [CCMenuItemLabel itemWithLabel:comptinesLabel target:self selector:@selector(showComptinesPage:)];
        
        CCLabelBMFont *creditsLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"credits", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *creditsItem = [CCMenuItemLabel itemWithLabel:creditsLabel target:self selector:@selector(showCreditsPage:)];
        creditsItem.tag = 1;
        
        CCLabelBMFont *rateLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"rateMe", nil) fntFile:@"KidsFont78.fnt"];
        CCMenuItemLabel *rateItem = [CCMenuItemLabel itemWithLabel:rateLabel target:self selector:@selector(displayRatingPage:)];
        rateItem.tag=2;
        
        CCMenu *mainMenu =[CCMenu menuWithItems:learnItem,startItem,comptinesItem,settingsItem, nil];
        [mainMenu alignItemsVertically];
        mainMenu.position=ccp(winSize.width/2, winSize.height/2);
        [self addChild:mainMenu];    
        
        CCMenu *secondaryMenu = [CCMenu menuWithItems:creditsItem,rateItem, nil];
        [secondaryMenu alignItemsHorizontallyWithPadding:400];
        secondaryMenu.position = ccp(winSize.width/2,90);
        [self addChild:secondaryMenu];
               
    }
	return self;
}

-(void)displayLearnSelection:(CCMenuItem *) menuItem{
    [[CCDirector sharedDirector] replaceScene:[LearnSelection scene]];
}

-(void)displayGameSelection:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector] replaceScene:[GameSelection scene]];
}

-(void)showSettingsPage:(CCMenuItem *) menuItem {    
    [[CCDirector sharedDirector] replaceScene:[SettingsPage scene]];
}

-(void)showCreditsPage:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector]replaceScene:[CreditsPage scene]]; 
}
-(void)showComptinesPage:(CCMenuItem *) menuItem {
    [[CCDirector sharedDirector]replaceScene:[Comptines scene]];
}

-(void)displayRatingPage:(CCMenuItem *) menuItem {
    NSString *iTunesLink = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=471866434&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software";
    
    //NSLog(@"clicked on the app store");	
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}
-(void)onExit{
    [[SimpleAudioEngine sharedEngine] stopEffect:crabSound];
    clearTextures(spritesNode);
    [super onExit];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc{
    
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    [super dealloc];
	
}

@end
