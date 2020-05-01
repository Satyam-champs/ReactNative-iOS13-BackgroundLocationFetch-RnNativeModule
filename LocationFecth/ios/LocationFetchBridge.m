//
//  LocationFetchBridge.m
//  LocFetchApp
//
//  Created by Satyam on 10/04/20.
//

#import <Foundation/Foundation.h>

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(LocationFetch, NSObject)
RCT_EXTERN_METHOD(printHello1:(NSString *)name )
RCT_EXTERN_METHOD(startBgLocationFetch)


@end
