//
//  EditLessonViewController.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/19/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "EditSubjectViewController.h"
#import "SubjectRecord.h"
#import "RLMRealm.h"
#import "RealmHelper.h"



@interface EditSubjectViewController()
@property(nonatomic, strong) IBOutlet UITextField *titleField;
@property(nonatomic, strong) IBOutlet UITextField *locationField;
@property(nonatomic, strong) IBOutlet UITextField *teacherField;

- (NSString *)preparedString:(NSString *)string;
- (BOOL)isStandaloneViewController;

- (IBAction)doCancel;
- (IBAction)doDone;
@end


@implementation EditSubjectViewController
#pragma mark - View
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	if ([self isStandaloneViewController] == NO) {
		self.navigationItem.leftBarButtonItem = nil;
	}
	
	self.tableView.rowHeight = 40;
	self.titleField.text = self.subject.title;
	self.locationField.text = self.subject.location;
	self.teacherField.text = self.subject.teacher;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.titleField becomeFirstResponder];
}


#pragma mark - Internal
- (NSString *)preparedString:(NSString *)string
{
	if (string == nil) {
		return @"";
	}
	
	NSCharacterSet *trimSet = [NSCharacterSet whitespaceCharacterSet];
	return [string stringByTrimmingCharactersInSet:trimSet];
}


- (BOOL)isStandaloneViewController
{
	NSArray *viewControllers = self.navigationController.viewControllers;
	return (self == [viewControllers firstObject]);
}


#pragma mark - User
- (IBAction)doCancel
{
	[self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)doDone
{
	void (^populateLesson)() = ^{
		self.subject.title = [self preparedString:self.titleField.text];
		self.subject.location = [self preparedString:self.locationField.text];
		self.subject.teacher = [self preparedString:self.teacherField.text];
	};
	
	RLMRealm *realm = [RealmHelper sharedRealm];
	[realm transactionWithBlock:^{
		if (self.subject == nil) {
			self.subject = [SubjectRecord new];
			populateLesson();
			[realm addObject:self.subject];
		}
		else {
			populateLesson();
		}
	}];
	
	[self.navigationController popViewControllerAnimated:YES];
}
@end
