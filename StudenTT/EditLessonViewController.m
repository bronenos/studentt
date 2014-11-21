//
//  EditLessonViewController.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/20/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "EditLessonViewController.h"
#import "RLMRealm.h"
#import "RLMResults.h"
#import "DayRecord.h"
#import "LessonRecord.h"
#import "SubjectRecord.h"
#import "NSDate+Utils.h"


@interface EditLessonViewController() <UIPickerViewDataSource, UIPickerViewDelegate>
@property(nonatomic, weak) IBOutlet UIButton *startTimeButton;
@property(nonatomic, weak) IBOutlet UIButton *endTimeButton;
@property(nonatomic, strong) IBOutlet UIPickerView *subjectPicker;
@property(nonatomic, strong) IBOutlet UIDatePicker *timePicker;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *subjectConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *timeConstraint;

@property(nonatomic, strong) RLMResults *subjectResults;
@property(nonatomic, weak) UIButton *activeTimeButton;

- (void)showSubjectPicker;
- (void)showTimePicker;
- (void)updateTimeButtons;

- (IBAction)doOpenTimePicker:(UIButton *)sender;
- (IBAction)doDoneTimePicker:(UIButton *)sender;
- (IBAction)doCancel;
- (IBAction)doDone;
@end


@implementation EditLessonViewController
#pragma mark - Memory
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		self.subjectResults = [SubjectRecord allObjects];
	}
	
	return self;
}


#pragma mark - View
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if (self.lessonRecord == nil) {
		self.lessonRecord = [LessonRecord new];
	}
	else {
		[self updateTimeButtons];
	}
}


#pragma mark - Internal
- (void)showSubjectPicker
{
	self.subjectConstraint.priority = UILayoutPriorityDefaultHigh;
	self.timeConstraint.priority = UILayoutPriorityDefaultLow;
}


- (void)showTimePicker
{
	self.subjectConstraint.priority = UILayoutPriorityDefaultLow;
	self.timeConstraint.priority = UILayoutPriorityDefaultHigh;
}


- (void)updateTimeButtons
{
	NSString *startTimeString = [self.lessonRecord.startTime timeString] ?: @"0:00";
	[self.startTimeButton setTitle:startTimeString forState:UIControlStateNormal];
	
	NSString *endTimeString = [self.lessonRecord.endTime timeString] ?: @"0:00";
	[self.endTimeButton setTitle:endTimeString forState:UIControlStateNormal];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return self.subjectResults.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	SubjectRecord *subjectRecord = self.subjectResults[row];
	return subjectRecord.title;
}


#pragma mark - User
- (IBAction)doOpenTimePicker:(UIButton *)sender
{
	NSDate *date = nil;
	if (sender == self.startTimeButton) {
		date = self.lessonRecord.startTime ?: [NSDate date];
	}
	else if (sender == self.endTimeButton) {
		date = self.lessonRecord.endTime ?: [NSDate date];
	}
	
	const BOOL animated = (self.timeConstraint.priority == UILayoutPriorityDefaultHigh);
	[self.timePicker setDate:date animated:animated];
	
	self.activeTimeButton = sender;
	[self showTimePicker];
}


- (IBAction)doDoneTimePicker:(UIButton *)sender
{
	NSDate *newTime = [self.timePicker.date dateWithOnlyTime];
	
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm transactionWithBlock:^{
		if (self.activeTimeButton == self.startTimeButton) {
			self.lessonRecord.startTime = newTime;
		}
		else if (self.activeTimeButton == self.endTimeButton) {
			self.lessonRecord.endTime = newTime;
		}
	}];
	
	[self updateTimeButtons];
	[self showSubjectPicker];
}


- (IBAction)doCancel
{
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)doDone
{
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm transactionWithBlock:^{
		const NSInteger subjectIndex = [self.subjectPicker selectedRowInComponent:0];
		self.lessonRecord.subject = self.subjectResults[subjectIndex];
		
		if (self.lessonRecord.realm == nil) {
			[self.dayRecord.lessons addObject:self.lessonRecord];
			[realm addObject:self.lessonRecord];
		}
	}];
	
	[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
