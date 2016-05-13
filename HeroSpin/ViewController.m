//
//  ViewController.m
//  HeroSpin
//
//  Created by Riddhi Ojha on 5/13/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "ViewController.h"
#import "MainCollectionViewCell.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray       *dataArray;
@end

@implementation ViewController
@synthesize dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
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




@end
