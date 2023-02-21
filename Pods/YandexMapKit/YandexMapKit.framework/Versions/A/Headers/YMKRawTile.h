#import <YandexMapKit/YMKVersion.h>

/**
 * Available tile states.
 */
typedef NS_ENUM(NSUInteger, YMKRawTileState) {

    /**
     * Tile is available.
     */
    YMKRawTileStateOk,

    /**
     * Tile was not modified.
     */
    YMKRawTileStateNotModified,

    /**
     * An error occurred when processing the tile.
     */
    YMKRawTileStateError
};


/**
 * A raw tile that can be displayed on the map.
 */
@interface YMKRawTile : NSObject

@property (nonatomic, readonly, nonnull) YMKVersion *version;

@property (nonatomic, readonly, nonnull) NSString *etag;

@property (nonatomic, readonly) YMKRawTileState state;

@property (nonatomic, readonly, nonnull) NSData *rawData;


+ (nonnull YMKRawTile *)rawTileWithVersion:(nonnull YMKVersion *)version
                                      etag:(nonnull NSString *)etag
                                     state:( YMKRawTileState)state
                                   rawData:(nonnull NSData *)rawData;


@end

