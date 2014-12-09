//
//  ViewController.m
//  FlipBook
//
//  Created by Daniel Tavares on 03/12/2014.
//  Copyright (c) 2014 Daniel Tavares. All rights reserved.
//

#import "ViewController.h"
#import "Flipbook.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    v.center = self.view.center;
    [self.view addSubview:v];
    
    UIView *watchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 272, 340)];
    [self.view addSubview:watchView];
    watchView.clipsToBounds = YES;
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(-30, watchView.bounds.size.height + 30, 30, 30)];
    [redView setBackgroundColor:[UIColor redColor]];
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.f/1000.f;
    redView.layer.transform = transform;
    
    [watchView addSubview:redView];
    
    
    Flipbook *book = [Flipbook new];
    [book renderTargetView:watchView duration:1.2 imagePrefix:@"redView" frameInterval:1.0];
    
    CGRect initial = redView.frame;
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:kNilOptions animations:^{
        redView.center = watchView.center;
        redView.layer.transform = CATransform3DMakeRotation(M_PI, 1.0, 1.0, 0.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.2 usingSpringWithDamping:1.0 initialSpringVelocity:1.0 options:kNilOptions animations:^{
            redView.frame = initial;
            redView.layer.transform = CATransform3DIdentity;
        } completion:^(BOOL finished) {
            [book stopRendering];
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
