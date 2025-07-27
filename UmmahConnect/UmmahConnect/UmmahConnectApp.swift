//
//  UmmahConnectApp.swift
//  UmmahConnect
//
//  Created by Ehab Abdalla on 7/26/25.
//

import SwiftUI

@main
struct UmmahConnectApp: App {
    @StateObject var userSession = UserSession()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(userSession)
        }
    }
}
