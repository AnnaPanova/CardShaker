//
//  CardJumpOut.swift
//  ShakingCards
//
//  Created by Anna Panova on 14.04.25.
//
// GOAL: One card jump out of stack
import SwiftUI

struct CardJumpOut: View {
    @State private var isCardOut = false
    let areas: [String] = ["Kitchen", "Bathroom", "Hall", "Livingroom", "Main bedroom"]
    let cellHeight = 300
    let cellWidht = 200
    
    var body: some View {
        ZStack(alignment: .center) {
            ForEach(0..<areas.count, id: \.self) { index in
                Text("Area: \(index): \(areas[index])")
                     .frame(width: CGFloat(cellWidht), height:CGFloat(cellHeight))
                     .background(.gray)
                     .border(.black, width: 0.3)
                     .clipShape(.rect(cornerRadius: 20))
                     .shadow(radius: 20)
                     .padding(.horizontal)
                // we use the zIndex for putting first cart to be on top
                     .zIndex(Double(areas.count - index))
                // offset y position for imitation  card jumping out of stack
                     .offset(y: isCardOut && index == 0 ? -200 : 0)
                     .animation(.spring(), value: isCardOut)
                     .onTapGesture {
                         withAnimation {
                             isCardOut.toggle()
                         }
                     }
                     
            }
        }
    }
}



#Preview {
    CardJumpOut()
}
