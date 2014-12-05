//
//  EditLessonViewController.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "EditLessonViewController.h"
#import "EditSubjectViewController.h"
#import "SubjectCell.h"
#import "RLMRealm.h"
#import "RLMResults.h"
#import "DayRecord.h"
#import "LessonRecord.h"
#import "SubjectRecord.h"
#import "AppHelper.h"
#import "NSDate+Utils.h"
#import "NSString+Utils.h"


static NSString * const kSubjectCellReuseID		= @"SubjectCell";
static NSString * const kAddSubjectCellReuseID	= @"AddSubjectCell";


@interface EditLessonViewController() <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) IBOutlet UITableView *subjectTableView;
@property(nonatomic, weak) IBOutlet UIDatePicker *startTimePicker;
@property(nonatomic, weak) IBOutlet UIDatePicker *endTimePicker;

@property(nonatomic, strong) LessonRecord *tmpLessonRecord;
@property(nonatomic, strong) RLMResults *subjectResults;
@property(nonatomic, weak) UIButton *activeTimeButton;

- (IBAction)doCancel;
- (IBAction)doDone;
@end


@implementation EditLessonViewController
#pragma mark - Memory
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		self.subjectResults = [SubjectRecord allObjectsInRealm:[AppHelper sharedRealm]];
	}
	
	return self;
}


#pragma mark - View
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.lessonRecord) {
		self.tmpLessonRecord = [self.lessonRecord copy];
	}
	else {
		self.tmpLessonRecord = [LessonRecord new];
		self.tmpLessonRecord.subject = [self.subjectResults firstObject];
		self.tmpLessonRecord.startTime = [NSDate date];
		self.tmpLessonRecord.endTime = [self.tmpLessonRecord.startTime dateByAddingTimeInterval:3600];
	}
	
	self.startTimePicker.date = self.tmpLessonRecord.startTime;
	self.endTimePicker.date = self.tmpLessonRecord.endTime;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.subjectTableView reloadData];
}


- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	
	self.startTimePicker.superview.frame = CGRectIntegral(self.startTimePicker.superview.frame);
	self.endTimePicker.superview.frame = CGRectIntegral(self.endTimePicker.superview.frame);
}


#pragma mark - UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [@"Choose a subject" loc];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.subjectResults.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < self.subjectResults.count) {
		SubjectRecord *subjectRecord = self.subjectResults[indexPath.row];
		const BOOL isActiveSubject = [self.tmpLessonRecord.subject isEqualToObject:subjectRecord];
		
		SubjectCell *cell = (id) [tableView dequeueReusableCellWithIdentifier:kSubjectCellReuseID];
		[cell configureWithSubject:subjectRecord isActive:isActiveSubject];
		return cell;
	}
	else {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddSubjectCellReuseID];
		return cell;
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row < self.subjectResults.count) {
		SubjectRecord *subjectRecord = self.subjectResults[indexPath.row];
		self.tmpLessonRecord.subject = subjectRecord;
		
		[self.subjectTableView reloadData];
	}
	else {
		[self.subjectTableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}


#pragma mark - User
- (IBAction)doCancel
{
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)doDone
{
	RLMRealm *realm = [AppHelper sharedRealm];
	[realm transactionWithBlock:^{
		if (self.lessonRecord) {
			[realm deleteObject:self.lessonRecord];
		}
		
		self.tmpLessonRecord.startTime = [self.startTimePicker.date dateWithOnlyTimeAndSeconds:NO];
		self.tmpLessonRecord.endTime = [self.endTimePicker.date dateWithOnlyTimeAndSeconds:NO];
		[self.dayRecord.lessons addObject:self.tmpLessonRecord];
		
		NSArray *sortedLessons = [AppHelper objects:self.dayRecord.lessons
											 sortedBy:@"startTime"
											ascending:YES];
		
		[self.dayRecord.lessons removeAllObjects];
		[self.dayRecord.lessons addObjects:sortedLessons];
	}];
	
	[self.navigationController popViewControllerAnimated:YES];
}
@end
