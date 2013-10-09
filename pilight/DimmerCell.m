//
//  DimmerCell.m
//  pilight
//
//  Created by Martin Kollaard on 03-10-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import "DimmerCell.h"

@implementation DimmerCell

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
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-20]];
        
    }
    
    if (!_onOffSwitch) {
        _onOffSwitch = [[UISwitch alloc] init];
        [_onOffSwitch setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_onOffSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_onOffSwitch];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_onOffSwitch attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-20]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-[namelabel]-(>=1)-[switch]-|" options:NSLayoutFormatAlignAllBaseline metrics:Nil views:@{@"namelabel": _nameLabel, @"switch": _onOffSwitch}]];
    }
    
    if (!_dimSlider) {
        _dimSlider = [[UISlider alloc] init];
        [_dimSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_dimSlider addTarget:self action:@selector(dimLevelChanged:) forControlEvents:UIControlEventValueChanged];
        [_dimSlider setContinuous:NO];
        [self.contentView addSubview:_dimSlider];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dimSlider attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:20]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dimSlider attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dimSlider attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:0.80 constant:0]];
    }
    
    
    [_nameLabel setText:[self.device name]];
    [_onOffSwitch setOn:[self.device state]];
    [_dimSlider setMaximumValue:[self.device maxDimlevel]];
    [_dimSlider setMinimumValue:[self.device minDimlevel]];
    [_dimSlider setValue:[self.device dimlevel]];
}

-(void)setDevice:(PLSwitch *)device {
    if (_device != device) {
        _device = device;
        [self configureCell];
    }
}

-(void)dimLevelChanged:(id)sender {
    int dimLevel = ([_dimSlider value] + 0.5);
    [self.device changeToState:YES withDimlevel:dimLevel];
    
    if (![self.onOffSwitch isOn]) [self.onOffSwitch setOn:YES animated:YES];
}

-(void)switchChanged:(id)sender {
    [self.device changeToState:[sender isOn]];
}

-(void)deviceChanged:(NSNotification *)notification {
    if ([[notification object] isEqualToString:[NSString stringWithFormat:@"%@%@", [[self.device room] key], [self.device key]]]) {
        if ([_onOffSwitch isOn] != [self.device state])
            [_onOffSwitch setOn:[self.device state] animated:YES];
        if ((int)([_dimSlider value] + 0.5) != [self.device dimlevel])
            [_dimSlider setValue:[self.device dimlevel] animated:YES];
    }
}

+(CGFloat)heightForDevice:(PLSwitch *)device atIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}
@end

