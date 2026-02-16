//
//  GlobePreview3DView.swift
//  CleverDen
//

import SwiftUI

struct GlobePreview3DView: View {
    let countries = ["France", "Germany", "Spain", "Italy", "United Kingdom", "Japan", "Brazil", "Australia"]
    @State private var selected = "France"
    
    var body: some View {
        VStack(spacing: 0) {
            Text("3D Globe Preview")
                .font(.headlineLarge)
                .padding(.top, 60)
                .padding(.bottom, .spacingM)
            
            ZStack {
                Globe3DView(countryName: selected)
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: .radiusCard))
                
                // Tooltip overlay
                VStack {
                    Text(selected)
                        .font(.bodyLarge)
                        .foregroundColor(.textPrimary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.backgroundPrimary.opacity(0.9))
                                .shadowSubtle()
                        )
                    Spacer()
                }
                .padding(.top, 16)
            }
            .frame(height: 350)
            .padding(.horizontal, .screenPadding)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .spacingS) {
                    ForEach(countries, id: \.self) { country in
                        Button(country) {
                            selected = country
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(selected == country ? .accentOrange : .gray)
                    }
                }
                .padding(.horizontal, .screenPadding)
            }
            .padding(.top, .spacingL)
            
            Spacer()
        }
        .background(Color.backgroundSecondary.ignoresSafeArea())
    }
}
