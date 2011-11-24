//
//  Bird.m
//  FrenchieTeachieIpad
//
//  Created by Cyril Gaillard on 11/10/11.
//  Copyright 2011 Voila Design. All rights reserved.
//

#import "HiddenObject.h"

@implementation HiddenObject
@synthesize objFound;

- (CGRect)rectInPixels
{
	CGSize s = [self contentSizeInPixels];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (CGRect)rect
{
	CGSize s = [self contentSize];
	return CGRectMake(-s.width / 2, -s.height / 2, s.width, s.height);
}

- (id)init
{
	if ((self = [super init]) ) {
        
		state = kPaddleStateUngrabbed;
        status = kObjEnabled;
        objFound=NO;
	}	
	return self;
}

- (void)onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}
-(void)disableObj{
    state = kObjDisabled;
}
-(BOOL)isTouched{
    return (state==kPaddleStateGrabbed);
}
- (void)onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}	

- (BOOL)containsTouchLocation:(UITouch *)touch
{
	CGPoint p = [self convertTouchToNodeSpaceAR:touch];
	CGRect r = [self rectInPixels];
	return CGRectContainsPoint(r, p);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (state != kPaddleStateUngrabbed) return NO;
    if (status == kObjDisabled){ return NO;} 
	if ( ![self containsTouchLocation:touch] )return NO;
    if (objFound) return NO;
	status = kObjDisabled;
	state = kPaddleStateGrabbed;
	return YES;
}

-(void )touchAck{
    state = kPaddleStateUngrabbed;
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
	status = kObjEnabled;
	state = kPaddleStateUngrabbed;
}

@end
