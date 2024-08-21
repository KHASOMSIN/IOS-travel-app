//
//  NotificationModel.swift
//  Tavel
//
//  Created by user245540 on 8/18/24.
//
import UIKit

struct NotificationModel: Equatable {
    let id: UUID
    let date: Date
    let message: String
    var isRead: Bool // Track whether the notification has been read or not

    static func == (lhs: NotificationModel, rhs: NotificationModel) -> Bool {
        return lhs.id == rhs.id
    }
}
