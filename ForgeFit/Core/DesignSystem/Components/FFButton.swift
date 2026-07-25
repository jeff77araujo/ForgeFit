//
//  FFButton.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 22/07/26.
//

import SwiftUI

enum FFButtonStyle {
    case primary
    case secondary
}

struct FFButton: View {
    
    let title: String
    var style: FFButtonStyle = .primary
    var isLoading: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Text(title)
                    .font(FFTypography.headline)
                    .opacity(isLoading ? 0 : 1)
                
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, FFSpacing.sm)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(isLoading)
    }
    
    private var backgroundColor: Color {
        style == .primary ? FFColors.accent : FFColors.surface
    }
    
    private var foregroundColor: Color {
        style == .primary ? .white : FFColors.textPrimary
    }
}

#Preview("Light") {
    VStack(spacing: FFSpacing.md) {
        FFButton(
            title: "Continuar",
            style: .primary,
            action: {}
        )
        
        FFButton(
            title: "Cancelar",
            style: .secondary,
            action: {}
        )
        
        FFButton(
            title: "Carregando",
            style: .primary,
            isLoading: true,
            action: {}
        )
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    VStack(spacing: FFSpacing.md) {
        FFButton(
            title: "Continuar",
            style: .primary,
            action: {}
        )
        
        FFButton(
            title: "Cancelar",
            style: .secondary,
            action: {}
        )
        
        FFButton(
            title: "Carregando",
            style: .primary,
            isLoading: true,
            action: {}
        )
    }
    .padding()
    .preferredColorScheme(.dark)
}
