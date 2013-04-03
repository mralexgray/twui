/*

 */

#import "TUITableViewController.h"

@interface TUITableViewController ()

@property (nonatomic, assign) TUITableViewStyle style;

@end

@implementation TUITableViewController

@dynamic view;

- (id)init {
	return [self initWithStyle:TUITableViewStylePlain];
}

- (id)initWithStyle:(TUITableViewStyle)style {
	if((self = [super init])) {
		_style = style;
	}
	
	return self;
}

- (void)loadView {
	self.view = [[TUITableView alloc] initWithFrame:CGRectZero style:self.style];
	
	self.view.delegate = self;
	self.view.dataSource = self;
	
	self.view.maintainContentOffsetAfterReload = YES;
	self.view.needsDisplayWhenWindowsKeyednessChanges = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.view reloadData];
	if(self.clearsSelectionOnViewWillAppear) {
		[self.view deselectRowAtIndexPath:self.view.indexPathForSelectedRow animated:animated];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self.view flashScrollIndicators];
}

- (NSInteger)tableView:(TUITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 0;
}

- (CGFloat)tableView:(TUITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44.0f;
}

- (TUITableViewCell *)tableView:(TUITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return nil;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p | TUITableView = %@>", self.class, self, self.view];
}

@end
