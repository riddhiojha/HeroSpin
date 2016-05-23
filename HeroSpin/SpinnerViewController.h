//
//  SpinnerViewController.h
//  HeroSpin
//
//  Created by Riddhi Ojha on 5/19/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"

@protocol SpinnerViewDelegate <NSObject>
-(void)setCharacterName : (NSString *)characterName;
@end


@interface SpinnerViewController : UIViewController<SMRotaryProtocol>
@property (nonatomic, assign) id <SpinnerViewDelegate> delegate;
@property (nonatomic, assign) int wheelSectionsCount;


@end
