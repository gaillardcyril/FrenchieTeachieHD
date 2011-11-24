//
//  PauseLayer.m
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 9/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import "PauseLayer.h"
#import "GameSelection.h"
#import "SharedFunctions.h"


@implementation PauseLayer

-(void)discardLayer{
    [callingLayer discardPauseLayer];
}

-(void)displayGameSelection {
    showSelectionPage();
}

- (void) resetGame{
    [callingLayer resetGame];
}

-(id)initWithParent:(CCLayer *)parentLayer {
    
    if ((self = [super initWithColor:ccc4(255, 255, 255, 180)])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        callingLayer = parentLayer;
        
        CCLabelBMFont *pausedLabel= [CCLabelBMFont labelWithString:NSLocalizedString(@"pause", nil) fntFile:@"KidsFont110.fnt"];
        pausedLabel.position=ccp(size.width/2,size.height-80);
        [self addChild:pausedLabel];
        
        CCMenuItemImage *menuItemResetGame =[CCMenuItemImage itemFromNormalImage:@"resetButton.png" selectedImage: @"resetButtonS.png" target:self selector:@selector(resetGame)];
        
        CCMenuItemImage *menuItemLevelSelGame =[CCMenuItemImage itemFromNormalImage:@"backToSelButton.png" selectedImage: @"backToSelButtonS.png" target:self selector:@selector(displayGameSelection)];
        
        CCMenuItemImage *menuItemContinueGame =[CCMenuItemImage itemFromNormalImage:@"continueButton.png" selectedImage: @"continueButtonS.png" target:self selector:@selector(discardLayer)];
        
        CCMenu *pausePageMenu = [CCMenu menuWithItems:menuItemResetGame,menuItemLevelSelGame,menuItemContinueGame, nil];
        [pausePageMenu alignItemsHorizontallyWithPadding:20];
        pausePageMenu.position = ccp(size.width/2,size.height/2);
        
        [self addChild:pausePageMenu z:3];
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
} 

@end
