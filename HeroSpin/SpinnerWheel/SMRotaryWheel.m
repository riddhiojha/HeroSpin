
#import "SMRotaryWheel.h"
#import <QuartzCore/QuartzCore.h>
#import "SMCLove.h"

@interface SMRotaryWheel()
@property (retain, nonatomic) NSArray *characterArray;
    - (void)drawWheel;
    - (float) calculateDistanceFromCenter:(CGPoint)point;
    - (void) buildClovesEven;
    - (void) buildClovesOdd;
    - (UIImageView *) getCloveByValue:(int)value;
    - (NSString *) getCloveName:(int)position;
@end

static float deltaAngle;
static float minAlphavalue = 0.8;
static float maxAlphavalue = 1.0;

@implementation SMRotaryWheel

@synthesize delegate, container, numberOfSections, startTransform, cloves, currentValue;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber {
    
    if ((self = [super initWithFrame:frame])) {
		
        self.currentValue = 0;
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
		[self drawWheel];
	}
    return self;
}



- (void) drawWheel {
    container = [[UIView alloc] initWithFrame:self.frame];
    CGFloat angleSize = 2*M_PI/numberOfSections;
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Characters" ofType:@"plist"]];
    self.characterArray = [dictionary objectForKey:@"Marvel"];
    if (numberOfSections != self.characterArray.count) { //checking if DC is pressed
        self.characterArray = [dictionary objectForKey:@"DCComics"];
    }

    for (int i = 0; i < numberOfSections; i++) {
        
        UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segment.png"]];
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x, 
                                        container.bounds.size.height/2.0-container.frame.origin.y); 
        im.transform = CGAffineTransformMakeRotation(angleSize*i);
        im.alpha = minAlphavalue;
        im.tag = i;
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(25, 45, 75, 60)];
        labelName.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16];
        labelName.text = self.characterArray[i];
        labelName.numberOfLines = 3;
        labelName.textColor = [UIColor whiteColor];
        [im addSubview:labelName];
        [container addSubview:im];
    }
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    cloves = [NSMutableArray arrayWithCapacity:numberOfSections];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.frame];
    bg.image = [UIImage imageNamed:@"bg.png"];
    [self addSubview:bg];
    if (numberOfSections % 2 == 0) {
        [self buildClovesEven];
    } else {
        [self buildClovesOdd];
    }
    [self.delegate wheelDidChangeValue:[self getCloveName:currentValue]];
}


- (UIImageView *) getCloveByValue:(int)value {
    UIImageView *res;
    NSArray *views = [container subviews];
    for (UIImageView *im in views) {
        if (im.tag == value)
            res = im;
    }
    return res;
}

- (void) buildClovesEven {
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    for (int i = 0; i < numberOfSections; i++) {
        SMClove *clove = [[SMClove alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        if (clove.maxValue-fanWidth < - M_PI) {
            mid = M_PI;
            clove.midValue = mid;
            clove.minValue = fabsf(clove.maxValue);
        }
        mid -= fanWidth;
        [cloves addObject:clove];
    }
}

- (void) buildClovesOdd {
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    for (int i = 0; i < numberOfSections; i++) {
        SMClove *clove = [[SMClove alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        mid -= fanWidth;
        if (clove.minValue < - M_PI) {
            mid = -mid;
            mid -= fanWidth; 
        }
        [cloves addObject:clove];
    }
}

- (float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrt(dx*dx + dy*dy);
    
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchPoint = [touch locationInView:self];
	float dx = touchPoint.x - container.center.x;
	float dy = touchPoint.y - container.center.y;
	deltaAngle = atan2(dy,dx); 
    startTransform = container.transform;
    UIImageView *im = [self getCloveByValue:currentValue];
    im.alpha = minAlphavalue;
    return YES;
    
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint pt = [touch locationInView:self];
	float dx = pt.x  - container.center.x;
	float dy = pt.y  - container.center.y;
	float ang = atan2(dy,dx);
    float angleDifference = deltaAngle - ang;
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    return YES;
	
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    CGFloat newVal = 0.0;
    for (SMClove *c in cloves) {
        if (c.minValue > 0 && c.maxValue < 0) { // anomalous case
            if (c.maxValue > radians || c.minValue < radians) {
                if (radians > 0) { // we are in the positive quadrant
                    newVal = radians - M_PI;
                } else
                { // we are in the negative one
                    newVal = M_PI + radians;
                }
                currentValue = c.value;
            }
        }
        else if (radians > c.minValue && radians < c.maxValue) {
            newVal = radians - c.midValue;
            currentValue = c.value;
        }
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    [UIView commitAnimations];
    [self.delegate wheelDidChangeValue:[self getCloveName:currentValue]];
    UIImageView *im = [self getCloveByValue:currentValue];
    im.alpha = maxAlphavalue;
    
}

- (void) rotateToNearestClove
{
    UIImageView *im = [self getCloveByValue:currentValue];
    im.alpha = minAlphavalue;
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    CGFloat newVal = 0.0;
    for (SMClove *c in cloves) {
        if (c.minValue > 0 && c.maxValue < 0) { // anomalous case
            if (c.maxValue > radians || c.minValue < radians) {
                if (radians > 0) { // we are in the positive quadrant
                    newVal = radians - M_PI;
                } else { // we are in the negative one
                    newVal = M_PI + radians;
                }
                currentValue = c.value;
            }
        }
        else if (radians > c.minValue && radians < c.maxValue) {
            newVal = radians - c.midValue;
            currentValue = c.value;
        }
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    [UIView commitAnimations];
    [self.delegate wheelDidChangeValue:[self getCloveName:currentValue]];
    im = [self getCloveByValue:currentValue];
    im.alpha = maxAlphavalue;
    
}

- (NSString *) getCloveName:(int)position {
    NSString *res = self.characterArray[position];
    return res;
}



@end
