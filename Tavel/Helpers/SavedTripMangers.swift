//
//  SavedTripMangers.swift
//  Tavel
//
//  Created by user245540 on 8/15/24.
//

import UIKit
import Foundation

class PopularPlace: Codable {
    var id: String
    var title: String
    var description: String
    var imageName: String?
    var isSaved: Bool
    
    init(id: String, title: String, description: String, imageName: String?, isSaved: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.imageName = imageName
        self.isSaved = isSaved
    }
}
var popularPlace: [PopularPlace] = [
    PopularPlace(id: "1", title: "Angkor Wat Tample", description: "Angkor wat tamples is the popular please in cambodia for people in cambodia", imageName: "Angkor3", isSaved: false),
    PopularPlace(id: "2" , title: "Angkor Wat Tample", description: "Angkor wat tamples is the popular please in cambodia for people in cambodia", imageName: "Angkor1", isSaved: false),
    PopularPlace(id: "3", title: "Angkor Wat Tample", description: "Angkor wat tamples is the popular please in cambodia for people in cambodia", imageName: "Angkor3", isSaved: false)
]

class BookmarkManager {
    
    static let shared = BookmarkManager()
    private let bookmarksKey = "bookmarkedTrips"

    func saveBookmark(_ trip: PopularPlace) {
        var bookmarks = getBookmarks()
        if let index = bookmarks.firstIndex(where: { $0.id == trip.id }) {
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
        if let index = bookmarks.firstIndex(where: { $0.id == id }) {
            bookmarks[index].isSaved = false
        }
        bookmarks.removeAll { $0.id == id }
        saveBookmarks(bookmarks)
    }

    func isBookmarked(id: String) -> Bool {
        let bookmarks = getBookmarks()
        return bookmarks.contains { $0.id == id }
    }

    func getBookmarks() -> [PopularPlace] {
        if let data = UserDefaults.standard.data(forKey: bookmarksKey),
           let bookmarks = try? JSONDecoder().decode([PopularPlace].self, from: data) {
            return bookmarks
        }
        return []
    }
    
    private func saveBookmarks(_ bookmarks: [PopularPlace]) {
        if let data = try? JSONEncoder().encode(bookmarks) {
            UserDefaults.standard.set(data, forKey: bookmarksKey)
        }
    }
}
