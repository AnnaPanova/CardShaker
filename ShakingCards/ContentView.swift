//
//  ContentView.swift
//  ShakingCards
//
//  Created by Anna Panova on 11.04.25.
//

// GOAL: Imitation of shacking after tappind by stack

import SwiftUI

struct NotificationStack: View {
    @State var isExpanded: Bool = false
    let cellHeight = 250
    let cellWidht = 150
    let areas: [String] = ["Kitchen", "Bathroom", "Hall", "Livingroom", "Main bedroom"]
    
    var body: some View {
        ScrollView {
            VStack{
                LazyVStack(spacing: isExpanded ? 20: -Double(cellHeight)) {
                    ForEach(0..<areas.count,id: \.self){ index in
                       Text("Area: \(index): \(areas[index])")
                            .frame(width: CGFloat(cellWidht), height:CGFloat(cellHeight))
                            .background(.gray)
                            .border(.black, width: 0.3)
                            .clipShape(.rect(cornerRadius: 20))
                            .shadow(radius: 20)
                            .padding(.horizontal)
                        // we use the zIndex for putting first cart to be on top
                            .zIndex(Double(areas.count - index))
                            .offset(x: 0, y: getOffset(index: index))
                            .opacity(getOpacity(with: index))
                            .padding(.horizontal, getHorizontalPadding(index:index))
                        // smooth animation by taking elements insded a view as group
                            .geometryGroup()
                            .onTapGesture {
                                withAnimation {
                                    isExpanded.toggle()
                                }
                            }
                    }
                }
                .padding(.vertical)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
        }
      
        
    }
}

private extension NotificationStack {
    
    // set up how much the bottom card is visible from under the top one
    func getOffset(index: Int) -> CGFloat {
        isExpanded ? 0 : CGFloat(index * 20)
    }
    
    func getOpacity(with index: Int) -> Double {
        isExpanded ? 1 : 1 - Double(index) / Double(areas.count)
    
    }
    
    // increase of padding visually create stack of cards
    func getHorizontalPadding(index: Int) -> CGFloat {
        isExpanded ? 0 : 2 * CGFloat(index)
    }
}

#Preview {
    NotificationStack()
}
