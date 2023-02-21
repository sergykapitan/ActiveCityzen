#import <YandexMapKit/YMKPoint.h>
#import <YandexMapKit/YMKPolyline.h>
#import <YandexMapKit/YMKPolylinePosition.h>

@interface YMKPolylineUtils : NSObject

/**
 * The position of the fork on the road.
 *
 * @param firstPolyline The first path of the fork.
 * @param firstPolylinePosition The position of the first path.
 * @param secondPolyline The second path of the fork.
 * @param secondPolylinePosition The position of the second path.
 */
+ (nonnull NSArray<YMKPolylinePosition *> *)positionsOfForkWithFirstPolyline:(nonnull YMKPolyline *)firstPolyline
                                                       firstPolylinePosition:(nonnull YMKPolylinePosition *)firstPolylinePosition
                                                              secondPolyline:(nonnull YMKPolyline *)secondPolyline
                                                      secondPolylinePosition:(nonnull YMKPolylinePosition *)secondPolylinePosition;


/**
 * The position of the polyline.
 *
 * @param polyline The polyline.
 * @param position The polyline position.
 * @param distance Distance.
 */
+ (nonnull YMKPolylinePosition *)advancePolylinePositionWithPolyline:(nonnull YMKPolyline *)polyline
                                                            position:(nonnull YMKPolylinePosition *)position
                                                            distance:(double)distance;


/**
 * The point in the polyline.
 *
 * @param geometry The polyline.
 * @param position The polyline position.
 */
+ (nonnull YMKPoint *)pointByPolylinePositionWithGeometry:(nonnull YMKPolyline *)geometry
                                                 position:(nonnull YMKPolylinePosition *)position;


@end
