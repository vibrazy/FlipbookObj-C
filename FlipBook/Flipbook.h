//
//  Flipbook.h
//  FlipBook
//
//  Created by Daniel Tavares on 03/12/2014.
//  Copyright (c) 2014 Daniel Tavares. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface Flipbook : NSObject

- (void)renderTargetView:(UIView *)view
                duration:(NSTimeInterval)duration
             imagePrefix:(NSString *)imagePrefix
           frameInterval:(NSUInteger)frameInterval;

- (void)stopRendering;

@end
