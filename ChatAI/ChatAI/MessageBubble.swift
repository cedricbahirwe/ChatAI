//
//  MessageBubble.swift
//  ChatAI
//
//  Created by Cédric Bahirwe on 17/12/2022.
//

import SwiftUI

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


struct MessageBubble_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubble(message: .examples[0])
    }
}
