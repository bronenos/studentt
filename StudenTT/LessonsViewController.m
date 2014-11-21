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
#import "DayRecord.h"
#import "LessonCell.h"
#import "NSDate+Utils.h"


static NSString * const kAddLessonCellReuseID	= @"AddLessonCell";
static NSString * const kLessonCellReuseID		= @"LessonCell";
static NSString * const kAddLessonSegueID		= @"AddLesson";
static NSString * const kEditLessonSegueID		= @"EditLesson";


@interface LessonsViewController() <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) IBOutlet UISegmentedControl *weekTypeControl;
@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, strong) RLMRealm *realm;
@property(nonatomic, strong) RLMResults *timetableResults;
@property(nonatomic, strong) RLMNotificationToken *realmToken;

- (void)registerRealm;
- (void)unregisterRealm;

- (void)generateDays;
- (void)populateTable;

- (IBAction)doSwitchWeeks;
@end


@implementation LessonsViewController
#pragma mark - Memory
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		[self registerRealm];
	}
	
	return self;
}


- (void)dealloc
{
	[self unregisterRealm];
}


#pragma mark - View
- (void)viewDidLoad
{
	[super viewDidLoad];
	[self populateTable];
}


#pragma mark - Internal
- (void)registerRealm
{
	__weak __typeof(self) weakSelf = self;
	self.realmToken = [[RLMRealm defaultRealm] addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
		[weakSelf.tableView reloadData];
	}];
}


- (void)unregisterRealm
{
	[[RLMRealm defaultRealm] removeNotification:self.realmToken];
}


- (void)generateDays
{
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm transactionWithBlock:^{
		const NSInteger cnt = [NSDate dateFormatter].weekdaySymbols.count;
		for (NSUInteger i=0; i<cnt; i++) {
			DayRecord *dayRecord;
			
			dayRecord = [DayRecord new];
			dayRecord.oddWeek = NO;
			dayRecord.weekday = i;
			[realm addObject:dayRecord];
			
			dayRecord = [DayRecord new];
			dayRecord.oddWeek = YES;
			dayRecord.weekday = i;
			[realm addObject:dayRecord];
		}
	}];
}


- (void)populateTable
{
	const NSInteger oddFilter = self.weekTypeControl.selectedSegmentIndex;
	self.timetableResults = [DayRecord objectsWhere:@"oddWeek == %@", @(oddFilter)];
	
	if (self.timetableResults.count == 0) {
		[self generateDays];
	}
	
	[self.tableView reloadData];
}


#pragma mark - NSSeguePerforming
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([@[ kAddLessonSegueID, kEditLessonSegueID ] containsObject:segue.identifier]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		UINavigationController *nc = segue.destinationViewController;
		EditLessonViewController *vc = [nc.viewControllers firstObject];
		
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
	return [NSDate dateFormatter].standaloneWeekdaySymbols.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [NSDate dateFormatter].standaloneWeekdaySymbols[section];
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
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm transactionWithBlock:^{
		DayRecord *dayRecord = self.timetableResults[indexPath.section];
		LessonRecord *lessonRecord = dayRecord.lessons[indexPath.row];
		
		[dayRecord.lessons removeObjectAtIndex:indexPath.row];
		[realm deleteObject:lessonRecord];
	}];
}


#pragma mark - User
- (IBAction)doSwitchWeeks
{
	[self populateTable];
}
@end
