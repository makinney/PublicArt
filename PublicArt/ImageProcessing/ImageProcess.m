//
//  ImageProcess.m
//  ArtCity
//
//  Created by Michael Kinney on 2/9/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageProcess.h"


@implementation ImageProcess

#define SAMPLE_LENGTH	25 // FIXME: could increase this size but at cost of performance

+ (UIImage *) fillSize: (CGSize) newSize image:(UIImage *) image
{
//	CGSize size = image.size;
	bool hasAlpha = NO;
	CGFloat scale = 0.0;
//	scale = newSize.width / image.size.width;
	
	UIGraphicsBeginImageContextWithOptions(newSize, !hasAlpha, scale);
	CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);

	[image drawInRect:rect];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

// Fill every view pixel with no black borders,
// resize and crop if needed
+ (UIImage *) fillSizeA: (CGSize) viewsize image:(UIImage *) image
{
	CGSize size = image.size;
	
	// Choose the scale factor that requires the least scaling
	CGFloat scalex = viewsize.width / size.width;
	CGFloat scaley = viewsize.height / size.height;
	CGFloat scale = MAX(scalex, scaley);
	
	UIGraphicsBeginImageContext(viewsize);
	
	CGFloat width = size.width * scale;
	CGFloat height = size.height * scale;
	
	// Center the scaled image
	float dwidth = ((viewsize.width - width) / 2.0f);
	float dheight = ((viewsize.height - height) / 2.0f);
	
	CGRect rect = CGRectMake(dwidth, dheight, size.width * scale, size.height * scale);
	[image drawInRect:rect];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}



// dist

+ (UIColor *) prevailingColor:(UIImage *)image alphaAdj:(float)alpha{
	
	UIImage *currentImage = image;
	CGRect sampleRect = CGRectMake(0.0f, 0.0f, SAMPLE_LENGTH, SAMPLE_LENGTH);
//	sampleRect = CGRectBottomCenteredInRect(sampleRect, (CGRect){.size = currentImage.size});
	sampleRect = CGRectCenteredInRect(sampleRect, (CGRect){.size = currentImage.size});
	
	UIImage *sampleImage = [ImageProcess subImageWithBounds:currentImage forRect:sampleRect];
	
	unsigned char *bits = [ImageProcess createBitmap:sampleImage];
	
	int bucket[360];
	CGFloat sat[360], bri[360];
	
	// Initialize hue bucket and average saturation and brightness collectors
	for (int i = 0; i < 360; i++)
	{
		bucket[i] = 0;
		sat[i] = 0.0f;
		bri[i] = 0.0f;
	}
	
	// Iterate over each sample pixel, accumulating hsb info
	for (int y = 0; y < SAMPLE_LENGTH; y++)
		for (int x = 0; x < SAMPLE_LENGTH; x++)
		{
			int hue = 0;
			CGFloat r = ((CGFloat)bits[redOffset(x, y, SAMPLE_LENGTH)] / 255.0f);
			CGFloat g = ((CGFloat)bits[greenOffset(x, y, SAMPLE_LENGTH)] / 255.0f);
			CGFloat b = ((CGFloat)bits[blueOffset(x, y, SAMPLE_LENGTH)] / 255.0f);
			
			CGFloat h, s, v;
			rgbtohsb(r, g, b, &h, &s, &v);
			hue = (hue > 359.0f) ? 0 : (int) h;
			bucket[hue]++;
			sat[hue] += s;
			bri[hue] += v;
		}
	
	// Retrieve the hue mode
	int max = -1;
	int maxVal = -1;
	for (int i = 0; i < 360; i++)
	{
		if (bucket[i]  > maxVal)
		{
			max = i;
			maxVal = bucket[i];
		}
	}
	
	// Create a color based on the mode hue, average sat & bri
	float h = max / 360.0f;
	float s = sat[max]/maxVal;
	float br = bri[max]/maxVal;
//	if (br < 0.5) {
//		br = 0.5;
//	} else if (br > 0.75) {
//		br = 0.75;
//	}
	
	
//	NSLog(@" hue:%.2f sat:%.2f br:%.2f];", h, s, br);

//	h = 1.0 - h;
//	s = 1.0 - s;
//	br = 1.0 -br;

//	h = 1.0;
//	s = 1.0;
//	br = 1.0;
//	if ( br < 0.5) {
//		br = 0.5;
//	}
	
	UIColor *hueColor = [UIColor colorWithHue:h saturation:s brightness:br alpha:alpha];
	
	free(bits);
	
	return hueColor;
}


