//
//  GameOverLayer.m
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 9/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import "GameOverLayer.h"
#import "CCLabelBMFontMultiline.h"
#import "ThreeChoice.h"
#import "GameSelection.h"
#import "Hidden.h"


@implementation GameOverLayer

-(void)discardLayer{
    [callingLayer discardInstrLayer];
}

- (void) resetGame: (CCMenuItem *) menuItem{
    [callingLayer resetGame];

}

-(void)displayGameSelection:(CCMenuItem *) menuItem {
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameSelection scene] withColor:ccc3(0,0,0)]];
}

-(id) initWithParent:(CCLayer *)parentLayer {
    
    if ((self = [super initWithColor:ccc4(255, 255, 255, 180)])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        callingLayer = parentLayer;
        
        CCLabelBMFontMultiline *tryAgainLabel= [CCLabelBMFontMultiline labelWithString:NSLocalizedString(@"ohno", nil) fntFile:@"KidsFont110.fnt" width:size.width*0.75 alignment:CenterAlignment];
        tryAgainLabel.position=ccp(size.width/2,size.height-[tryAgainLabel contentSize].height/2);
        [self addChild:tryAgainLabel z:11];
        
        CCMenuItemImage *menuItemResetGame =[CCMenuItemImage itemFromNormalImage:@"resetButton.png" selectedImage: @"resetButtonS.png" target:self selector:@selector(resetGame:)];
        
        CCMenuItemImage *menuItemLevelSelGame =[CCMenuItemImage itemFromNormalImage:@"backToSelButton.png" selectedImage: @"backToSelButtonS.png" target:self selector:@selector(displayGameSelection:)];
        CCMenu *failedPageMenu = [CCMenu menuWithItems:menuItemResetGame,menuItemLevelSelGame, nil];
        [failedPageMenu alignItemsHorizontallyWithPadding:20];
        failedPageMenu.position = ccp(size.width/2,size.height/2);
        [self addChild:failedPageMenu];
        
    }
    return self;
}

-(void)dealloc{
    [super dealloc];
}  

@end
