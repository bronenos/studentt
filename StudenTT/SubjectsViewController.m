//
//  LessonsViewController.m
//  StudenTT
//
//  Created by Stan Potemkin on 11/19/14.
//  Copyright (c) 2014 bronenos. All rights reserved.
//

#import "SubjectsViewController.h"
#import "EditSubjectViewController.h"
#import "RLMRealm.h"
#import "RLMResults.h"
#import "SubjectRecord.h"
#import "SubjectCell.h"


static NSString * const kSubjectCellReuseID	= @"SubjectCell";
static NSString * const kEditSubjectSegueID	= @"EditSubject";


@interface SubjectsViewController() <UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, weak) IBOutlet UITableView *tableView;

@property(nonatomic, strong) RLMResults *subjectResults;
@property(nonatomic, strong) RLMNotificationToken *realmToken;

- (void)registerRealm;
- (void)unregisterRealm;
@end


@implementation SubjectsViewController
#pragma mark - Memory
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		self.subjectResults = [SubjectRecord allObjects];
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
	
	[self.tableView registerClass:[SubjectCell class]
		   forCellReuseIdentifier:kSubjectCellReuseID];
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


#pragma mark - NSSeguePerforming
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([kEditSubjectSegueID isEqualToString:segue.identifier]) {
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		
		UINavigationController *nc = segue.destinationViewController;
		EditSubjectViewController *vc = [nc.viewControllers firstObject];
		
		SubjectRecord *subjectRecord = self.subjectResults[indexPath.row];
		vc.subject = subjectRecord;
	}
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.subjectResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SubjectCell *cell = (id) [tableView dequeueReusableCellWithIdentifier:kSubjectCellReuseID];
	[cell configureWithSubject:self.subjectResults[indexPath.row]];
	return cell;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	[self performSegueWithIdentifier:kEditSubjectSegueID sender:cell];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	RLMRealm *realm = [RLMRealm defaultRealm];
	[realm transactionWithBlock:^{
		[realm deleteObject:self.subjectResults[indexPath.row]];
	}];
}
@end
