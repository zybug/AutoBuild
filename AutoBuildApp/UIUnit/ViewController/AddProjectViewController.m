//
//  AddProjectViewController.m
//  AutoBuildApp
//
//  Created by jaki on 2017/6/22.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import "AddProjectViewController.h"
#import "AddProjectViewModel.h"
#import "ProjectManager.h"
#import "ProjectModel.h"
#import "GUC.h"

#define WARNING_TITLE_STRING @"警告:您必须填写项目名称"
#define WARNING_PROJECT_STRING @"警告:您必须选择一个Xcode项目(以xcodeproj或xcworkspace为后缀)"
#define WARNING_PATH_STRING @"警告:您必须选择一个项目"

@interface AddProjectViewController ()

@property (weak) IBOutlet NSButton *addButton;
@property (weak) IBOutlet NSButton *cancelButton;
@property (nonatomic,strong)AddProjectViewModel * viewModel;
@property (weak) IBOutlet NSTextField *projectPathTextField;
@property (weak) IBOutlet NSTextField *projectTitleTextField;
@property (weak) IBOutlet NSTextField *warningLabel;


@end

@implementation AddProjectViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self installUI];
}

-(void)installUI{
    self.title = @"添加新工程";
}
-(void)clearUI{
    [self.viewModel clearModel];
    [self.projectTitleTextField setStringValue:@""];
    [self.projectPathTextField setStringValue:@""];
    self.warningLabel.hidden = YES;
}

-(void)updateView{
    [self.projectPathTextField setStringValue:self.viewModel.projectPath];
    [self.projectTitleTextField setStringValue:self.viewModel.projectRealName];
    self.viewModel.projectName = self.viewModel.projectRealName;
}

#pragma mark -- action

- (IBAction)cancel:(NSButton *)sender {
    [self dismissViewController:self];
}

- (IBAction)add:(NSButton *)sender {
    if (self.viewModel.projectPath.length==0) {
        [self.warningLabel setStringValue:WARNING_PATH_STRING];
        self.warningLabel.hidden= NO;
        return;
    }
    if (
        !([[self.viewModel.projectPath componentsSeparatedByString:@"."].lastObject isEqualToString:@"xcodeproj"]
        ||[[self.viewModel.projectPath componentsSeparatedByString:@"."].lastObject isEqualToString:@"xcworkspace"]
        )) {
            [self.warningLabel setStringValue:WARNING_PROJECT_STRING];
            self.warningLabel.hidden = NO;
            return;
    }
    if (self.projectTitleTextField.stringValue.length==0) {
        [self.warningLabel setStringValue:WARNING_TITLE_STRING];
        self.warningLabel.hidden = NO;
        return;
    }else{
        self.viewModel.projectName = self.projectTitleTextField.stringValue;
    }
    
    ProjectModel * newModel = [ProjectModel new];
    newModel.projectName = self.viewModel.projectName;
    newModel.projectPath = self.viewModel.projectPath;
    newModel.projectRealName = self.viewModel.projectRealName;
    if ([[self.viewModel.projectPath componentsSeparatedByString:@"."].lastObject isEqualToString:@"xcodeproj"]) {
        newModel.projectType = @"project";
    }else{
        newModel.projectType = @"workspace";
    }
    NSString * result = [[ProjectManager defaultManager] addProject:newModel];
    if (![result isEqualToString:@"success"]) {
        [self.warningLabel setStringValue:result];
        self.warningLabel.hidden = NO;
    }else{
        [self dismissViewController:self];
        GUC_REFRESH(GUCMainView);
    }
}

- (IBAction)choiceFile:(NSButton *)sender {
    NSString * path = [GreatUserInterfaveControlPanel modalFilePanelUseDictionary:NO userFile:YES couldCreate:NO withTitle:@"请选择Xcode工程文件" okButton:@"确定"];
    if (path.length>0) {
        self.viewModel.projectPath = path;
        self.viewModel.projectRealName = [[path componentsSeparatedByString:@"/"].lastObject componentsSeparatedByString:@"."].firstObject;
        [self updateView];
    }
}




#pragma mark -- setter and getter

-(AddProjectViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[AddProjectViewModel alloc]init];
    }
    return _viewModel;
}



@end
