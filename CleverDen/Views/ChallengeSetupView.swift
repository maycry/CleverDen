//
//  ChallengeSetupView.swift
//  CleverDen
//

import SwiftUI

struct ChallengeSetupView: View {
    let course: Course
    
    @State private var player1Name: String = ""
    @State private var player2Name: String = ""
    @State private var showChallenge: Bool = false
    
    var body: some View {
        ZStack {
            Color.backgroundSecondary
                .ignoresSafeArea()
            
            VStack(spacing: .spacingXL) {
                Spacer()
                
                // Icon
                Image("foxLogo")
                
                // Title
                Text("Let the Challenge\nBegin!")
                    .font(.headlineLarge)
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                
                Spacer()
                    .frame(height: .spacingM)
                
                // Player name fields
                VStack(spacing: .spacingM) {
                    playerNameField(text: $player1Name, placeholder: "Player 1")
                    
                    Text("vs")
                        .font(.bodyLarge)
                        .foregroundColor(.textSecondary)
                    
                    playerNameField(text: $player2Name, placeholder: "Player 2")
                }
                .padding(.horizontal, .screenPadding)
                
                Spacer()
                    .frame(height: .spacingM)
                
                // Start button
                Button {
                    showChallenge = true
                } label: {
                    Text("START")
                        .font(.headlineMedium)
                        .foregroundColor(.textOnAccent)
                        .frame(maxWidth: .infinity)
                        .padding(.spacingM)
                        .background(Color.accentGreen)
                        .cornerRadius(.radiusCard)
                }
                .padding(.horizontal, .screenPadding)
                
                Spacer()
                
                // Landscape hint
                Text("Turn your screen into landscape orientation")
                    .font(.caption2)
                    .foregroundColor(.textInactive)
                    .padding(.bottom, 100) // above nav bar
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .fullScreenCover(isPresented: $showChallenge) {
            ChallengePlayView(
                course: course,
                player1Name: player1Name.isEmpty ? "Player 1" : player1Name,
                player2Name: player2Name.isEmpty ? "Player 2" : player2Name
            )
        }
    }
    
    private func playerNameField(text: Binding<String>, placeholder: String) -> some View {
        TextField("", text: text, prompt: Text(placeholder).foregroundColor(.textSecondary))
            .font(.bodyLarge)
            .foregroundColor(.textPrimary)
            .multilineTextAlignment(.center)
            .padding(.cardPadding)
            .background(Color.cardBackground)
            .cornerRadius(.radiusCard)
            .shadowSubtle()
    }
}
