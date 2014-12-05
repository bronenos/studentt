//
//  InterfaceController.m
//  StudenTT WatchKit Extension
//
//  Created by Stan Potemkin on 11/21/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "InterfaceController.h"
#import "AppHelper.h"
#import "DayRecord.h"
#import "NSDate+Utils.h"
#import "NSString+Utils.h"


@interface InterfaceController()
@property(nonatomic, weak) IBOutlet WKInterfaceGroup *timeGroup;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *startTimeLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *endTimeLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *titleLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *locationLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceLabel *teacherLabel;
@property(nonatomic, weak) IBOutlet WKInterfaceButton *prevLessonButton;
@property(nonatomic, weak) IBOutlet WKInterfaceButton *nextLessonButton;

@property(nonatomic, strong) RLMArray<LessonRecord> *lessonResults;
@property(nonatomic, assign) NSUInteger lessonIndex;

- (void)calculateLessonIndex;
- (void)buildInterface;

- (void)showObjectsForFreeDay;
- (void)showObjectsForLesson:(LessonRecord *)lessonRecord;

- (IBAction)doShowPrevious;
- (IBAction)doShowNext;
@end


@implementation InterfaceController
#pragma mark - Lifecycle
- (void)willActivate
{
	[self calculateLessonIndex];
	[self buildInterface];
}


#pragma mark - Internal
- (void)calculateLessonIndex
{
	self.lessonResults = [AppHelper getDayRecord].lessons;
	if (self.lessonResults.count) {
		NSDate *timeDate = [[NSDate date] dateWithOnlyTimeAndSeconds:YES];
		
		NSInteger cnt = self.lessonResults.count;
		for (NSInteger i=0; i<cnt; i++) {
			LessonRecord *lessonRecord = self.lessonResults[i];
			
			if ([timeDate isBeforeLesson:lessonRecord]) {
				self.lessonIndex = i;
				return;
			}
			else if ([timeDate isDuringLesson:lessonRecord]) {
				self.lessonIndex = i;
				return;
			}
		}
		
		self.lessonIndex = cnt - 1;
	}
	else {
		self.lessonIndex = NSNotFound;
	}
}


- (void)buildInterface
{
	if (self.lessonIndex < NSNotFound) {
		LessonRecord *lessonRecord = self.lessonResults[self.lessonIndex];
		[self showObjectsForLesson:lessonRecord];
	}
	else {
		[self showObjectsForFreeDay];
	}
}


- (void)showObjectsForFreeDay
{
	[self.timeGroup setHidden:YES];
	
	[self.titleLabel setHidden:NO];
	[self.titleLabel setText:[@"Free day" loc]];
	
	[self.locationLabel setHidden:YES];
	
	[self.teacherLabel setHidden:YES];
	
	[self.prevLessonButton setHidden:YES];
	[self.nextLessonButton setHidden:YES];
}


- (void)showObjectsForLesson:(LessonRecord *)lessonRecord
{
	[self.timeGroup setHidden:NO];
	[self.startTimeLabel setText:[lessonRecord.startTime timeString]];
	[self.endTimeLabel setText:[lessonRecord.endTime timeString]];
	
	[self.titleLabel setHidden:NO];
	[self.titleLabel setText:lessonRecord.subject.title];
	
	[self.locationLabel setHidden:NO];
	[self.locationLabel setText:lessonRecord.subject.location];
	
	[self.teacherLabel setHidden:NO];
	[self.teacherLabel setText:lessonRecord.subject.teacher];
	
	LessonRecord *firstLessonRecord = [self.lessonResults firstObject];
	[self.prevLessonButton setHidden:[lessonRecord isEqualToObject:firstLessonRecord]];
	
	LessonRecord *lastLessonRecord = [self.lessonResults lastObject];
	[self.nextLessonButton setHidden:[lessonRecord isEqualToObject:lastLessonRecord]];
}


#pragma mark - User
- (IBAction)doShowPrevious
{
	self.lessonIndex--;
	[self buildInterface];
}


- (IBAction)doShowNext
{
	self.lessonIndex++;
	[self buildInterface];
}
@end



