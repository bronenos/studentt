//
//  ConfigViewController.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/19/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "LessonsViewController.h"
#import "EditLessonViewController.h"
#import "RLMRealm.h"
#import "RLMResults.h"
#import "ConfigRecord.h"
#import "DayRecord.h"
#import "LessonCell.h"
#import "NSDate+Utils.h"


static NSString * const kAddLessonCellReuseID	= @"AddLessonCell";
static NSString * const kLessonCellReuseID		= @"LessonCell";
static NSString * const kAddLessonSegueID		= @"AddLesson";
static NSString * const kEditLessonSegueID		= @"EditLesson";


typedef NS_ENUM(NSInteger, WeekType) {
	WeekTypeCommon,
	WeekTypeOdd,
	WeekTypeEven
};


@interface LessonsViewController() <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) IBOutlet UISegmentedControl *weekTypeControl;
@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, strong) RLMResults *timetableResults;

- (void)setupWeekTypeControl;
- (void)populateTable;

- (IBAction)doSwitchWeeks:(UISegmentedControl *)sender;
@end


@implementation LessonsViewController
#pragma mark - View
- (void)viewDidLoad
{
	[super viewDidLoad];
	[self setupWeekTypeControl];
	[self populateTable];
}


#pragma mark - Internal
- (void)setupWeekTypeControl
{
	RLMRealm *realm = [AppHelper sharedRealm];
	ConfigRecord *configRecord = [[ConfigRecord allObjectsInRealm:realm] firstObject];
	
	if (configRecord.commonMode) {
		self.weekTypeControl.selectedSegmentIndex = WeekTypeCommon;
	}
	else {
		const day_config_t dc = [AppHelper todayConfig];
		self.weekTypeControl.selectedSegmentIndex = dc.is_odd ? WeekTypeOdd : WeekTypeEven;
	}
}


- (void)populateTable
{
	const NSInteger segmentIndex = self.weekTypeControl.selectedSegmentIndex;
	const BOOL oddFilter = (segmentIndex == WeekTypeCommon || segmentIndex == WeekTypeOdd);
	
	RLMResults *timetableResults = [DayRecord objectsInRealm:[AppHelper sharedRealm]
													   where:@"oddWeek == %@", @(oddFilter)];
	self.timetableResults = [timetableResults sortedResultsUsingProperty:@"weekday" ascending:YES];
	
	[self.tableView reloadData];
}


#pragma mark - NSSeguePerforming
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([@[ kAddLessonSegueID, kEditLessonSegueID ] containsObject:segue.identifier]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		EditLessonViewController *vc = segue.destinationViewController;
		
		DayRecord *dayRecord = self.timetableResults[indexPath.section];
		vc.dayRecord = dayRecord;
		
		if (indexPath.row < dayRecord.lessons.count) {
			LessonRecord *lessonRecord = dayRecord.lessons[indexPath.row];
			vc.lessonRecord = lessonRecord;
		}
	}
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [NSDate sharedFormatter].standaloneWeekdaySymbols.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [NSDate sharedFormatter].standaloneWeekdaySymbols[section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	DayRecord *dayRecord = self.timetableResults[section];
	return dayRecord.lessons.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DayRecord *dayRecord = self.timetableResults[indexPath.section];
	if (indexPath.row < dayRecord.lessons.count) {
		LessonRecord *lessonRecord = dayRecord.lessons[indexPath.row];
		
		LessonCell *cell = (id) [tableView dequeueReusableCellWithIdentifier:kLessonCellReuseID];
		[cell configureWithLesson:lessonRecord];
		return cell;
	}
	else {
		UITableViewCell *cell = (id) [tableView dequeueReusableCellWithIdentifier:kAddLessonCellReuseID];
		return cell;
	}
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	DayRecord *dayRecord = self.timetableResults[indexPath.section];
	if (indexPath.row < dayRecord.lessons.count) {
		return UITableViewCellEditingStyleDelete;
	}
	else {
		return UITableViewCellEditingStyleNone;
	}
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	RLMRealm *realm = [AppHelper sharedRealm];
	[realm transactionWithBlock:^{
		DayRecord *dayRecord = self.timetableResults[indexPath.section];
		LessonRecord *lessonRecord = dayRecord.lessons[indexPath.row];
		
		[dayRecord.lessons removeObjectAtIndex:indexPath.row];
		[realm deleteObject:lessonRecord];
	}];
}


#pragma mark - User
- (IBAction)doSwitchWeeks:(UISegmentedControl *)sender
{
	RLMRealm *realm = [AppHelper sharedRealm];
	[realm transactionWithBlock:^{
		ConfigRecord *configRecord = [[ConfigRecord allObjectsInRealm:realm] firstObject];
		configRecord.commonMode = (sender.selectedSegmentIndex == 0);
	}];
	
	[self populateTable];
}


#pragma mark - Events
- (void)onRealmDidUpdate:(NSString *)note
{
	[self.tableView reloadData];
}
@end
