//
//  HomePage.h
//  FrenchieTeachieFood
//
//  Created by Cyril Gaillard on 12/10/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface HomePage : CCLayer {
    CCSpriteBatchNode *spritesNode;
    CGSize winSize;
    ALuint crabSound;
	
}
+(id) scene;
@end
