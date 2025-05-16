//
//  Untitled.swift
//  ShakingCards
//
//  Created by Anna Panova on 15.04.25.
//

import SwiftUI

struct CoveredCircle: View {
         var body: some View {
             Circle()
                .frame(width: 300, height: 200)
                .overlay(.ultraThinMaterial)
        }
    }

#Preview{
    CoveredCircle()
}
