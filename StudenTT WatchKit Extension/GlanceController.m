//
//  GlanceController.m
//  StudenTT WatchKit Extension
//
//  Created by Stan Potemkin on 11/21/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "GlanceController.h"
#import "RLMRealm.h"
#import "RLMResults.h"
#import "DayRecord.h"
#import "NSDate+Utils.h"
#import "AppHelper.h"


@interface GlanceController()
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *nowLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *nowLessonLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *nowTimeInLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceTimer *nowTimer;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *separatorLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *nextLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *nextLessonLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceGroup *nextTimeGroup;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *nextStartTimeLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *nextEndTimeLabel;

@property(nonatomic, weak) NSTimer *refreshTimer;

- (void)buildGlance;

- (void)hideAllObjects;
- (void)showObjectsForFreeDay;
- (void)showObjectsForFreeTime;
- (void)showObjectsForFirstLesson:(LessonRecord *)firstLessonRecord;
- (void)showObjectsForNowLesson:(LessonRecord *)nowLessonRecord nextLesson:(LessonRecord *)nextLessonRecord;
- (void)showObjectsForNextLesson:(LessonRecord *)nextLessonRecord;

- (void)scheduleRefreshTimerForTime:(NSDate *)timeDate;
- (void)onRefreshTimer;
@end


@implementation GlanceController
#pragma mark - Lifecicle
- (void)willActivate
{
	[self buildGlance];
}


- (void)didDeactivate
{
	[self.refreshTimer invalidate];
}


#pragma mark - Internal
- (void)buildGlance
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


- (void)hideAllObjects
{
	[self.nowLabel setHidden:YES];
	[self.nowLessonLabel setHidden:YES];
	[self.nowTimeInLabel setHidden:YES];
	[self.nowTimer stop];
	[self.nowTimer setHidden:YES];
	[self.separatorLabel setHidden:NO];
	[self.nextLabel setHidden:YES];
	[self.nextLessonLabel setHidden:YES];
	[self.nextTimeGroup setHidden:YES];
}


- (void)showObjectsForFreeDay
{
	[self.nowLabel setHidden:NO];
	[self.nowLabel setText:NSLocalizedString(@"Free day", nil)];
}


- (void)showObjectsForFreeTime
{
	[self.nowLabel setHidden:NO];
	[self.nowLabel setText:NSLocalizedString(@"Free time", nil)];
}


- (void)showObjectsForFirstLesson:(LessonRecord *)firstLessonRecord
{
	[self.nowLabel setHidden:NO];
	[self.nowLabel setText:NSLocalizedString(@"First", nil)];
	
	[self.nowLessonLabel setHidden:NO];
	[self.nowLessonLabel setText:firstLessonRecord.subject.title];
	
	[self.nowTimeInLabel setHidden:NO];
	[self.nowTimeInLabel setText:NSLocalizedString(@"starts in", nil)];
	
	[self scheduleRefreshTimerForTime:firstLessonRecord.startTime];
	
	[self.separatorLabel setHidden:YES];
	
	[self.nextTimeGroup setHidden:NO];
	[self.nextStartTimeLabel setText:[firstLessonRecord.startTime timeString]];
	[self.nextEndTimeLabel setText:[firstLessonRecord.endTime timeString]];
}


- (void)showObjectsForNowLesson:(LessonRecord *)nowLessonRecord nextLesson:(LessonRecord *)nextLessonRecord
{
	[self.nowLabel setHidden:NO];
	[self.nowLabel setText:NSLocalizedString(@"Now", nil)];
	
	[self.nowLessonLabel setHidden:NO];
	[self.nowLessonLabel setText:nowLessonRecord.subject.title];
	
	[self scheduleRefreshTimerForTime:nowLessonRecord.endTime];
	
	[self.nowTimeInLabel setHidden:NO];
	[self.nowTimeInLabel setText:NSLocalizedString(@"ends in", nil)];
	
	if (nextLessonRecord) {
		[self.nextLabel setHidden:NO];
		[self.nextLabel setText:NSLocalizedString(@"Next", nil)];
		
		[self.nextLessonLabel setHidden:NO];
		[self.nextLessonLabel setText:nextLessonRecord.subject.title];
	}
	else {
		[self.nextLabel setHidden:NO];
		[self.nextLabel setText:NSLocalizedString(@"Then free time", nil)];
	}
}


- (void)showObjectsForNextLesson:(LessonRecord *)nextLessonRecord
{
	[self.nowLabel setHidden:NO];
	[self.nowLabel setText:NSLocalizedString(@"Next", nil)];
	
	[self.nowLessonLabel setHidden:NO];
	[self.nowLessonLabel setText:nextLessonRecord.subject.title];
	
	[self.nowTimeInLabel setHidden:NO];
	[self.nowTimeInLabel setText:NSLocalizedString(@"starts in", nil)];
	
	[self scheduleRefreshTimerForTime:nextLessonRecord.startTime];
	
	[self.separatorLabel setHidden:YES];
	
	[self.nextTimeGroup setHidden:NO];
	[self.nextStartTimeLabel setText:[nextLessonRecord.startTime timeString]];
	[self.nextEndTimeLabel setText:[nextLessonRecord.endTime timeString]];
}


- (void)scheduleRefreshTimerForTime:(NSDate *)timeDate
{
	NSDate *date = [timeDate dateWithTodayDate];
	
	[self.nowTimer setHidden:NO];
	[self.nowTimer setDate:[date dateByAddingTimeInterval:60]];
	[self.nowTimer setWidth:0];
	[self.nowTimer start];
	
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
	[self.nowTimer stop];
	[self performSelector:@selector(buildGlance) withObject:nil afterDelay:1];
}
@end
