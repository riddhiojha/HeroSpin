//
//  ViewController.m
//  HeroSpin
//
//  Created by Riddhi Ojha on 5/13/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "ViewController.h"
#import "SpinnerViewController.h"
#import "MainCollectionViewCell.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray       *dataArray;
@end

@implementation ViewController
@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Marvel" withExtension:@"mp4"];
    NSURL *url2 = [[NSBundle mainBundle] URLForResource:@"DCComics" withExtension:@"mp4"];
    dataArray = [[NSMutableArray alloc] initWithObjects:url, url2, nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CollectionView datasource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mainCollectionCell" forIndexPath:indexPath];
    [cell configureWithURL:dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Characters" ofType:@"plist"]];
    int count = 0;
    if (indexPath.row == 0) {
        NSArray *marvelArray = [dictionary objectForKey:@"Marvel"];
        count = (int)marvelArray.count;
    }
    else
    {
        NSArray *DCArray = [dictionary objectForKey:@"DCComics"];
        count = (int)DCArray.count;
        
    }
    SpinnerViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"spinnerView"];
    newView.wheelSectionsCount = count;
    [self.navigationController pushViewController:newView animated:YES];

}




@end
