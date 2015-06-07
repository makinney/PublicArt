//
//  ImageProcess.h
//  ArtCity
//
//  Created by Michael Kinney on 2/9/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface ImageProcess : NSObject

+ (UIColor *) prevailingColor:(UIImage *)image alphaAdj:(float)alpha;
+ (UIImage *) fillSize: (CGSize) newSize image:(UIImage *) image;


@end
