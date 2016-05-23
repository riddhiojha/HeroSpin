//
//  DetailViewController.m
//  HeroSpin
//
//  Created by Riddhi Ojha on 5/15/16.
//  Copyright © 2016 Riddhi Ojha. All rights reserved.
//

#import "DetailViewController.h"
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *directorLabel;
@property (weak, nonatomic) IBOutlet UILabel *actorsLabel;
@property (weak, nonatomic) IBOutlet UILabel *writerLabel;
@property (weak, nonatomic) IBOutlet UITextView *plotTextView;
@property (nonatomic) CGRect framePoster;
@end

static NSString * const BaseURLString = @"http://www.omdbapi.com/?t=";
@implementation DetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - HomeViewDelegate method
-(void)setCharacterName : (NSString *)characterName
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@&y=&plot=full&r=json", BaseURLString, characterName];
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                      NSLog(@"%@", json);
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          self.framePoster = self.posterImageView.frame;
                                          self.titleLabel.text = json[@"Title"];
                                          self.genreLabel.text = json[@"Genre"];
                                          self.directorLabel.text = json[@"Director"];
                                          self.actorsLabel.text = json[@"Actors"];
                                          self.writerLabel.text = json[@"Writer"];
                                          self.plotTextView.text = json[@"Plot"];
                                          NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:json[@"Poster"]]];
                                          self.posterImageView.image = [UIImage imageWithData:imageData];
                                      });
                                  }];
    [task resume];
}

#pragma mark - TapGestureRecogniser
- (IBAction)handleImageTap:(UIGestureRecognizer *)sender
{
    if (self.posterImageView.frame.size.height == self.framePoster.size.height) {
        [UIView transitionWithView:self.posterImageView
                          duration:0.5
                           options:UIViewAnimationOptionCurveEaseInOut //any animation
                        animations:^ {
                            self.posterImageView.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
                        }
                        completion:nil];
    }
    else
    {
        [UIView transitionWithView:self.posterImageView
                          duration:0.5
                           options:UIViewAnimationOptionCurveEaseInOut //any animation
                        animations:^ {
                            self.posterImageView.frame=CGRectMake(0,0,self.framePoster.size.width,self.framePoster.size.height);
                        }
                        completion:nil];
    }
}
@end
