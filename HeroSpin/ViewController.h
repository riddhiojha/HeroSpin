//
//  ViewController.h
//  HeroSpin
//
//  Created by Riddhi Ojha on 5/13/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeViewDelegate <NSObject>

-(void)setCharacterName : (NSString *)characterName;

@end


@interface ViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
{
}
@property (nonatomic, assign) id <HomeViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@end


