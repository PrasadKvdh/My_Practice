//
//  ChatViewModel.swift
//  AICodePractice
//
//  Created by Prasad Kukkala on 12/25/25.
//
import SwiftUI
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var participants: [Person] = []
    private let chatId: UUID
    private let chatRepository: ChatRepository
    private let personRepository: PersonRepository
    
    init(
        chatId: UUID,
        chatRepository: ChatRepository,
        personRepository: PersonRepository
    ) {
        self.chatId = chatId
        self.chatRepository = chatRepository
        self.personRepository = personRepository
    }
    func loadInitialData() async {
        async let msgs = chatRepository.loadMessages(chatId: chatId)
        async let users = personRepository.fetchParticipants(chatId: chatId)
        self.messages = (try? await msgs) ?? []
        self.participants = (try? await users) ?? []
    }
    func sender(for message: Message) -> Person? {
        participants.first { $0.id == message.sender.id }
    }
}
