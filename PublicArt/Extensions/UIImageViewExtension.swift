//
//  UIImageViewExtension.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/16/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIImageView {
////
//	func averageColor() -> UIColor {
//		var colorSpace = CGColorSpaceCreateDeviceRGB()
//		var rgba: [CGFloat] = [0,0,0,0]
//		let dataType = UnsafeMutablePointer<UInt8>()
//		let bitmapData = malloc(CUnsignedLong(4))
//	//	var context = CGBitmapContextCreate(&rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big)
//		let bitmapInfo = CGBitmapInfo.ByteOrder32Big.rawValue
//		
//		var context: CGContextRef = CGBitmapContextCreate(bitmapData, width:1, height:1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo:  bitmapInfo)
//		
//		// CGBitmapInfo.ByteOrder32Big
////		CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.image)
//		
//		if rgba[3] > 0 {
//			var alpha = rgba[3] / 255
//			var multiplier = alpha / 255
//			return UIColor(red: rgba[0] * multiplier, green: rgba[1] * multiplier, blue: rgba[2] * multiplier, alpha: alpha)
//		} else {
//			return UIColor(red: rgba[0] / 255, green: rgba[1] / 255, blue: rgba[2] / 255, alpha: rgba[3] / 255)
//		}
//	}
////	func averageColor() {// ->UIColor {
////		var colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()
////	//	unsigned char rgba[4];
//	//	CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
//		
//		var context: CGContextRef = CGBitmapContextCreate(data: nil, width:1, height:1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace!, bitmapInfo: kCGImageAlphaPremultipliedLast)
//		
//		CGContextDrawImage(context, CGRectMake(  , self.image);
//		CGColorSpaceRelease(colorSpace);
//		CGContextRelease(context);
//		
//		if(rgba[3] &gt; 0) {
//			CGFloat alpha = ((CGFloat)rgba[3])/255.0;
//			CGFloat multiplier = alpha/255.0;
//			return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
//				green:((CGFloat)rgba[1])*multiplier
//				blue:((CGFloat)rgba[2])*multiplier
//				alpha:alpha];
//		}
//		else {
//			return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
//				green:((CGFloat)rgba[1])/255.0
//				blue:((CGFloat)rgba[2])/255.0
//				alpha:((CGFloat)rgba[3])/255.0];
//		}
//	}
//	
//	
	
	/*
	- (UIColor *)averageColor {
	CGSize size = {1, 1};
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
	[self drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
	uint8_t *data = CGBitmapContextGetData(ctx);
	UIColor *color = [UIColor colorWithRed:data[0] / 255.f green:data[1] / 255.f blue:data[2] / 255.f alpha:1];
	UIGraphicsEndImageContext();
	return color;
	}

*/

	func averageColor1() -> UIColor {
		
		var size = CGSize(width: 1, height:1 )
		UIGraphicsBeginImageContext(size)
		var ctx: CGContextRef = UIGraphicsGetCurrentContext()
		var quality = CGInterpolationQuality(4)
		CGContextSetInterpolationQuality(ctx,kCGInterpolationHigh)
		var point = CGPoint(x:0, y:0)
		var rect = CGRect(origin: point, size:size)
		self.image?.drawInRect(rect, blendMode: kCGBlendModeHue, alpha: 1)
		var data = CGBitmapContextGetData(ctx)
		let dataType = UnsafeMutablePointer<UInt8>(data)
		var alpha = dataType[0]
		var alphaN = CGFloat(alpha) / 255.0
		var red =  dataType[1]
		var redN = CGFloat(red)/255.0
		var green = dataType[2]
		var greenN  = CGFloat(green) / 255.0
		var blue = dataType[3]
		var blueN = CGFloat(blue) / 255.0

		let color: UIColor = UIColor(red: redN, green: greenN, blue: blueN, alpha:alphaN)
		UIGraphicsEndImageContext()
		return color
	}


	// examples
	
	/*
	
- (UIColor *)averageColor {

CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
unsigned char rgba[4];
CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage);
CGColorSpaceRelease(colorSpace);
CGContextRelease(context);

if(rgba[3] &gt; 0) {
CGFloat alpha = ((CGFloat)rgba[3])/255.0;
CGFloat multiplier = alpha/255.0;
return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
green:((CGFloat)rgba[1])*multiplier
blue:((CGFloat)rgba[2])*multiplier
alpha:alpha];
}
else {
return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
green:((CGFloat)rgba[1])/255.0
blue:((CGFloat)rgba[2])/255.0
alpha:((CGFloat)rgba[3])/255.0];
}
}
// https://github.com/mxcl/UIImageAverageColor/blob/master/UIImage%2BAverageColor.m
*/
/*
	- (UIColor *)averageColor {
	CGSize size = {1, 1};
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(ctx, kCGInterpolationMedium);
	[self drawInRect:(CGRect){.size = size} blendMode:kCGBlendModeCopy alpha:1];
	uint8_t *data = CGBitmapContextGetData(ctx);
	UIColor *color = [UIColor colorWithRed:data[0] / 255.f green:data[1] / 255.f blue:data[2] / 255.f alpha:1];
	UIGraphicsEndImageContext();
	return color;
	}

*/

