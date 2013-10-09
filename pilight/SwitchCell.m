//
//  SwitchCell.m
//  pilight
//
//  Created by Martin Kollaard on 02-10-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import "SwitchCell.h"

@implementation SwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceChanged:) name:@"pilightDeviceChanged" object:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCell {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
        [_nameLabel setTextColor:[UIColor blackColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
 
    }

    if (!_onOffSwitch) {
        
        _onOffSwitch = [[UISwitch alloc] init];
        [_onOffSwitch setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_onOffSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_onOffSwitch];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_onOffSwitch attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[namelabel]-(>=1)-[switch]-|" options:NSLayoutFormatAlignAllBaseline metrics:Nil views:@{@"namelabel": _nameLabel, @"switch": _onOffSwitch}]];
    }
    
    [_nameLabel setText:[self.device name]];
    [_onOffSwitch setOn:[self.device state]];
}

-(void)setDevice:(PLSwitch *)device {
    if (_device != device) {
        _device = device;
        [self configureCell];
    }
}

-(void)deviceChanged:(NSNotification *)notification {
     NSLog(@"Switch changed!");
    if ([[notification object] isEqualToString:[NSString stringWithFormat:@"%@%@", [[self.device room] key], [self.device key]]]) {
        if ([_onOffSwitch isOn] != [self.device state])
            [_onOffSwitch setOn:[self.device state] animated:YES];
    }
}

-(void)switchChanged:(id)sender {
    [self.device changeToState:[sender isOn]];
}

+(CGFloat)heightForDevice:(PLSwitch *)device atIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

@end
