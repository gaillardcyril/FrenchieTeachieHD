//
//  Bird.h
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 11/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum tagPaddleState {
	kPaddleStateGrabbed,
	kPaddleStateUngrabbed
} PaddleState;

typedef enum tagPaddleEnable {
	kObjEnabled,
	kObjDisabled
} PaddleEnable;


@interface HiddenObject : CCSprite<CCTargetedTouchDelegate> {
    PaddleState state;
    PaddleEnable status;
    BOOL objFound;
}
-(BOOL)isTouched;
-(void )touchAck;
-(void)disableObj;
@property(nonatomic, readonly) CGRect rect;
@property(nonatomic, readonly) CGRect rectInPixels;
@property(nonatomic, readwrite) BOOL objFound;
@end
