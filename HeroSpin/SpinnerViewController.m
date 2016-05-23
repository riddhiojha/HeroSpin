//
//  SpinnerViewController.m
//  HeroSpin
//
//  Created by Riddhi Ojha on 5/19/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "SpinnerViewController.h"
#import "SMRotaryWheel.h"

@interface SpinnerViewController ()
@property (nonatomic, retain) SMRotaryWheel *wheel;
@property (weak, nonatomic) IBOutlet UIView *mainSpinnerView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation SpinnerViewController
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.wheel = [[SMRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenWidth)
                                                    andDelegate:self
                                                   withSections:8];
    self.wheel.center = CGPointMake(screenWidth/2, screenHeight/2);
    [self.mainSpinnerView addSubview:self.wheel];
    [self spinTheWheel];
}

- (void) wheelDidChangeValue:(NSString *)newValue {
//    self.valueLabel.text = newValue;
    
}

- (void) spinTheWheel
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 2.0;
    
    [self.wheel.container.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    int degree = arc4random_uniform(360);
    [UIView beginAnimations:UIViewAnimationTransitionNone context:NULL];
    [UIView setAnimationDuration:2.0];
    double rads = DEGREES_TO_RADIANS(degree);
    CGAffineTransform transform = CGAffineTransformRotate(self.wheel.container.transform,rads);
    self.wheel.container.transform = transform;
    [UIView commitAnimations];
    [self.wheel rotateToNearestClove];
    
}


#pragma mark - Button press events

- (IBAction)spinPressed:(id)sender {
    [self spinTheWheel];
}

- (IBAction)gotoDetails:(id)sender {
}
@end
