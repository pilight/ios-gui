//
//  SwitchCell.h
//  pilight
//
//  Created by Martin Kollaard on 02-10-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchCell : UITableViewCell


@property (nonatomic,strong) PLSwitch *device;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UISwitch *onOffSwitch;

+(CGFloat)heightForDevice:(PLSwitch *)device atIndexPath:(NSIndexPath *)indexPath;

@end