+ (UInt8 *) createBitmap:(UIImage *)image
{
	// Create bitmap data for the given image
	CGContextRef context = CreateARGBBitmapContext(image.size);
	if (context == NULL) return NULL;
	
	CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
	CGContextDrawImage(context, rect, image.CGImage);
	UInt8 *data = CGBitmapContextGetData(context);
	CGContextRelease(context);
	
	return data;
}


+ (UIImage *) subImageWithBounds:(UIImage *) image forRect:(CGRect) rect
{
	UIGraphicsBeginImageContext(rect.size);
	
	CGRect destRect = CGRectMake(-rect.origin.x, -rect.origin.y, image.size.width, image.size.height);
	[image drawInRect:destRect];
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

CGRect CGRectCenteredInRect(CGRect rect, CGRect mainRect)
{
	CGFloat dx = CGRectGetMidX(mainRect)-CGRectGetMidX(rect);
	CGFloat dy = CGRectGetMidY(mainRect)-CGRectGetMidY(rect);
	return CGRectOffset(rect, dx, dy);
}

CGRect CGRectBottomCenteredInRect(CGRect rect, CGRect mainRect)
{
	CGFloat dx = CGRectGetMidX(mainRect)-CGRectGetMidX(rect);
	CGFloat dy = CGRectGetMaxY(mainRect)-(rect.size.height);
	return CGRectOffset(rect, dx, dy);
}


CGContextRef CreateARGBBitmapContext (CGSize size)
{
	// Create the new color space
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	if (colorSpace == NULL)
	{
		fprintf(stderr, "Error allocating color space\n");
		return NULL;
	}
	
	// Allocate memory for the bitmap data
	void *bitmapData = malloc(size.width * size.height * 4);
	if (bitmapData == NULL)
	{
		fprintf (stderr, "Error: Memory not allocated!");
		CGColorSpaceRelease(colorSpace);
		return NULL;
	}
	
	// Build an 8-bit per channel context
	CGContextRef context = CGBitmapContextCreate (bitmapData, size.width, size.height, 8, size.width * 4, colorSpace, (CGBitmapInfo) kCGImageAlphaPremultipliedFirst);
	CGColorSpaceRelease(colorSpace );
	if (context == NULL)
	{
		fprintf (stderr, "Error: Context not created!");
		free (bitmapData);
		return NULL;
	}
	
	return context;
}


void rgbtohsb(CGFloat r, CGFloat g, CGFloat b, CGFloat *pH, CGFloat *pS, CGFloat *pV)
{
	CGFloat h,s,v;
	
	// From Foley and Van Dam
	CGFloat max = MAX(r, MAX(g, b));
	CGFloat min = MIN(r, MIN(g, b));
	
	// Brightness
	v = max;
	
	// Saturation
	s = (max != 0.0f) ? ((max - min) / max) : 0.0f;
	
	if (s == 0.0f) {
		// No saturation, so undefined hue
		h = 0.0f;
	} else {
		// Determine hue
		CGFloat rc = (max - r) / (max - min);		// Distance of color from red
		CGFloat gc = (max - g) / (max - min);		// Distance of color from green
		CGFloat bc = (max - b) / (max - min);		// Distance of color from blue
		
		if (r == max) h = bc - gc;					// resulting color between yellow and magenta
		else if (g == max) h = 2 + rc - bc;			// resulting color between cyan and yellow
		else /* if (b == max) */ h = 4 + gc - rc;	// resulting color between magenta and cyan
		
		h *= 60.0f;									// Convert to degrees
		if (h < 0.0f) h += 360.0f;					// Make non-negative
	}
	
	if (pH) *pH = h;
	if (pS) *pS = s;
	if (pV) *pV = v;
}


NSUInteger alphaOffset(NSUInteger x, NSUInteger y, NSUInteger w)
{return y * w * 4 + x * 4 + 0;}
NSUInteger redOffset(NSUInteger x, NSUInteger y, NSUInteger w)
{return y * w * 4 + x * 4 + 1;}
NSUInteger greenOffset(NSUInteger x, NSUInteger y, NSUInteger w)
{return y * w * 4 + x * 4 + 2;}
NSUInteger blueOffset(NSUInteger x, NSUInteger y, NSUInteger w)
{return y * w * 4 + x * 4 + 3;}



@end