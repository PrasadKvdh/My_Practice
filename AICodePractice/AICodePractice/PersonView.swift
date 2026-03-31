//
//  Person.swift
//  AICodePractice
//
//  Created by Prasad Kukkala on 12/21/25.
//

import SwiftUI
import Foundation
import SwiftData

enum DetailsViewModes {
    case create
    case view
}

struct PersonList: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Person.firstname, order: .forward) var persons: [Person]
    @State var selectedPersonId: Person.ID?
    @State var isNewPerson: Bool = false
    @State var chatRepository: ChatRepository?
    @State var personRepository: PersonRepository?
    
    var body: some View {
        NavigationSplitView {
            List(persons, selection: $selectedPersonId) { person in
                Text(person.name)
                    .font(.headline)
                    .contextMenu {
                        Button(role: .destructive) {
                            deletePerson(person: person)
                        } label: {
                            Label("", systemImage: "trash")
                        }
                    }
            }
        } detail: {
            if isNewPerson {
                let person = Person(firstname: "", lastName: "", email: "")
                PersonDetail(person: person, viewModes: .create, isNewPerson: $isNewPerson)
            } else if let personID = selectedPersonId,
               let person = persons.first(where: { $0.id == personID }) {
                AIChatView(chatId: UUID(), repository: MockChatRepository(), personRepository: MockParticipantRepository())
            }
        }
        .navigationTitle("Persons")
        .toolbar {
            Button("", systemImage: "plus") {
                // Add person
                isNewPerson = true
            }
        }
    }
    
    func deletePerson(person: Person) {
        modelContext.delete(person)
    }
}

struct PersonDetail: View {
    @Environment(\.modelContext) var modelContext
    @Bindable var person: Person
    @State var viewModes: DetailsViewModes
    @Binding var isNewPerson: Bool
    
    var body: some View {
        Form {
            switch viewModes {
            case .view:
                displyDetails
            case .create:
                createPerson
            }
        }
    }
    
    @ViewBuilder
    private var displyDetails: some View {
        Section(header: Text("Details")) {
            Section {
                HStack {
                    Text("Name")
                        .font(.caption)
                    Text(person.name)
                        .font(.title)
                        .fontWeight(.light)
                }
            }
            Section {
                HStack {
                    Text("Email")
                        .font(.caption)
                    Text(person.email)
                        .font(.title)
                        .fontWeight(.light)
                }
            }
        }
    }
    
    @ViewBuilder
    private var createPerson: some View {
        Section(header: Text("Create New Person")) {
            Section {
                HStack {
                    Text("First Name")
                        .font(.caption)
                        .padding(.leading)
                    TextField("", text: $person.firstname)
                        .fontWeight(.light)
                        .padding(.trailing)
                }
                
                HStack {
                    Text("Last Name")
                        .font(.caption)
                        .padding(.leading)
                    TextField("", text: $person.lastName)
                        .fontWeight(.light)
                        .padding(.trailing)
                }
                
                HStack {
                    Text("Email")
                        .font(.caption)
                        .padding(.leading)
                    TextField("", text: $person.email)
                        .fontWeight(.light)
                        .padding(.trailing)
                }
                
                VStack {
                    Button {
                        modelContext.insert(person)
                        isNewPerson = false
                    } label: {
                        Text("Done")
                    }
                    .buttonStyle(.bordered)
                    .disabled(person.firstname.isEmpty && person.lastName.isEmpty)
                }
            }
        }
    }
}
