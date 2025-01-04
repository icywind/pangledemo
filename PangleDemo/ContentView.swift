//
//  ContentView.swift
//  PangleDemo
//
//  Created by Rick Cheng on 1/3/25.
//

import SwiftUI
import PAGAdSDK


struct ContentView: View {
    
    @ObservedObject var pangleManager = PangleSDKManager()

    var body: some View {
        VStack { // Use a VStack to center the button vertically
            Text("Test Interstitial Ad").font(.title)
            
            Spacer() // Push the button towards the center
            
            Button(action: {
                // Action to perform when the button is tapped
                if !pangleManager.showingInterstitialAd {
                    pangleManager.loadInterstitialAd()
                    pangleManager.showingInterstitialAd = true
                }
            }) {
                Text("Load Ad")
                    .font(.headline) // Make the text a bit larger
                    .foregroundColor(.white) // White text
                    .padding(.horizontal, 20) // Horizontal padding
                    .padding(.vertical, 10)   // Vertical padding
                    .background(Color.blue) // Blue background
                    .cornerRadius(8)        // Rounded corners (adjust for more or less rounding)
            }
            .disabled(pangleManager.showingInterstitialAd) // disable the button until adStatus changed
            
            Spacer() // Push the button towards the center

            Text("ad status: " + pangleManager.adStatus.rawValue)
                .padding(.bottom) // Add some bottom padding
                .font(.footnote)
        }
        .padding() // Add general padding around the VStack
        .padding()
    }


}


#Preview {
    ContentView()
}

