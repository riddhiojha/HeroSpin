//
//  SpinnerViewController.h
//  HeroSpin
//
//  Created by Riddhi Ojha on 5/19/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"


@interface SpinnerViewController : UIViewController<SMRotaryProtocol>

@end


/*
 //
 //  SpinnerViewController.h
 //  HeroSpin
 //
 //  Created by Riddhi Ojha on 5/19/16.
 //  Copyright © 2016 Riddhi Ojha. All rights reserved.
 //
 
 #import <UIKit/UIKit.h>
 #import "SMWheelControl.h"
 
 
 @interface SpinnerViewController : UIViewController<SMWheelControlDelegate, SMWheelControlDataSource>
 @property (nonatomic, weak) IBOutlet UILabel *valueLabel;
 @property (nonatomic, weak) IBOutlet UIView *wheelContainer;
 @end

*/