//
//  TodayViewController.m
//  Today
//
//  Created by Stan Potemkin on 12/1/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import <NotificationCenter/NotificationCenter.h>
#import "TodayViewController.h"
#import "AppHelper.h"
#import "DayRecord.h"
#import "LessonRecord.h"
#import "LessonDetails.h"
#import "NSDate+Utils.h"
#import "NSString+Utils.h"


@interface TodayViewController() <NCWidgetProviding>
@property(nonatomic, weak) IBOutlet UILabel *nowGroupLabel;
@property(nonatomic, weak) IBOutlet UILabel *nowSubjectTimeLabel;
@property(nonatomic, weak) IBOutlet UILabel *nowLocationTeacherLabel;
@property(nonatomic, weak) IBOutlet UILabel *nextGroupLabel;
@property(nonatomic, weak) IBOutlet UILabel *nextSubjectWhereLabel;

@property(nonatomic, weak) NSTimer *refreshTimer;

- (void)buildInterface;
- (void)setWidgetHeightWithLabel:(UILabel *)label;

- (void)hideAllObjects;
- (void)showObjectsForFreeDay;
- (void)showObjectsForFreeTime;
- (void)showObjectsForFirstLesson:(LessonRecord *)firstLessonRecord;
- (void)showObjectsForNowLesson:(LessonRecord *)nowLessonRecord nextLesson:(LessonRecord *)nextLessonRecord;
- (void)showObjectsForNextLesson:(LessonRecord *)nextLessonRecord;

- (void)scheduleRefreshTimerForTime:(NSDate *)timeDate;
- (void)onRefreshTimer;

- (IBAction)doOpenApp;
@end


@implementation TodayViewController
#pragma mark - Lifecycle
- (void)widgetPerformUpdateWithCompletionHandler:(void(^)(NCUpdateResult))completionHandler
{
    completionHandler(NCUpdateResultNewData);
}


#pragma mark - View
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self buildInterface];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self.refreshTimer invalidate];
}


#pragma mark - Internal
- (void)buildInterface
{
	[self hideAllObjects];
	
	DayRecord *dayRecord = [AppHelper getDayRecord];
	if (dayRecord.lessons.count) {
		NSDate *nowTime = [[NSDate date] dateWithOnlyTimeAndSeconds:YES];
		
		for (NSInteger i=0, cnt=dayRecord.lessons.count; i<cnt; i++) {
			LessonRecord *lessonRecord = dayRecord.lessons[i];
			
			if ([nowTime isDuringLesson:lessonRecord]) {
				if (i == cnt - 1) {
					[self showObjectsForNowLesson:lessonRecord nextLesson:nil];
					return;
				}
				else {
					LessonRecord *nextLessonRecord = dayRecord.lessons[i + 1];
					[self showObjectsForNowLesson:lessonRecord nextLesson:nextLessonRecord];
					return;
				}
			}
			else if ([nowTime isBeforeLesson:lessonRecord]) {
				if (i == 0) {
					[self showObjectsForFirstLesson:lessonRecord];
					return;
				}
				else {
					[self showObjectsForNextLesson:lessonRecord];
					return;
				}
			}
		}
		
		[self showObjectsForFreeTime];
	}
	else {
		[self showObjectsForFreeDay];
	}
}


- (void)setWidgetHeightWithLabel:(UILabel *)label
{
	const CGFloat w = self.view.bounds.size.width;
	const CGFloat h = CGRectGetMaxY(label.frame) + CGRectGetMinY(self.nowGroupLabel.frame);
	self.preferredContentSize = CGSizeMake(w, h);
}


- (void)hideAllObjects
{
	self.nowGroupLabel.hidden = YES;
	self.nowSubjectTimeLabel.hidden = YES;
	self.nowLocationTeacherLabel.hidden = YES;
	self.nextGroupLabel.hidden = YES;
	self.nextSubjectWhereLabel.hidden = YES;
}


