//
//  ContentView.swift
//  ChatAI
//
//  Created by Cédric Bahirwe on 17/12/2022.
//

import SwiftUI
import OpenAISwift

struct ContentView: View {
    @State private var messages = [Message]()
    @State private var editedMessage = Message("", isSender: true)
    @State private var isAnswering = false
    @Namespace var animation
    var body: some View {
        ScrollView {
            ForEach(messages) { message in
                MessageBubble(message: message)
                    .matchedGeometryEffect(id: message.message, in: animation)
            }
        }
        .background {
            if messages.isEmpty {
                Text("Nothing here like your crush chat!")
                    .font(.title2)
                    .fixedSize()
                    .foregroundColor(.secondary)

            }
        }
        .padding(.horizontal)
        .safeAreaInset(edge: .bottom,
                       alignment: .center,
                       spacing: 15) {
            HStack {
                TextField.init("Enter your prompt",
                               text: $editedMessage.message)
                Spacer()
                Button {
                    Task {
                        await performSearch()
                    }
                } {
                    Group {
                        if isAnswering {
                            ProgressView.init()
                                .progressViewStyle(.circular)
                        } else {
                            Image(systemName: "paperplane")
                                .symbolRenderingMode(.hierarchical)
                                .resizable()
                                .symbolVariant(.fill)
                        }
                    }
                    .tint(.white)
                    .scaledToFit()
                    .padding(10)
                    .frame(width: 40)
                    .background(.blue)
                    .clipShape(Circle())
                    .disabled(isAnswering)

                }
            }
            .padding()
            .background(.regularMaterial)
            .matchedGeometryEffect(id: editedMessage.message, in: animation)
        }
    }

    private func performSearch() async {
        guard !editedMessage.message.isEmpty else { return }
        let openAPI = OpenAISwift(authToken: "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")

        do {
            let result = try await openAPI.sendCompletion(with: editedMessage.message)
        } catch {
            print(error.localizedDescription)
        }


        // Perform
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    public func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct MessageBubble: View {
    let message: Message
    var alignment: Alignment {
        return message.isSender ? .trailing : .leading
    }
    var body: some View {
        Text(message.message)
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(20,
                          corners: corners())
            .frame(maxWidth: .infinity, alignment: alignment)
    }

    func corners() -> UIRectCorner {
        switch alignment {
        case .leading: return [.topLeft, .topRight, .bottomRight]
        default: return [.topLeft, .bottomLeft, .bottomRight]
        }
    }
}

struct Message: Identifiable, Codable {

    let id: UUID
    var message: String
    let isSender: Bool

    init(id: UUID = UUID(), _ message: String = "", isSender: Bool = true) {
        self.id = id
        self.message = message
        self.isSender = isSender
    }

    static let examples: [Message] = [
        Message("Hello There"),
        Message("Hi There"),
        Message("How is It?"),
        Message("I'm alright and you?"),
        Message("I'm great my friend"),
    ]
}

