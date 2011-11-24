//
//  SharedFunctions.m
//  MooeeMath
//
//  Created by Cyril Gaillard on 3/01/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import "SharedFunctions.h"
#import "GameStatus.h"
#import "AppDelegate.h"
#import "EndScene.h"
#import "GameSelection.h"
#import "FTIAPHelper.h"

void gameEnded(CCLayer *currentLayer, NSInteger score, NSInteger numberQsts){
    float correctAnswerRatio = 100*(float)score/numberQsts;
    
    if (correctAnswerRatio>75){
        NSMutableArray *tempGameStatus = [[NSMutableArray alloc] initWithArray:[[[GameStatus sharedGameStatus] gameStatusList] objectForKey:@"GameCompleted"]];
        NSInteger idxGameStatus = [[[GameStatus sharedGameStatus] gameNumber] intValue];
        
        [tempGameStatus replaceObjectAtIndex:idxGameStatus withObject:[NSNumber numberWithInt:1]];
        //CCLOG(@"the array is %@ and the index is %d",tempGameStatus,idxGameStatus);
        [[[GameStatus sharedGameStatus] gameStatusList] setObject:tempGameStatus forKey:@"GameCompleted"];
        [[GameStatus sharedGameStatus] updatePListFile];
        [tempGameStatus release];
        [currentLayer performSelector:@selector(showEndScene) withObject:nil afterDelay:1.0f];
    }
    else{
        [currentLayer performSelector:@selector(showFailedLayer) withObject:nil afterDelay:1.0f];
    }
}


void displayAd(CGSize adSize){
    if(![[GameStatus sharedGameStatus] gamePurchased]){
        NSLocale* currentLocale = [NSLocale currentLocale];
        NSString* countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
        if ([countryCode isEqualToString:@"US"]) {
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] displayIAd];
        }
        else{
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] displayGoogleAd:adSize];
        }    
    }
}

void clearTextures(CCSpriteBatchNode *batchNode){
    CCTexture2D *texture = batchNode.textureAtlas.texture;
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromTexture:texture];
    [[CCTextureCache sharedTextureCache] removeTexture:texture];
}


