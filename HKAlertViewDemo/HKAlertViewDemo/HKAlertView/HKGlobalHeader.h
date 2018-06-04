//
//  HKGlobalHeader.h
//  HKAlertViewDemo
//
//  Created by 周可 on 2018/6/4.
//  Copyright © 2018年 zhouke. All rights reserved.
//

#ifndef HKGlobalHeader_h
#define HKGlobalHeader_h

#define HKObject(objectName) [[objectName alloc] init]

#define HKPropStatementAndFuncStatement(propertyModifier,className, propertyPointerType, propertyName)                  \
@property(nonatomic,propertyModifier)propertyPointerType  propertyName;                                                 \
- (className * (^) (propertyPointerType propertyName)) propertyName##Set;

#define HKPropSetFuncImplementation(className, propertyPointerType, propertyName)                                       \
- (className * (^) (propertyPointerType propertyName))propertyName##Set{                                                \
return ^(propertyPointerType propertyName) {                                                                            \
self->_##propertyName = propertyName;                                                                                         \
return self;                                                                                                            \
};                                                                                                                      \
}

#endif /* HKGlobalHeader_h */
