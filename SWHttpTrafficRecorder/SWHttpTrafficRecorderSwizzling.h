
#import <objc/runtime.h>

__attribute__((warn_unused_result)) IMP SWHttpTrafficRecorderReplaceMethod(SEL selector,
                                                                           IMP newImpl,
                                                                           Class affectedClass,
                                                                           BOOL isClassMethod);
