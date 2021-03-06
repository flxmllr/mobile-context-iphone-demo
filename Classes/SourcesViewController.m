//
//  SourcesViewController.m
//  ContextDemo
//
//  Created by Felix on 22.01.10.
//  Copyright 2010 Felix Mueller (felixmueller@mac.com). All rights reserved.
//

#import "SourcesViewController.h"
#import "UISourceSwitch.h"


@implementation SourcesViewController

@synthesize contextSources;

- (void)refreshSources:(id)sender
{
	
	// Get the application delegate with the context service
	ContextDemoAppDelegate *delegate = (ContextDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// Get all context soures
	self.contextSources = [delegate.contextService getContextSources];
	
	// Reload table view
	[self.tableView reloadData];
	
}

- (BOOL)getStateForContextSource:(NSString *)source {
	
	// Get the application delegate with the context service
	ContextDemoAppDelegate *delegate = (ContextDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// Return the state from the context service
	return [delegate.contextService contextSourceEnabled:source];
}

- (void)setStateForContextSource:(id)sender {
	
	// Get the application delegate with the context service
	ContextDemoAppDelegate *delegate = (ContextDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	// Enable or disable the context source
	if ([sender isOn])
		[delegate.contextService enableContextSource:[sender source]];
	else
		[delegate.contextService disableContextSource:[sender source]];
	
	// Reload table view
	[self.tableView reloadData];
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Refresh button
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshSources:)];
	
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	// Refresh the attributes at view loading
	[self refreshSources:self];
}

/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release anything that can be recreated in viewDidLoad or on demand.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [contextSources count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	ContextDemoAppDelegate *delegate = (ContextDemoAppDelegate *)[[UIApplication sharedApplication] delegate];
	cell.textLabel.text = [contextSources objectAtIndex:indexPath.row];
	//cell.detailTextLabel.numberOfLines = 2;
	cell.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
	cell.detailTextLabel.text = [[[[[delegate.contextService getSourceAttributes:[contextSources objectAtIndex:indexPath.row]] description] stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	// Add a state switch for each row
	UISourceSwitch* stateSwitch = [[UISourceSwitch alloc] init];
	stateSwitch.source = [contextSources objectAtIndex:indexPath.row];

	// Set the switch state
	stateSwitch.on = [self getStateForContextSource:[contextSources objectAtIndex:indexPath.row]];

	// Set the switch action
	[stateSwitch addTarget:self action:@selector(setStateForContextSource:) forControlEvents:UIControlEventValueChanged];

	cell.accessoryView = stateSwitch;
	[stateSwitch release];
	
    return cell;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;	
}
*/

/*
 // Override to support row selection in the table view.
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 // Navigation logic may go here -- for example, create and push another view controller.
 // AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
 // [self.navigationController pushViewController:anotherViewController animated:YES];
 // [anotherViewController release];
 }
 */


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
    [super dealloc];
}


@end

