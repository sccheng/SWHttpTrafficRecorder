
#import <Foundation/Foundation.h>

#if defined(__IPHONE_7_0) || defined(__MAC_10_9)
#import "SWHttpTrafficRecorder.m"
#import "SWHttpTrafficRecorderSwizzling.h"

typedef NSURLSessionConfiguration*(*SessionConfigConstructor)(id,SEL);
static SessionConfigConstructor orig_defaultSessionConfiguration;
static SessionConfigConstructor orig_ephemeralSessionConfiguration;

static NSURLSessionConfiguration* SWHttpTrafficRecorder_defaultSessionConfiguration(id self, SEL _cmd)
{
    NSURLSessionConfiguration* config = orig_defaultSessionConfiguration(self,_cmd); // call original method
    
    NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray:config.protocolClasses];
    Class protoCls = SWRecordingProtocol.class;
    if (![urlProtocolClasses containsObject:protoCls])
    {
        [urlProtocolClasses insertObject:protoCls atIndex:0];
    }
    config.protocolClasses = urlProtocolClasses;
    
    return config;
}

static NSURLSessionConfiguration* SWHttpTrafficRecorder_ephemeralSessionConfiguration(id self, SEL _cmd)
{
    NSURLSessionConfiguration* config = orig_ephemeralSessionConfiguration(self,_cmd); // call original method
    
    NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray:config.protocolClasses];
    Class protoCls = SWRecordingProtocol.class;
    if (![urlProtocolClasses containsObject:protoCls])
    {
        [urlProtocolClasses insertObject:protoCls atIndex:0];
    }
    config.protocolClasses = urlProtocolClasses;
    
    return config;
}

@interface NSURLSessionConfiguration(SWHttpTrafficRecorderSupport) @end

@implementation NSURLSessionConfiguration(SWHttpTrafficRecorderSupport)

+(void)load
{
    orig_defaultSessionConfiguration = (SessionConfigConstructor)SWHttpTrafficRecorderReplaceMethod(@selector(defaultSessionConfiguration),
                                                                                          (IMP)SWHttpTrafficRecorder_defaultSessionConfiguration,
                                                                                          [NSURLSessionConfiguration class],
                                                                                          YES);
    orig_ephemeralSessionConfiguration = (SessionConfigConstructor)SWHttpTrafficRecorderReplaceMethod(@selector(ephemeralSessionConfiguration),
                                                                                            (IMP)SWHttpTrafficRecorder_ephemeralSessionConfiguration,
                                                                                            [NSURLSessionConfiguration class],
                                                                                            YES);
}

@end

#endif
