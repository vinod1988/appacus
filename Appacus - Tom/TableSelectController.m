//
//  TableSelectController.m
//  Appacus - Tom
//
//  Created by Matthew Nieuwenhuys on 09/02/2013.
//  Copyright (c) 2013 Matthew Nieuwenhuys. All rights reserved.
//

#import "TableSelectController.h"

@interface TableSelectController ()

@end

@implementation TableSelectController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  ViewController *viewController = segue.destinationViewController;
  int level = [sender tag];
  viewController.gameLevel = level;
  [viewController initialise];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) playMovie:(id)sender
{
  NSString *filepath   =   [[NSBundle mainBundle] pathForResource:@"2 Times Table" ofType:@"mp4"];
  NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
  MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(moviePlaybackComplete:)
                                               name:MPMoviePlayerPlaybackDidFinishNotification
                                             object:player];
  
  player.controlStyle = MPMovieControlStyleDefault;
  player.shouldAutoplay = YES;
  [self.view addSubview:player.view];
  [player setFullscreen:YES animated: YES];
  NSLog(@"%@",fileURL);
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
  MPMoviePlayerController *moviePlayerController = [notification object];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:MPMoviePlayerPlaybackDidFinishNotification
                                                object:moviePlayerController];
  [moviePlayerController.view removeFromSuperview];
}

@end