//	func averageColor1() -> UIColor {
//		
//		var size = CGSize(width: 1, height:1 )
//		UIGraphicsBeginImageContext(size)
//		var ctx: CGContextRef = UIGraphicsGetCurrentContext()
//		var quality = CGInterpolationQuality(4)
//		CGContextSetInterpolationQuality(ctx,kCGInterpolationHigh)
//		var point = CGPoint(x:0, y:0)
//		var rect = CGRect(origin: point, size:size)
//		self.image?.drawInRect(rect, blendMode: kCGBlendModeHue, alpha: 1)
//		var data = CGBitmapContextGetData(ctx)
//		let dataType = UnsafeMutablePointer<UInt8>(data)
//		var alpha = dataType[0]
//		var alphaN = CGFloat(alpha) / 255.0
//		var red =  dataType[1]
//		var redN = CGFloat(red)/255.0
//		var green = dataType[2]
//		var greenN  = CGFloat(green) / 255.0
//		var blue = dataType[3]
//		var blueN = CGFloat(blue) / 255.0
//
//		let color: UIColor = UIColor(red: redN, green: greenN, blue: blueN, alpha:alphaN)
//		UIGraphicsEndImageContext()
//		return color
//	}
//









	func imageScale() -> (sx: Float, sy: Float)? {
		var scale:Float = 1.0
		var sx:Float?
		var sy:Float?
		var viewWidth = self.frame.size.width
		var viewHeight = self.frame.size.height

		if let imageWidth = self.image?.size.width {
			sx = Float(viewWidth / imageWidth)
			var imageHeight = self.image!.size.height
			sy = Float(viewHeight / imageHeight)
		} else {
			return nil
		}
		
		switch (self.contentMode) {
		case .ScaleAspectFit:
			scale = fminf(sx!,sy!)
			return (scale,scale)
		case .ScaleAspectFill:
			scale = fmaxf(sx!,sy!)
			return (scale,scale)
		case .ScaleToFill:
			return (sx!,sy!)
		default:
			return (scale,scale)
		}
	}
	
	func imageTo(coordinateSpace: UICoordinateSpace) -> (x: Float, y: Float)? {
		var scale = imageScale()
		var viewWidth = self.frame.size.width
		var viewHeight = self.frame.size.height
		var imageHeight = self.image?.size.height

		if let imageWidth = self.image?.size.width {
			var scaledImageWidth = Float(imageWidth) * scale!.sx
			var imageXposition = (Float(viewWidth) - scaledImageWidth) / 2.0
			var scaledImageHeight = Float(imageHeight!) * scale!.sy
			var imageYposition = (Float(viewHeight) - scaledImageHeight) / 2.0
			var imagePoint = CGPoint(x: CGFloat(imageXposition), y: CGFloat(imageYposition))
			var screenPoint = convertPoint(imagePoint, toCoordinateSpace:coordinateSpace)
			return (Float(screenPoint.x), Float(screenPoint.y))
		} else {
			return nil
		}
	}
	
	
	
	
}