void removeAd(){
    if(![[GameStatus sharedGameStatus] gamePurchased]){
        NSLocale* currentLocale = [NSLocale currentLocale];
        NSString* countryCode = [currentLocale objectForKey:NSLocaleCountryCode];
        if ([countryCode isEqualToString:@"US"]) {
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeIAd];
        }
        else{
            [(AppDelegate*)[[UIApplication sharedApplication] delegate] removeGoogleAd];
        }
    }
}
//-----------------------Function to the load the batch Node-------------------//
CCSpriteBatchNode *loadBatchNode (CCLayer *currentLayer, NSString *batchName){
    
    NSString *batchCczName = [batchName stringByAppendingString:@".pvr.ccz"];
   // NSLog(@"the batch that will be loaded is %@",batchCczName);
    CCSpriteBatchNode *levelBatchT = [CCSpriteBatchNode batchNodeWithFile:batchCczName];
    [currentLayer addChild:levelBatchT];
    NSString *batchPlistName = [batchName stringByAppendingString:@".plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:batchPlistName];
    return levelBatchT;
}

	
//-----------------------Function to the pause button-------------------//
void displayBackground (CCSpriteBatchNode *currentBatch, NSString *BGString){
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
	CCSprite *homePgBgnd = [CCSprite spriteWithSpriteFrameName:BGString];
	CGSize dSize = [[CCDirector sharedDirector] winSize];
	// position the label on the center of the screen
	homePgBgnd.position =  ccp(dSize.width /2, dSize.height/2);
	// add the label as a child to this Layer
	[currentBatch addChild:homePgBgnd z:1];
}

void displayBackHomeButton (CCLayer *currentLayer){
    CGSize dSize = [[CCDirector sharedDirector] winSize];
	CCMenuItemImage *menuItemPauseGame =[CCMenuItemImage itemFromNormalImage:@"backArrow.png" selectedImage: nil target:currentLayer selector:@selector(goBackHome:)];	
    
	CCMenu *pauseButtonMenu = [CCMenu menuWithItems:menuItemPauseGame, nil];
	pauseButtonMenu.position = ccp([menuItemPauseGame contentSize].width/2, dSize.height-[menuItemPauseGame contentSize].height/2);
    
	[currentLayer addChild:pauseButtonMenu z:10];
}

void displayBackSelButton (CCLayer *currentLayer){
    CGSize dSize = [[CCDirector sharedDirector] winSize];
	CCMenuItemImage *menuItemHelpGame =[CCMenuItemImage itemFromNormalImage:@"backArrow.png" selectedImage: nil target:currentLayer selector:@selector(displayGameSelection:)];	
    
	CCMenu *helpButtonMenu = [CCMenu menuWithItems:menuItemHelpGame, nil];
	helpButtonMenu.position = ccp([menuItemHelpGame contentSize].width/2, dSize.height-[menuItemHelpGame contentSize].height/2);
    
	[currentLayer addChild:helpButtonMenu z:10];
}

//-----------------------Shake Sprite-------------------//
void shakeNumberToPick (CCMenu *itemsMenu, NSInteger spriteTag){
	
    id shakeSprite = [CCSequence actions:
					  [CCRotateBy actionWithDuration: 0.1 angle: -10],					 
					  [CCRotateBy actionWithDuration: 0.1 angle: +20],
					  [CCRotateBy actionWithDuration: 0.1 angle: -20],
					  [CCRotateBy actionWithDuration: 0.1 angle: +20],
					  [CCRotateBy actionWithDuration: 0.1 angle: -20],
					  [CCRotateBy actionWithDuration: 0.1 angle: +20],
					  [CCRotateBy actionWithDuration: 0.1 angle: -20],
					  [CCRotateBy actionWithDuration: 0.1 angle: +20],
					  [CCRotateBy actionWithDuration: 0.1 angle: -20],
					  [CCRotateBy actionWithDuration: 0.1 angle: +10],
					  nil];
	
    [[SimpleAudioEngine sharedEngine] playEffect:@"dinnerBell.wav"];
    NSLog(@"the tag is %d",spriteTag);
    
	[[itemsMenu getChildByTag:spriteTag] runAction:shakeSprite];
}

void shakeNumberSprite (CCSprite *spriteToShake){
	
    id shakeSprite = [CCSequence actions:
					  [CCRotateBy actionWithDuration: 0.1 angle: -10],					 
					  [CCRotateBy actionWithDuration: 0.1 angle: +20],
					  [CCRotateBy actionWithDuration: 0.1 angle: -20],
					  [CCRotateBy actionWithDuration: 0.1 angle: +20],
					  [CCRotateBy actionWithDuration: 0.1 angle: -20],
					  [CCRotateBy actionWithDuration: 0.1 angle: +20],
					  [CCRotateBy actionWithDuration: 0.1 angle: -20],
					  [CCRotateBy actionWithDuration: 0.1 angle: +20],
					  [CCRotateBy actionWithDuration: 0.1 angle: -20],
					  [CCRotateBy actionWithDuration: 0.1 angle: +10],
					  nil];
	
    [[SimpleAudioEngine sharedEngine] playEffect:@"dinnerBell.wav"];
    //NSLog(@"the tag is %d",spriteTag);
    
	[spriteToShake runAction:shakeSprite];
}


void showSelectionPage() {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameSelection scene] withColor:ccc3(0,0,0)]];
}

void buyAllCharacters() {
    
    if ([[FTIAPHelper sharedHelper].productsRqstSuccessFul  intValue]) {
        SKProduct *product = [[FTIAPHelper sharedHelper].products objectAtIndex:0];
        
        [[FTIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
    } 
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"App Store Connection Error" 
                                                        message:@"Cannot connect to the App Store"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    
}


NSDictionary *read_pList(NSString *plistName){
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    //NSLog(@"3 the file read will be %@",plistPath);
    return [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

