

#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"

@interface SMRotaryWheel : UIControl

@property (weak) id <SMRotaryProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *cloves;
@property int currentValue;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;
- (void) rotateToNearestClove;


@end
