//
//  MPMediaQuery.h
//  MediaPlayer
//
//  Copyright 2008 Apple, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayerDefines.h>
#import <MediaPlayer/MPMediaItem.h>

@class MPMediaPredicate;

enum {
    MPMediaGroupingTitle,
    MPMediaGroupingAlbum,
    MPMediaGroupingArtist,
    MPMediaGroupingAlbumArtist,
    MPMediaGroupingComposer,
    MPMediaGroupingGenre,
    MPMediaGroupingPlaylist,
    MPMediaGroupingPodcastTitle
};
typedef NSInteger MPMediaGrouping;

// MPMediaQuery represents a collection of items or playlists determined by a chain of MPMediaPredicate objects.

MP_EXTERN_CLASS_AVAILABLE(3_0) @interface MPMediaQuery : NSObject <NSCoding, NSCopying>

- (id)init;
- (id)initWithFilterPredicates:(NSSet *)filterPredicates;
@property(nonatomic, retain) NSSet *filterPredicates;

- (void)addFilterPredicate:(MPMediaPredicate *)predicate;
- (void)removeFilterPredicate:(MPMediaPredicate *)predicate;

// Returns an array of MPMediaItems matching the query filter predicates.
// If no items match this method returns an empty array, otherwise returns nil if an error prevents the items from being fetched.
@property(nonatomic, readonly) NSArray *items;

// Returns an array of MPMediaItemCollections matching the query filter predicates. The collections are grouped by the groupingType.
@property(nonatomic, readonly) NSArray *collections;

// The property used to group collections, defaults to MPMediaGroupingTitle.
@property(nonatomic) MPMediaGrouping groupingType;

// Returns an array of MPMediaQuerySection instances representing the section grouping of the query's items or collections.
// May be nil in cases where no section grouping of the items or collections is appropriate.
@property (nonatomic, readonly) NSArray *itemSections NS_AVAILABLE_IOS(4_2);
@property (nonatomic, readonly) NSArray *collectionSections NS_AVAILABLE_IOS(4_2);

// Base queries which can be used directly or as the basis for custom queries.
// The groupingType for these queries is preset to the appropriate type for the query.
+ (MPMediaQuery *)albumsQuery;
+ (MPMediaQuery *)artistsQuery;
+ (MPMediaQuery *)songsQuery;
+ (MPMediaQuery *)playlistsQuery;
+ (MPMediaQuery *)podcastsQuery;
+ (MPMediaQuery *)audiobooksQuery;
+ (MPMediaQuery *)compilationsQuery;
+ (MPMediaQuery *)composersQuery;
+ (MPMediaQuery *)genresQuery;

@end

// ------------------------------------------------------------------------
// MPMediaPredicate is an abstract class that allows filtering media in an MPMediaQuery.
// See the concrete subclass MPMediaPropertyPredicate for filtering options.

MP_EXTERN_CLASS_AVAILABLE(3_0) @interface MPMediaPredicate : NSObject <NSCoding> {}
@end

// ------------------------------------------------------------------------
// MPMediaPropertyPredicate allows filtering based on a specific property value of an item or collection.
// See MPMediaItem.h and MPMediaPlaylist.h for a list of properties.

enum {
    MPMediaPredicateComparisonEqualTo,
    MPMediaPredicateComparisonContains
};
typedef NSInteger MPMediaPredicateComparison;

MP_EXTERN_CLASS_AVAILABLE(3_0) @interface MPMediaPropertyPredicate : MPMediaPredicate

+ (MPMediaPropertyPredicate *)predicateWithValue:(id)value forProperty:(NSString *)property; // comparisonType is MPMediaPredicateComparisonEqualTo
+ (MPMediaPropertyPredicate *)predicateWithValue:(id)value forProperty:(NSString *)property comparisonType:(MPMediaPredicateComparison)comparisonType;

@property(nonatomic, readonly, copy) NSString *property;
@property(nonatomic, readonly, copy) id value;
@property(nonatomic, readonly) MPMediaPredicateComparison comparisonType;

@end

// ------------------------------------------------------------------------
// Convenience methods to determine item properties corresponding to a given grouping type.

@interface MPMediaItem (MPMediaQueryAdditions)

// Returns the item property for a given grouping type.
// For example, [MPMediaItem persistentIDPropertyForGroupingType:MPMediaGroupingAlbum] returns MPMediaItemPropertyAlbumPersistentID.
+ (NSString *)persistentIDPropertyForGroupingType:(MPMediaGrouping)groupingType NS_AVAILABLE_IOS(4_2);

// Returns the item property to determine a title for a given grouping type.
// For example, [MPMediaItem titlePropertyForGroupingType:MPMediaGroupingAlbum] returns MPMediaItemPropertyAlbumTitle.
// Note that distinct collections will not necessarily have unique titles, e.g. an album may exist with the title "Greatest Hits" for multiple artists.
+ (NSString *)titlePropertyForGroupingType:(MPMediaGrouping)groupingType NS_AVAILABLE_IOS(4_2);

@end
