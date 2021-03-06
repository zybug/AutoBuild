//
//  XCBuildTaskManager.h
//  AutoBuildApp
//
//  Created by jaki on 2017/6/27.
//  Copyright © 2017年 jaki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProjectTask;
@class ProjectModel;

@interface XCBuildTaskManager : NSObject

+(instancetype)defaultManager;


@property(nonatomic,strong)NSMutableArray<ProjectTask *> * allRuningProjectTask;


/**
 创建一个工程自动化任务

 @param project 项目对象
 @return 自动化任务对象
 */
-(ProjectTask*)createProjectTask:(ProjectModel *)project;


/**
 执行一个自动化任务

 @param task 任务对象
 @param stepCallBack 进度回调
 */
-(void)runTask:(ProjectTask *)task stepCallBack:(void(^)(int , NSDictionary* ,CGFloat,NSString *,NSString *,BOOL))stepCallBack;


/**
 取消一个自动化任务 并不会移除 只是停止执行

 @param task 任务对象
 */
-(void)cancelTask:(ProjectTask *)task;


/**
 移除一个自动化任务

 @param task 任务对象
 */
-(void)removeTask:(ProjectTask *)task;

/**
 获取git分支列表

 @param project git 工程
 */
-(void)getGitBranch:(ProjectModel *)project stepCallBack:(void(^)(NSDictionary* ,NSString *,BOOL))stepCallBack;

@end
