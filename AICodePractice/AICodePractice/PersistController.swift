//
//  PersistController.swift
//  AICodePractice
//
//  Created by Prasad Kukkala on 12/21/25.
//

import SwiftData
import Foundation

@Model
class Person: Identifiable, Equatable {
    var id: UUID
    var firstname: String
    var lastName: String
    var email: String
    var isOnline: Bool = false
    
    var name: String { "\(firstname) - \(lastName)" }
    
    init(id: UUID = UUID(), firstname: String, lastName: String, email: String) {
        self.id = id
        self.firstname = firstname
        self.lastName = lastName
        self.email = email
    }
}

@Model
class Message: Identifiable, Equatable {
    var id: UUID
    var text: String
    var sender: Person
    var timeStamp: Date
    var isIncoming: Bool
    
    init(id: UUID = UUID(), text: String, sender: Person, timeStamp: Date = Date(), isIncoming: Bool) {
        self.id = id
        self.text = text
        self.sender = sender
        self.timeStamp = timeStamp
        self.isIncoming = isIncoming
    }
}


@Model
class Chat: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var participents: [Person]
    var lastMessage: Message?
    var messageHistory: [Message] = []
    
    init(id: UUID, title: String, participents: [Person]) {
        self.id = id
        self.title = title
        self.participents = participents
    }
}
