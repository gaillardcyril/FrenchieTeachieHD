//
//  GameSelection.h
//  ColorMeNow
//
//  Created by Cyril Gaillard on 22/05/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface GameSelection : CCLayer {   
    CCMenu *gameSelection;
    NSArray *names;
    CCSpriteBatchNode *backgroundBatch;
}

+(id) scene;
@end
