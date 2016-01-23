//
//  ELLayoutConstraintModel.m
//  EasyLayoutDemo
//
//  Created by AugustRush on 1/9/16.
//  Copyright © 2016 AugustRush. All rights reserved.
//

#import "ELConstraintsMaker.h"
#import "ELLayoutConstraintModel.h"

@implementation ELLayoutConstraintModel {
  __weak NSLayoutConstraint *_constraint;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _constant = 0;
    _ratio = 1;
    _toView = nil;
    _toAttribute = NSLayoutAttributeNotAnAttribute;
  }
  return self;
}

- (void)dealloc {
  NSLog(@"temple dealloc");
}

#pragma mark - private methods

- (BOOL)needRelativeToSuper {
  // width or height not auto relative to superView
  return (_attribute != NSLayoutAttributeWidth &&
          _attribute != NSLayoutAttributeHeight);
}

- (void)configurationWithViewOrNumber:(id)viewOrNumber
                             relation:(NSLayoutRelation)relation {
  _relation = relation;
  if ([viewOrNumber isKindOfClass:[UIView class]]) {
    _toView = viewOrNumber;
    _toAttribute = _attribute;
  } else if ([viewOrNumber isKindOfClass:[NSNumber class]]) {
    if ([self needRelativeToSuper]) { // if attribute is width or height , this
                                      // should not be relative to superView
                                      // unless sepecific
      _toView = _view.superview;
      _toAttribute = _attribute;
    }
    _constant = [viewOrNumber floatValue];
  } else {
    NSAssert(0, @"unsupport this type!");
  }
}

- (NSLayoutConstraint *)__constraint {
  if (_constraint == nil) {
    _constraint = [NSLayoutConstraint constraintWithItem:_view
                                               attribute:_attribute
                                               relatedBy:_relation
                                                  toItem:_toView
                                               attribute:_toAttribute
                                              multiplier:_ratio
                                                constant:_constant];
  }
  return _constraint;
}

- (BOOL)isEqual:(id)object {
  return NO;
}

#pragma mark - public methods

- (ELLayoutLinkerBlock)equalTo {
  return ^ELLayoutConstraintModel *(id viewOrNumber) {
    [self configurationWithViewOrNumber:viewOrNumber
                               relation:NSLayoutRelationEqual];
    return self;
  };
}

- (ELLayoutLinkerBlock)greaterThanOrEqualTo {
  return ^ELLayoutConstraintModel *(id viewOrNumber) {
    [self configurationWithViewOrNumber:viewOrNumber
                               relation:NSLayoutRelationGreaterThanOrEqual];

    return self;
  };
}

- (ELLayoutLinkerBlock)lessThanOrEqualTo {
  return ^ELLayoutConstraintModel *(id viewOrNumber) {
    [self configurationWithViewOrNumber:viewOrNumber
                               relation:NSLayoutRelationLessThanOrEqual];
    return self;
  };
}

- (ELLayoutMultiplierBlock)multiplier {
  return ^(CGFloat multiplier) {
    _ratio *= multiplier;
    return self;
  };
}

- (ELLayoutOffsetBlock)offset {
  return ^(CGFloat offset) {
    _constant += offset;
    return self;
  };
}

- (ELLayoutConstraintReturnBlock)constraint {
  return ^{
    return [self __constraint];
  };
}

@end