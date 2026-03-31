//
//  Chat.swift
//  AICodePractice
//
//  Created by Prasad Kukkala on 12/25/25.
//

import SwiftUI
import FoundationModels

struct AIChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @State private var messageText: String = ""
    
    init(chatId: UUID, repository: ChatRepository, personRepository: PersonRepository) {
        _viewModel = StateObject(
            wrappedValue: ChatViewModel(chatId: chatId, chatRepository: repository, personRepository: personRepository)
        )
    }
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message, isIncoming: true)
                                .id(message.id)
                        }
                    }
                }
            }
            Divider()
            HStack {
                TextField("Message", text: $messageText)
                    .textFieldStyle(.roundedBorder)
                Button("Send") {
                    Task {
                        try await sendPrompt(str: messageText)
                    }
                }
            }
            .padding()
        }
        //.task { await $viewModel.$messages }
    }
    
    func sendPrompt(str: String) async throws {
        var responseText = ""
        
        Task {
            print("Session running: \(LanguageModelSession().isResponding)")
            do {
                guard SystemLanguageModel.default.isAvailable else {
                           print("Apple Intelligence not available")
                           return
                       }
                
                let session = LanguageModelSession()
                responseText = try await session.respond(to: messageText).content
//                            let topic = "Elephants"  // A sensitive topic.
//                            responseText = try await session.respond(
//                                to: "List five key points about: \(topic)",
//                                generating: [String].self
//                            ).content
                print("Response: \(responseText)")
                let responseMessage = Message(text: responseText, sender: Person(firstname: "Test", lastName: "Test1", email: ""), isIncoming: true)
                viewModel.messages.append(responseMessage)
                
//                            await MainActor.run {
//                                let joined = responseText.joined(separator: "\n• ")
//                                let message = Message(text: joined, sender: Person(firstname: "test", lastName: "test123", email: ""), isIncoming: false)
//                                viewModel.messages.append(message)
//                           }
            } catch let error as LanguageModelSession.GenerationError {
                // Specifically handle model-specific errors
                switch error {
                case .refusal:
                    responseText = "The model refused to respond due to safety guardrails."
                case .exceededContextWindowSize:
                    responseText = "The conversation is too long."
                case .rateLimited:
                    responseText = "Too many requests too quickly."
                default:
                    responseText = "Generation error: \(error)"
                }
            } catch {
                responseText = "General error: \(error.localizedDescription)"
            }
        }
    }
}

struct MessageBubble: View {
    var message: Message
    var isIncoming: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if isIncoming {
                Text(message.text)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(12)
                    .padding()
                Spacer()
            } else {
                Spacer()
                Text(message.text)
                    .foregroundColor(.white)
                    .background(.gray)
                    .cornerRadius(12)
                    .padding()
            }
        }
        .padding(.horizontal)
    }
}

