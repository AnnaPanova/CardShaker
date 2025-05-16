//
//  CardJumpOutOfView.swift
//  ShakingCards
//
//  Created by Anna Panova on 15.04.25.
//

import SwiftUI

struct Card: Identifiable, Equatable {
    let id = UUID()
    let title: String
}

struct CardJumpOutView: View {
    @State private var cards: [Card] = [
        Card(title: "Kitchen"),
        Card(title: "Bathroom"),
        Card(title: "Hall"),
        Card(title: "Livingroom"),
        Card(title: "Main bedroom")
    ]

    @State private var jumpCard: Card? = nil

    var body: some View {
        VStack {
            Spacer()

            ZStack {
                ForEach(cards) { card in
                    CardView(title: card.title)
                        .offset(y: offsetFor(card))
                        .scaleEffect(scaleFor(card))
                        .animation(.spring(response: 0.1,
                                          dampingFraction: 0.6), value: jumpCard)
                }
            }
            .frame(height: 300)

            Spacer()

            Button("Jump!") {
                if let randomCard = cards.randomElement() {
                    jumpCard = randomCard
                    // Optional: Reset after delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        jumpCard = nil
                    }
                }
            }
            .padding()
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    // Jump effect:
    private func offsetFor(_ card: Card) -> CGFloat {
        if card == jumpCard {
            return -200
        } else {
            return 0
        }
    }
   // Scale efect
    private func scaleFor(_ card: Card) -> CGFloat {
        if card == jumpCard {
            return 1.1
        } else {
            return 1.0
        }
    }
}

struct CardView: View {
    let title: String

    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.blue)
            .frame(width: 250, height: 150)
            .overlay(
                Text(title)
                    .font(.title)
                    .foregroundColor(.white)
            )
            .shadow(radius: 10)
    }
}

#Preview {
    CardJumpOutView()
}
