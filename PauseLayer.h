//
//  PauseLayer.h
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 9/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "ThreeChoice.h"
//#import "Hidden.h"

@interface PauseLayer : CCLayerColor {
     CCLayer *callingLayer;
}
-(id) initWithParent:(CCLayer *)parentLayer;
@end
