//
//  RealmConfig.m
//  SocketIOIOSDemo
//
//  Created by tjpld on 2017/2/13.
//  Copyright © 2017年 ufo. All rights reserved.
//

#import "RealmConfig.h"

@implementation RealmConfig

+ (void)setUp:(NSString*)username {
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
    config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent]
                       URLByAppendingPathComponent:username]
                      URLByAppendingPathExtension:@"realm"];
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
    
    
    //    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    //    config.schemaVersion = 2;
    //    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
    //        // The enumerateObjects:block: method iterates
    //        // over every 'Person' object stored in the Realm file
    //        [migration enumerateObjects:Person.className
    //                              block:^(RLMObject *oldObject, RLMObject *newObject) {
    //                                  // Add the 'fullName' property only to Realms with a schema version of 0
    //                                  if (oldSchemaVersion < 1) {
    //                                      newObject[@"fullName"] = [NSString stringWithFormat:@"%@ %@",
    //                                                                oldObject[@"firstName"],
    //                                                                oldObject[@"lastName"]];
    //                                  }
    //
    //                                  // Add the 'email' property to Realms with a schema version of 0 or 1
    //                                  if (oldSchemaVersion < 2) {
    //                                      newObject[@"email"] = @"";
    //                                  }
    //                              }];
    //    };
    //    [RLMRealmConfiguration setDefaultConfiguration:config];
    //
    //    // now that we have updated the schema version and provided a migration block,
    //    // opening an outdated Realm will automatically perform the migration and
    //    // opening the Realm will succeed
    //    [RLMRealm defaultRealm];
}

@end
