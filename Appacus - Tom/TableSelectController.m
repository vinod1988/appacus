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

@end
