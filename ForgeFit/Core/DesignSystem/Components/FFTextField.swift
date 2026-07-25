//
//  FFTextField.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 22/07/26.
//

import SwiftUI

struct FFTextField: View {
    
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var showsClearButton: Bool = false
    
    var body: some View {
        HStack {
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            
            if showsClearButton, !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(FFColors.textSecondary)
                }
            }
        }
        .font(FFTypography.body)
        .padding(FFSpacing.sm)
        .background(FFColors.surface)
        .foregroundStyle(FFColors.textPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Light") {
    VStack(spacing: FFSpacing.md) {
        FFTextField(
            placeholder: "E-mail",
            text: .constant(""),
            showsClearButton: true
        )
        
        FFTextField(
            placeholder: "Senha",
            text: .constant(""),
            isSecure: true
        )
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    VStack(spacing: FFSpacing.md) {
        FFTextField(
            placeholder: "E-mail",
            text: .constant(""),
            showsClearButton: true
        )
        
        FFTextField(
            placeholder: "Senha",
            text: .constant(""),
            isSecure: true
        )
    }
    .padding()
    .preferredColorScheme(.dark)
}
