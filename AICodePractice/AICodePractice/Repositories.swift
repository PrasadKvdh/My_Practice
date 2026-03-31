//
//  Repositories.swift
//  AICodePractice
//
//  Created by Prasad Kukkala on 12/25/25.
//

import SwiftUI

@MainActor
protocol ChatRepository {
    func loadMessages(chatId: UUID) async throws -> [Message]
    func sendMessage(chatId: UUID, text: String) async throws -> Message
    func fetchChats() async throws -> [Chat]
}


final class MockChatRepository: ChatRepository {
    
    func loadMessages(chatId: UUID) async throws -> [Message] {
       return [
            Message(text: "Testing message..", sender: Person(firstname: "Test Sender", lastName: "Kukkala", email: "testSender@gmail.com"), isIncoming: true)
        ]
    }
    
    func sendMessage(chatId: UUID, text: String) async throws -> Message {
        Message(text: "Sample message", sender: Person(firstname: "Test Sender2", lastName: "Kukkala", email: "testSender2@gmail.com"), isIncoming: true)
    }
    
    func fetchChats() async throws -> [Chat] {
        return []
    }
}

struct LoadMessagesUseCase {
    let repository: ChatRepository
    func execute(chatId: UUID) async throws -> [Message] {
        try await repository.loadMessages(chatId: chatId)
    }
}

struct SendMessageUseCase {
    let repository: ChatRepository
    func execute(chatId: UUID, text: String) async throws -> Message {
        try await repository.sendMessage(chatId: chatId, text: text)
    }
}

@MainActor
protocol PersonRepository {
    func createParticipant(_ participant: Person) async throws
    func updateParticipant(_ participant: Person) async throws
    func fetchParticipants(chatId: UUID) async throws -> [Person]
}


final class MockParticipantRepository: PersonRepository {
    private var storage: [UUID: [Person]] = [:]
    func createParticipant(_ participant: Person) async throws {
        storage[UUID(), default: []].append(participant)
    }
    func updateParticipant(_ participant: Person) async throws {
        for key in storage.keys {
            if let index = storage[key]?.firstIndex(where: { $0.id ==
                participant.id }) {
                storage[key]?[index] = participant
            }
        }
    }
    func fetchParticipants(chatId: UUID) async throws -> [Person] {
        storage[chatId] ?? []
    }
}
