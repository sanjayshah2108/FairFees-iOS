//
//  MarkerManager.h
//  FairFeesApp
//
//  Created by Sanjay Shah on 2018-04-05.
//  Copyright © 2018 Fair Fees. All rights reserved.
//

//#ifndef MarkerManager_h
//#define MarkerManager_h


#import <Foundation/Foundation.h>
@import CoreLocation;
#import "GMUClusterItem.h"
#import <GoogleMaps/GoogleMaps.h>


@interface MarkerManager: NSObject

@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) GMSMarker *marker;

@end


//#endif /* MarkerManager_h */
