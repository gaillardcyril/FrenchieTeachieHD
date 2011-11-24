/*
 * AWSuite: http://forzefield.com
 *
 * Copyright (c) 2010 ForzeField Studios S.L.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "AWScreenshot.h"
#import "CCDirector.h"

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#import "CCDirectorIOS.h"
#import "ccMacros.h"
#define AWIMAGE UIImage*
#else
#import "CCDirectorMac.h"
#define AWIMAGE CGImageRef
#endif

@implementation AWScreenshot

#pragma mark -
#pragma mark Take screenshot as data

+ (CGImageRef) takeAsCGImage
{
    CCDirector *director = [CCDirector sharedDirector];
	CGSize displaySize	= [director displaySizeInPixels];
	CGSize winSize	= [director winSizeInPixels];

	// Create buffer for pixels
	GLuint bufferLength = displaySize.width * displaySize.height * 4;
	GLubyte* buffer = (GLubyte*)malloc(bufferLength);

	// Read Pixels from OpenGL
	glReadPixels(0, 0, displaySize.width, displaySize.height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);

	// Make data provider with data.
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer, bufferLength, NULL);

	// Configure image
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGImageRef iref = CGImageCreate(displaySize.width, displaySize.height, 8, 32, displaySize.width * 4, colorSpaceRef, kCGBitmapByteOrderDefault, provider, NULL, NO, kCGRenderingIntentDefault);

    // Create buffer for output image
	uint32_t* pixels = (uint32_t*)malloc(winSize.width * winSize.height * 4);
	CGContextRef context = CGBitmapContextCreate(pixels, winSize.width, winSize.height, 8, winSize.width * 4, colorSpaceRef, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

    // Transform
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    CGContextTranslateCTM(context, 0, displaySize.height);
	CGContextScaleCTM(context, 1, -1);

	switch ([director deviceOrientation])
	{
		case kCCDeviceOrientationPortrait: break;
		case kCCDeviceOrientationPortraitUpsideDown:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(180));
			CGContextTranslateCTM(context, -displaySize.width, -displaySize.height);
			break;
		case kCCDeviceOrientationLandscapeLeft:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(-90));
			CGContextTranslateCTM(context, -displaySize.height, 0);
			break;
		case kCCDeviceOrientationLandscapeRight:
			CGContextRotateCTM(context, CC_DEGREES_TO_RADIANS(90));
			CGContextTranslateCTM(context, displaySize.height-displaySize.width, -displaySize.height);
			break;
	}

    // Render
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, displaySize.width, displaySize.height), iref);

#else
    CGContextTranslateCTM(context, 0, winSize.height);
	CGContextScaleCTM(context, 1, -1);

    // Render
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, winSize.width, winSize.height), iref);
#endif

    // Create image
	CGImageRef imageRef = CGBitmapContextCreateImage(context);

	// Dealloc
	CGDataProviderRelease(provider);
	CGImageRelease(iref);
	CGColorSpaceRelease(colorSpaceRef);
	CGContextRelease(context);
	free(buffer);
	free(pixels);

	return imageRef;
}

#pragma mark -
#pragma mark Take screenshot as image

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

+ (UIImage*) takeAsImage
{
    CGImageRef imageRef = [self takeAsCGImage];
    UIImage *outputImage = [[[UIImage alloc] initWithCGImage:imageRef] autorelease];

    CGImageRelease(imageRef);
    return outputImage;
}

#else

+ (CGImageRef) takeAsImage
{
    return [self takeAsCGImage];
}

#endif

#pragma mark -
#pragma mark Take screenshot as texture

+ (CCTexture2D*) takeAsTexture
{
    AWIMAGE imageRef = [self takeAsImage];
    CCTexture2D *outputTexture = [[[CCTexture2D alloc] initWithImage:imageRef] autorelease];

#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED
    CGImageRelease(imageRef);
#endif
	return outputTexture;
}

@end