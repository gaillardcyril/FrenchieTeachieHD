//
//  ResultsPage.h
//  FrenchieTeachieObjects
//
//  Created by Cyril Gaillard on 30/09/10.
//  Copyright 2010 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "SimpleAudioEngine.h"

@interface EndScene : CCLayer  <AVAudioPlayerDelegate>
{
	AVAudioPlayer* endSound;
    CCSpriteBatchNode *spritesNode;
    id walkActionB1;
    id walkActionB2;
    id walkActionB3;
    id walkActionB4;
    CCSprite * bird1;
    CCParticleSystemQuad *dancingNote1;
    CCSprite * bird2;
    CCParticleSystemQuad *dancingNote2;
    CCSprite * bird3;
    CCParticleSystemQuad *dancingNote3;
    CCSprite * bird4;
    CCParticleSystemQuad *dancingNote4;
}



+(id) scene;
@property(nonatomic,retain) AVAudioPlayer* endSound;

@end
