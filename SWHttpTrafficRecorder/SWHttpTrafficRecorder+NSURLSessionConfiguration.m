
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "SWHttpTrafficRecorder.h"

typedef NSURLSessionConfiguration*(*SessionConfigConstructor)(id,SEL);
static SessionConfigConstructor orig_defaultSessionConfiguration;
//static SessionConfigConstructor orig_ephemeralSessionConfiguration;
//
static NSURLSessionConfiguration* SWHttpTrafficRecorder_defaultSessionConfiguration(id self, SEL _cmd)
{
    NSURLSessionConfiguration* config = orig_defaultSessionConfiguration(self,_cmd); // call original method
    
    // enable swhttptrafficrecorder
    [SWHttpTrafficRecorder setEnabled:YES forSessionConfiguration:config];
    
    return config;
}

@interface NSURLSessionConfiguration(SWHttpTrafficRecorder) @end

@implementation NSURLSessionConfiguration(SWHttpTrafficRecorder)

+(void) load {
    static dispatch_once_t SWHttpTrafficRecorderOnceToken;
    dispatch_once(&SWHttpTrafficRecorderOnceToken, ^ {
        Class class = object_getClass((id)self);
        
        SEL originalSelector = @selector(defaultSessionConfiguration);
        
        Method originalMethod = class_getClassMethod(class, originalSelector);
        IMP swizzledMethod = (IMP)SWHttpTrafficRecorder_defaultSessionConfiguration;
        
        orig_defaultSessionConfiguration = (SessionConfigConstructor)method_setImplementation(originalMethod, swizzledMethod);
    });
    
//    orig_defaultSessionConfiguration = (SessionConfigConstructor)OHHTTPStubsReplaceMethod(@selector(defaultSessionConfiguration),
//                                                                                          (IMP)OHHTTPStubs_defaultSessionConfiguration,
//                                                                                          [NSURLSessionConfiguration class],
//                                                                                          YES);
//    orig_ephemeralSessionConfiguration = (SessionConfigConstructor)OHHTTPStubsReplaceMethod(@selector(ephemeralSessionConfiguration),
//                                                                                            (IMP)OHHTTPStubs_ephemeralSessionConfiguration,
//                                                                                            [NSURLSessionConfiguration class],
//                                                                                            YES);

}


@end
