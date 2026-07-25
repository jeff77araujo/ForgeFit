//
//  FFCard.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 22/07/26.
//

import SwiftUI

struct FFCard<Content: View>: View {
    
    @ViewBuilder let content: Content
    
    var body: some View {
        content
            .padding(FFSpacing.md)
            .background(FFColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview("Light") {
    FFCard {
        VStack(alignment: .leading, spacing: FFSpacing.xxs) {
            Text("Treino de Peito")
                .font(FFTypography.headline)
            Text("4 exercícios")
                .font(FFTypography.caption)
                .foregroundStyle(FFColors.textSecondary)
        }
    }
    .padding()
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    FFCard {
        VStack(alignment: .leading, spacing: FFSpacing.xxs) {
            Text("Treino de Peito")
                .font(FFTypography.headline)
            Text("4 exercícios")
                .font(FFTypography.caption)
                .foregroundStyle(FFColors.textSecondary)
        }
    }
    .padding()
    .preferredColorScheme(.dark)
}
