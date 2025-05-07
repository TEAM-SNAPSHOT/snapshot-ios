//
//  NumericTextField.swift
//  snapshot
//
//  Created by cher1shRXD on 5/7/25.
//


import SwiftUI

struct NumericTextField: View {
    @AppStorage("shotCount") private var shotCount = "8"
    @State private var isValid = true

    var body: some View {
        TextField("8", text: $shotCount)
            .keyboardType(.numberPad)
            .onChange(of: shotCount) { newValue in
                let filtered = newValue.filter { $0.isNumber }
                shotCount = filtered

                if let value = Int(filtered), (3...16).contains(value) {
                    isValid = true
                } else {
                    isValid = false
                }
            }
            .keyboardType(.numberPad)
            .multilineTextAlignment(.trailing)
            .frame(width: 32)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.gray.opacity(0.2))
            .roundedCorners(8, corners: [.allCorners])
            .hideKeyBoard()
    }
}

