//
//  UIControl+BXHControl.m
//  BXHLiveVedio
//
//  Created by 步晓虎 on 2017/8/29.
//  Copyright © 2017年 步晓虎. All rights reserved.
//

#import "UIControl+BXHControl.h"
#import <objc/runtime.h>


static const int block_key;

@interface BXHUIControlBlockTarget : NSObject

@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events;
- (void)invoke:(id)sender;

@end

@implementation BXHUIControlBlockTarget

- (id)initWithBlock:(void (^)(id sender))block events:(UIControlEvents)events {
    self = [super init];
    if (self) {
        self.block = block;
        self.events = events;
    }
    return self;
}

- (void)invoke:(id)sender {
    if (self.block) self.block(sender);
}

@end



@implementation UIControl (BXHControl)

- (void)removeAllTargets
{
    [[self allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self   removeTarget:object
                      action:NULL
            forControlEvents:UIControlEventAllEvents];
    }];
}

- (void)setTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    NSSet *targets = [self allTargets];
    for (id currentTarget in targets)
    {
        NSArray *actions = [self actionsForTarget:currentTarget forControlEvent:controlEvents];
        for (NSString *currentAction in actions)
        {
            [self   removeTarget:currentTarget action:NSSelectorFromString(currentAction)
                forControlEvents:controlEvents];
        }
    }
    [self addTarget:target action:action forControlEvents:controlEvents];
}

- (void)addBlockForControlEvents:(UIControlEvents)controlEvents
                           block:(void (^)(id sender))block
{
    BXHUIControlBlockTarget *target = [[BXHUIControlBlockTarget alloc]
                                       initWithBlock:block events:controlEvents];
    [self addTarget:target action:@selector(invoke:) forControlEvents:controlEvents];
    NSMutableArray *targets = [self bxhAllUIControlBlockTargets];
    [targets addObject:target];
}

- (void)setBlockForControlEvents:(UIControlEvents)controlEvents
                           block:(void (^)(id sender))block
{
    [self removeAllBlocksForControlEvents:controlEvents];
    [self addBlockForControlEvents:controlEvents block:block];
}

- (void)removeAllBlocksForControlEvents:(UIControlEvents)controlEvents
{
    NSMutableArray *targets = [self bxhAllUIControlBlockTargets];
    NSMutableArray *removes = [NSMutableArray array];
    [targets enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        BXHUIControlBlockTarget *target = (BXHUIControlBlockTarget *)obj;
        if (target.events == controlEvents)
        {
            [removes addObject:target];
            [self   removeTarget:target
                          action:@selector(invoke:)
                forControlEvents:controlEvents];
        }
    }];
    [targets removeObjectsInArray:removes];
}

- (NSMutableArray *)bxhAllUIControlBlockTargets
{
    NSMutableArray *targets = objc_getAssociatedObject(self, &block_key);
    if (!targets)
    {
        targets = [NSMutableArray array];
        objc_setAssociatedObject(self, &block_key, targets, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return targets;
}


@end
