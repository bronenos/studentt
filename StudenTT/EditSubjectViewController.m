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



@interface EditSubjectViewController()
@property(nonatomic, strong) IBOutlet UITextField *titleField;
@property(nonatomic, strong) IBOutlet UITextField *locationField;
@property(nonatomic, strong) IBOutlet UITextField *teacherField;

- (IBAction)doCancel;
- (IBAction)doDone;
@end


@implementation EditSubjectViewController
#pragma mark - View
- (void)viewDidLoad
{
	[super viewDidLoad];
	
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


#pragma mark - User
- (IBAction)doCancel
{
	[self.presentingViewController dismissViewControllerAnimated:YES
													  completion:nil];
}


- (IBAction)doDone
{
	void (^populateLesson)() = ^{
		self.subject.title = self.titleField.text ?: @"";
		self.subject.location = self.locationField.text ?: @"";
		self.subject.teacher = self.teacherField.text ?: @"";
	};
	
	RLMRealm *realm = [RLMRealm defaultRealm];
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
	
	[self.presentingViewController dismissViewControllerAnimated:YES
													  completion:nil];
}
@end
