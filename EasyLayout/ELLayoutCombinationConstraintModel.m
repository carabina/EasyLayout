//
//  ELLayoutCombinationConstraintModel.m
//  EasyLayoutDemo
//
//  Created by AugustRush on 3/28/16.
//  Copyright © 2016 AugustRush. All rights reserved.
//

#import "ELLayoutCombinationConstraintModel.h"

@interface ELLayoutConstraintModel (ELPrivate)

- (void)configurationWithSupportType:(id)supportType
                            relation:(NSLayoutRelation)relation;

@end

#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation ELLayoutConstraintModel (ELPrivate)

@end


@implementation ELLayoutCombinationConstraintModel {
    NSMutableArray<ELLayoutConstraintModel *> *_models;
}

+ (instancetype)combinationModelWithModels:(NSArray<ELLayoutConstraintModel *> *)models {
    ELLayoutCombinationConstraintModel *combinationModel = [[ELLayoutCombinationConstraintModel alloc] init];
    [combinationModel->_models addObjectsFromArray:models];
    return combinationModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _models = @[].mutableCopy;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

- (ELLayoutombinationLinkerBlock)equalTo {
    return ^ELLayoutCombinationConstraintModel * (id supportType) {
        for (ELLayoutConstraintModel *model in _models) {
            [model configurationWithSupportType:supportType relation:NSLayoutRelationEqual];
        }
        return self;
    };
}

- (ELLayoutombinationLinkerBlock)greaterThanOrEqualTo {
    return ^ELLayoutCombinationConstraintModel * (id supportType) {
        for (ELLayoutConstraintModel *model in _models) {
            [model configurationWithSupportType:supportType relation:NSLayoutRelationGreaterThanOrEqual];
        }
        return self;
    };
}

- (ELLayoutombinationLinkerBlock)lessThanOrEqualTo {
    return ^ELLayoutCombinationConstraintModel * (id supportType) {
        for (ELLayoutConstraintModel *model in _models) {
            [model configurationWithSupportType:supportType relation:NSLayoutRelationLessThanOrEqual];
        }
        return self;
    };
}

- (ELLayoutCombinationMutiplierBlock)multiplier {
    return ^(CGFloat mutiplier) {
        for (ELLayoutConstraintModel *model in _models) {
            model.multiplier(mutiplier);
        }
        return self;
    };
}

- (ELLayoutCombinationOffsetBlock)offset {
    return ^(CGFloat offset) {
        for (ELLayoutConstraintModel *model in _models) {
            model.offset(offset);
        }
        return self;
    };
}

- (ELLayoutCombinationPriorityBlock)priority {
    return ^(CGFloat priority) {
        for (ELLayoutConstraintModel *model in _models) {
            model.priority(priority);
        }
        return self;
    };
}

- (ELCombinationConstraintGetBlock)constraint {
    return ^(NSUInteger index) {
        return _models[index].constraint();
    };
}

@end
