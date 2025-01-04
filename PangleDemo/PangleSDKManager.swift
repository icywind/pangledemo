//
//  PangleSDKManager.swift
//  PangleDemo
//
//  Created by Rick Cheng on 1/3/25.
//
import Foundation
import SwiftUI
import PAGAdSDK

enum InterstitialAdStatus: String {
    case none = "none"
    case ready = "ready"
    case showing = "showing"
    case dismissed = "dismissed"
    case failed = "failed"
    case clicked = "clicked"
}

class PangleSDKManager : NSObject,ObservableObject,PAGLInterstitialAdDelegate {
    @Published var adStatus: InterstitialAdStatus = .none
    @Published var showingInterstitialAd: Bool = false
    
    private var interstitialAd:PAGLInterstitialAd?
    
    override init() {
        let config = PAGAdSDK.PAGConfig.share()
        
        // Using a test AppID, see reference doc:
        //   https://www.pangleglobal.com/integration/How-to-Test-Pangle-Ads-with-Ad-ID
        config.appID = Consts.Pangle.appID
        config.appLogoImage = UIImage(named: "AppIcon")
        
        // some available privacy settings
        config.childDirected = .nonChild //set the value of COPPA
        config.gdprConsent = .consent //set the value of GDPR
        config.doNotSell = .notSell  //set the valud of CCPA
        
    #if DEBUG
        config.debugLog = true
    #endif
        
        PAGSdk.start(with: config) { success, error in
            if (success) {
                let ver = PAGSdk.sdkVersion
                print("PAGSdk (version \(ver)) start successfully!")
            } else {
                print(error?.localizedDescription ?? "Error!")
            }
        }

    }

    func loadInterstitialAd(slotId:String=Consts.Pangle.Placement.Interstitial) {
        if adStatus == .none || adStatus == .failed || adStatus == .dismissed {
           let adRequest = PAGInterstitialRequest()
           PAGLInterstitialAd.load(withSlotID: slotId,
                                   request: adRequest) {
               [weak self] interstitialAd, error in
               if let error = error {
                   print(error.localizedDescription)
                   return
               }
               if let interstitialAd = interstitialAd {
                   print("interstitialAd loaded and ready!")
                   self?.interstitialAd = interstitialAd
                   interstitialAd.delegate = self
                   self?.adStatus = .ready
                   
                   // show the ad
                   guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                         let rootViewController = windowScene.windows.first?.rootViewController else {
                       return
                   }
                   interstitialAd.present(fromRootViewController: rootViewController)
               }
           }
       }
    }
    
    func adDidShow(_ ad: PAGAdProtocol) {
        adStatus = .showing
        print("interstitialAd showed!")
    }
    
    func adDidClick(_ ad: PAGAdProtocol) {
        adStatus = .clicked
        print("interstitialAd clicked!")
    }
    
    func adDidDismiss(_ ad: PAGAdProtocol) {
        interstitialAd = nil
        adStatus = .dismissed
        showingInterstitialAd = false
        print("interstitialAd dismissed!")
    }
}
