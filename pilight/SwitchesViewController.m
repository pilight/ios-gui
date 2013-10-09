//
//  SwitchesViewController.m
//  pilight
//
//  Created by Martin Kollaard on 30-09-13.
//  Copyright (c) 2013 Martin Kollaard. All rights reserved.
//

#import "SwitchesViewController.h"
#import "SwitchCell.h"
#import "DimmerCell.h"

@interface SwitchesViewController ()

@end

@implementation SwitchesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = [self.room name];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.room devices] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self.room devices] objectAtIndex:indexPath.row] isKindOfClass:[PLSwitch class]]) {
        PLSwitch *item = [[self.room devices] objectAtIndex:indexPath.row];
        if ([item type] == 1) {
            static NSString *SwitchCellIdentifier = @"SwitchCell";
            SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellIdentifier];
            if (cell == nil) {
                cell = [[SwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SwitchCellIdentifier];
            }
            
            [cell setDevice:item];
            
            return cell;
        } else if ([item type] == 2) {
            static NSString *DimmerCellIdentifier = @"DimmerCell";
            DimmerCell *cell = [tableView dequeueReusableCellWithIdentifier:DimmerCellIdentifier];
            if (cell == nil) {
                cell = [[DimmerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DimmerCellIdentifier];
            }
            
            [cell setDevice:item];
            
            return cell;
        }
    }
    
    

    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    [[cell textLabel] setText:@"unknown type"];
        
    return cell;

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSMutableDictionary *item = [[self.room objectForKey:@"devices"] objectAtIndex:indexPath.row];
    
    if ([[[self.room devices] objectAtIndex:indexPath.row] isKindOfClass:[PLSwitch class]]) {
        PLSwitch *item = [[self.room devices] objectAtIndex:indexPath.row];
        if ([item type] == 1) {
            return [SwitchCell heightForDevice:item atIndexPath:indexPath];
        } else if ([item type] == 2) {
            return [DimmerCell heightForDevice:item atIndexPath:indexPath];
        }
    }

    return 44.0f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
