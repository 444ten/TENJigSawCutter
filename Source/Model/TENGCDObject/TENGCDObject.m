//
//  TENGCDObject.m
//  TENJigSawCutter
//
//  Created by 444ten on 8/22/16.
//  Copyright © 2016 444ten. All rights reserved.
//

#import "TENGCDObject.h"

@implementation TENGCDObject

#pragma mark -
#pragma mark Public Methods

- (void)executeTest {

    NSObject *obj = [NSObject new];

/*
    NSLog(@"A... %d", obj.retainCount);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"B... %d", obj.retainCount);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"C... %d", obj.retainCount);
        });
        sleep(2);

        NSLog(@"D... %d", obj.retainCount);
    });
    NSLog(@"E... %d", obj.retainCount);
*/
    
    dispatch_queue_t queue = dispatch_queue_create([@"testQueue" cStringUsingEncoding:kCFStringEncodingUTF8],
                                                   DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"A... %d", (int)obj.retainCount);
    dispatch_sync(queue, ^{
        NSLog(@"B... %d", (int)obj.retainCount);
        dispatch_async(queue, ^{
            NSLog(@"C... %d", (int)obj.retainCount);
        });
        
        NSLog(@"D... %d", (int)obj.retainCount);
    });
    sleep(1);
    NSLog(@"E... %d", (int)obj.retainCount);

}

@end
