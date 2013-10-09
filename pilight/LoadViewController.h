//
//  LoadViewController.h
//  pilight
//
//  Created by Martin Kollaard on 30-09-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *hostname;
@property (strong, nonatomic) IBOutlet UITextField *port;
@property (strong, nonatomic) IBOutlet UILabel *errorMessageLabel;
@property (strong, nonatomic) NSString *errorMessage;

- (IBAction)connect:(id)sender;

@end
