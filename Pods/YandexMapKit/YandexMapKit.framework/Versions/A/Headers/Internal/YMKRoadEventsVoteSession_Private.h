#import <YandexMapKit/YMKRoadEventsVoteSession.h>

#import <yandex/maps/mapkit/road_events/road_events_manager.h>

#import <memory>

namespace yandex {
namespace maps {
namespace mapkit {
namespace road_events {
namespace ios {

VoteSession::OnVoteCompleted onVoteCompleted(
    YMKRoadEventsVoteSessionResponseHandler handler);
VoteSession::OnVoteError onVoteError(
    YMKRoadEventsVoteSessionResponseHandler handler);

} // namespace ios
} // namespace road_events
} // namespace mapkit
} // namespace maps
} // namespace yandex

@interface YMKRoadEventsVoteSession ()

- (id)initWithWrappedNative:(NSValue *)native;
- (id)initWithNative:(std::unique_ptr<::yandex::maps::mapkit::road_events::VoteSession>)native;

- (::yandex::maps::mapkit::road_events::VoteSession *)nativeVoteSession;

@end
