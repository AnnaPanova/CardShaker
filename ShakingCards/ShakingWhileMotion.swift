//
//  ShakingWhileMotion.swift
//  ShakingCards
//
//  Created by Anna Panova on 15.04.25.
//

// GOAL: Imitatin of card shacking while device is on motion

import SwiftUI
import CoreMotion

// Card Model
struct CardForMotion: Identifiable, Equatable {
    let id: UUID = UUID()
    let title: String
}

// Card View
struct CardViewForMotion: View {
    let title: String
    
    var body: some View
    {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.purple)
            .frame(width: 250,height: 150)
            .overlay {
                Text(title)
                    .font(.title)
                    .foregroundColor(Color.white)
            }
            .shadow(radius: 10)
    }
}

// Main View
struct CardShakeView:View {
    @State private var jumpCard: CardForMotion? = nil
    @StateObject private var motion = MotionManager()
    
    @State private var cards: [CardForMotion] = [
        CardForMotion(title: "Kitchen"),
        CardForMotion(title: "Bathroom"),
        CardForMotion(title: "Hall"),
        CardForMotion(title: "Livingroom"),
        CardForMotion(title: "Main bedroom")
    ]
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                ForEach(cards) { card in
                    CardViewForMotion(title: card.title)
                        .offset(y: offsetFor(card))
                        .scaleEffect(scaleFor(card))
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: jumpCard)
                }
            }
            .frame(height: 300)
            Spacer()
            Text("Shake ypur phone to make a card jump out!")
                .font(.title)
                .foregroundColor(Color.gray)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                
        }
        .padding()
        .onChange(of: motion.didShake) { newValue, oldValue in
            if newValue {
            triggerCardJump()
            }
        }
    }
    // function for offsetting card:
    private func offsetFor(_ card: CardForMotion) -> CGFloat {
        if card == jumpCard {
            return -200
        } else {
            return 0
        }
    }
    
    // function for scaling card:
    private func scaleFor(_ card: CardForMotion) -> CGFloat {
        if card == jumpCard {
            return 1.1
        } else {
            return 1.0
        }
    }
    
    // function for trigger card jumping
    private func triggerCardJump() {
        if let randomCard = cards.randomElement() {
            jumpCard = randomCard
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                jumpCard = nil
            }
        }
    }
    
    
}

struct ShakingWhileMotion: View {
    let cellHeight = 250
    let cellWidht = 150
    let areas: [String] = ["Kitchen", "Bathroom", "Hall", "Livingroom", "Main bedroom"]
    
    var body: some View {
        Text("ShakingWhileMotion")
    }
}

// Class that works with Shake detection, integrated with UIKit
class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    private var timer: Timer?
    
    @Published var didShake: Bool = false
    
    init() {
        startMotionUpdates()
    }
    func startMotionUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1
            motionManager.startAccelerometerUpdates()
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
                if let data = self.motionManager.accelerometerData {
                    let acceleration = data.acceleration
                    let threshold = 2.2
                    if abs(acceleration.x) > threshold || abs(acceleration.y) > threshold || abs(acceleration.z) > threshold {
                                          DispatchQueue.main.async {
                                              self.didShake = true
                                              print("Shake detected!")
                                          }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    self.didShake = false
                                                }
                }
            }
        }
    }
}
    deinit {
           motionManager.stopAccelerometerUpdates()
           timer?.invalidate()
       }
   }

#Preview {
    CardShakeView()
}
