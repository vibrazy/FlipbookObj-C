//
//  Flipbook.m
//  FlipBook
//
//  Created by Daniel Tavares on 03/12/2014.
//  Copyright (c) 2014 Daniel Tavares. All rights reserved.
//

#import "Flipbook.h"

@interface UIView (Flipbook)
@end
@implementation UIView (Flipbook)

- (UIImage *)snapshotImage
{
    // Want to create an image context - the size of complex view and the scale of the device screen
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    
    // Render our snapshot into the image context
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    
    // Grab the image from the context
    UIImage *complexViewImage = UIGraphicsGetImageFromCurrentImageContext();
    // Finish using the context
    UIGraphicsEndImageContext();
    
    return complexViewImage;
}
@end

#pragma mark - Implementation
@interface Flipbook()
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation Flipbook
{
    UIView *_targetView;
    NSTimeInterval _duration;
    CFTimeInterval _startTime;
    NSString *_imagePrefix;
    NSUInteger _imageCounter;
    BOOL _forceStop;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        
    }
    
    return self;
}


#pragma mark - Render
- (void)renderTargetView:(UIView *)view
                duration:(NSTimeInterval)duration
             imagePrefix:(NSString *)imagePrefix
           frameInterval:(NSUInteger)frameInterval
{
    _targetView = view;
    _duration = duration;
    _imagePrefix = imagePrefix;
    _imageCounter = 0;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick:)];
    self.displayLink.frameInterval = frameInterval;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop]
                       forMode:NSDefaultRunLoopMode];
    
    NSLog(@"[Flipbook] Starting capture...");
}


#pragma mark - Link Tick
- (void)displayLinkTick:(CADisplayLink *)sender
{
    if (!_startTime)
    {
        _startTime = sender.timestamp;
    }
    
    [self renderViewToImage:_targetView];
    
    if (sender.timestamp - _startTime > _duration || _forceStop)
    {
        [sender invalidate];
        [sender removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        
        NSLog(@"[Flipbook] Images exported to: %@", [[self class] applicationDocumentsDirectory]);
        NSLog(@"[Flipbook] Capture complete!");
    }
}

- (void)renderViewToImage:(UIView *)view
{
    UIImage *image = [view snapshotImage];
    
    if (image)
    {
        NSString *imagePath = [self newImagePath];
        
        if (imagePath)
        {
            // save this shit
            [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
        }
    }
}

- (NSString *)newImagePath
{
    return [[[self class] applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%lu@2x.png",_imagePrefix, (unsigned long)_imageCounter++]];
}

+ (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}


- (void)stopRendering
{
    _forceStop = YES;
}

#pragma mark - Category




@end

