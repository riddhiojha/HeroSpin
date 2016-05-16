//
//  ViewController.m
//  HeroSpin
//
//  Created by Riddhi Ojha on 5/13/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Characters" ofType:@"plist"]];
    NSString *characterName = @"";
    if (indexPath.row == 0) {
        NSArray *marvelArray = [dictionary objectForKey:@"Marvel"];
        int r = arc4random_uniform((int)marvelArray.count);
        characterName = marvelArray[r];
    }
    else
    {
        NSArray *DCArray = [dictionary objectForKey:@"DCComics"];
        int r = arc4random_uniform((int)DCArray.count);
        characterName = DCArray[r];
        
    }
    DetailViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    self.delegate = newView;
    [self.navigationController pushViewController:newView animated:YES];
    characterName = [characterName stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(setCharacterName:)]) {
        [self.delegate setCharacterName:characterName];
    }
   
    
}




@end
