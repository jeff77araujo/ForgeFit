//
//  HomeView.swift
//  ForgeFit
//
//  Created by Jeff Araujo on 27/07/26.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        VStack(spacing: FFSpacing.sm) {
            Text("Bem-vindo ao ForgeFit")
                .font(FFTypography.largeTitle)
                .foregroundStyle(FFColors.textPrimary)
            Text("Em breve: resumo do seu progresso aqui")
                .font(FFTypography.caption)
                .foregroundStyle(FFColors.textSecondary)
        }
        .padding(FFSpacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FFColors.background)
        .navigationTitle("Home")
    }
}

#Preview("Light") {
    NavigationStack {
        HomeView()
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        HomeView()
    }
    .preferredColorScheme(.dark)
}