- (void)showObjectsForFreeDay
{
	self.nowGroupLabel.hidden = NO;
	self.nowGroupLabel.text = [@"Free day" loc];
	
	[self setWidgetHeightWithLabel:self.nowGroupLabel];
}


- (void)showObjectsForFreeTime
{
	self.nowGroupLabel.hidden = NO;
	self.nowGroupLabel.text = [@"Free time" loc];
	
	[self setWidgetHeightWithLabel:self.nowGroupLabel];
}


- (void)showObjectsForFirstLesson:(LessonRecord *)firstLessonRecord
{
	LessonDetails *firstDetails = [LessonDetails lessonDetailsWithRecord:firstLessonRecord];
	
	self.nowGroupLabel.hidden = NO;
	self.nowGroupLabel.text = [@"First" loc];
	
	self.nowSubjectTimeLabel.hidden = NO;
	self.nowSubjectTimeLabel.text = [firstDetails subjectTimeString];
	
	self.nowLocationTeacherLabel.hidden = NO;
	self.nowLocationTeacherLabel.text = [firstDetails locationTeacherString];
	
	[self setWidgetHeightWithLabel:self.nowLocationTeacherLabel];
	[self scheduleRefreshTimerForTime:firstLessonRecord.startTime];
}


- (void)showObjectsForNowLesson:(LessonRecord *)nowLessonRecord nextLesson:(LessonRecord *)nextLessonRecord
{
	LessonDetails *nowDetails = [LessonDetails lessonDetailsWithRecord:nowLessonRecord];
	
	self.nowGroupLabel.hidden = NO;
	self.nowGroupLabel.text = [@"Now" loc];
	
	self.nowSubjectTimeLabel.hidden = NO;
	self.nowSubjectTimeLabel.text = [nowDetails subjectTimeString];
	
	self.nowLocationTeacherLabel.hidden = NO;
	self.nowLocationTeacherLabel.text = [nowDetails locationTeacherString];
	
	if (nextLessonRecord == nil) {
		[self setWidgetHeightWithLabel:self.nowLocationTeacherLabel];
	}
	else {
		LessonDetails *nextDetails = [LessonDetails lessonDetailsWithRecord:nextLessonRecord];
		
		self.nextGroupLabel.hidden = NO;
		self.nextGroupLabel.text = [@"Next" loc];
		
		self.nextSubjectWhereLabel.hidden = NO;
		self.nextSubjectWhereLabel.text = [nextDetails subjectLocationString];
		
		[self setWidgetHeightWithLabel:self.nextSubjectWhereLabel];
	}
	
	[self scheduleRefreshTimerForTime:nowLessonRecord.endTime];
}


- (void)showObjectsForNextLesson:(LessonRecord *)nextLessonRecord
{
	LessonDetails *nextDetails = [LessonDetails lessonDetailsWithRecord:nextLessonRecord];
	
	self.nowGroupLabel.hidden = NO;
	self.nowGroupLabel.text = [@"Next" loc];
	
	self.nowSubjectTimeLabel.hidden = NO;
	self.nowSubjectTimeLabel.text = [nextDetails subjectTimeString];
	
	[self setWidgetHeightWithLabel:self.nowSubjectTimeLabel];
	[self scheduleRefreshTimerForTime:nextLessonRecord.startTime];
}


- (void)scheduleRefreshTimerForTime:(NSDate *)timeDate
{
	NSDate *date = [timeDate dateWithTodayDate];
	
	NSTimer *timer = [[NSTimer alloc] initWithFireDate:date
											  interval:0
												target:self
											  selector:@selector(onRefreshTimer)
											  userInfo:nil
											   repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	self.refreshTimer = timer;
}


#pragma mark - Events
- (void)onRefreshTimer
{
	[self performSelector:@selector(buildInterface) withObject:nil afterDelay:1];
}


#pragma mark - User
- (IBAction)doOpenApp
{
	NSURL *url = [NSURL URLWithString:@"studentt://"];
	[self.extensionContext openURL:url completionHandler:nil];
}
@end
