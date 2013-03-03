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

@synthesize labels;

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
  UIFont *font = [UIFont fontWithName:@"Architects Daughter" size:60];
  [labels setValue:font forKey:@"font"];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)LearnAction:(id)sender {
  NSString *filepath;
  UIButton *button = (UIButton *)sender;
  if(button.tag == 1){
    filepath = [[NSBundle mainBundle] pathForResource:@"2timestable" ofType:@"mp4"];
  }else if(button.tag == 2){
    filepath = [[NSBundle mainBundle] pathForResource:@"5timestable" ofType:@"mp4"];
  }else if(button.tag == 3){
    filepath = [[NSBundle mainBundle] pathForResource:@"10timestable" ofType:@"mp4"];
  }
  NSURL *fileURL = [NSURL fileURLWithPath:filepath];
  MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:fileURL];
  [[player moviePlayer] prepareToPlay];
  [[player moviePlayer] setShouldAutoplay:YES];
  [[player moviePlayer] setControlStyle:2];
  [[player moviePlayer] setAllowsAirPlay:YES];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
  [self presentMoviePlayerViewControllerAnimated:player];
}



@end
