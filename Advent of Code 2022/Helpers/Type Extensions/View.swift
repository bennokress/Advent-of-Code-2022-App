//
//  View.swift
//  Advent of Code 2022
//
//  Created by Benno on 02.12.22.
//

import SwiftUI

extension View {
    
    func border(in color: Color = .accentColor, lineWidth: CGFloat = 1, cornerRadius: CGFloat) -> some View {
        overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(color, lineWidth: lineWidth)
        )
    }
    
}
