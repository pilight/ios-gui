//
//  LoadViewController.m
//  pilight
//
//  Created by Martin Kollaard on 30-09-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import "LoadViewController.h"

@implementation LoadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"pilighthostname"]) {
        [_hostname setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"pilighthostname"]];
        [_port setText:[[NSUserDefaults standardUserDefaults] objectForKey:@"pilightport"]];
        [self connecToServer];
    }
    
	// Do any additional setup after loading the view.
}

- (void)setErrorMessage:(NSString *)errorMessage {
    _errorMessage = errorMessage;
    [_errorMessageLabel setText:errorMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_errorMessageLabel setText:_errorMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connect:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:_hostname.text forKey:@"pilighthostname"];
    [[NSUserDefaults standardUserDefaults] setObject:_port.text forKey:@"pilightport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self connecToServer];
}

- (void)connecToServer {
    [[PilightController shared] connectWithHostname:_hostname.text port:[_port.text intValue]];
}

@end
