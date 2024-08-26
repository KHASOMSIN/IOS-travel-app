//
//  SavedTripMangers.swift
//  Tavel
//
//  Created by user245540 on 8/15/24.
//

import UIKit
import Foundation

class BookmarkManager {
    
    static let shared = BookmarkManager()
    private let bookmarksKey = "bookmarkedTrips"

    func saveBookmark(_ trip: Pupular) {
        var bookmarks = getBookmarks()
        if let index = bookmarks.firstIndex(where: { $0.placeId == trip.placeId }) {
            bookmarks[index].isSaved = true
        } else {
            var newTrip = trip
            newTrip.isSaved = true
            bookmarks.append(newTrip)
        }
        saveBookmarks(bookmarks)
    }

    func removeBookmark(byId id: String) {
        var bookmarks = getBookmarks()
        if let index = bookmarks.firstIndex(where: { $0.placeId == Int(id)}) {
            bookmarks[index].isSaved = false
        }
        bookmarks.removeAll { $0.placeId == Int(id) }
        saveBookmarks(bookmarks)
    }

    func isBookmarked(id: String) -> Bool {
        let bookmarks = getBookmarks()
        return bookmarks.contains { $0.placeId == Int(id) }
    }

    func getBookmarks() -> [Pupular] {
        if let data = UserDefaults.standard.data(forKey: bookmarksKey),
           let bookmarks = try? JSONDecoder().decode([Pupular].self, from: data) {
            return bookmarks
        }
        return []
    }
    
    private func saveBookmarks(_ bookmarks: [Pupular]) {
        if let data = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(data, forKey: bookmarksKey)
        }
    }
}
