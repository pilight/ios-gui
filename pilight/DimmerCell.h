//
//  DimmerCell.h
//  pilight
//
//  Created by Martin Kollaard on 03-10-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DimmerCell : UITableViewCell


@property (nonatomic,strong) PLSwitch *device;

@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UISwitch *onOffSwitch;
@property (nonatomic,strong) UISlider *dimSlider;

+(CGFloat)heightForDevice:(PLSwitch *)device atIndexPath:(NSIndexPath *)indexPath;

@end