import Foundation
import SwiftUI

class UserSession: ObservableObject {
    @Published var token: String?
    @Published var userId: String?
    @Published var isLoggedIn: Bool = false

    func login(with token: String) {
        self.token = token
        self.userId = decodeUserId(from: token)
        self.isLoggedIn = true
    }

    private func decodeUserId(from jwt: String) -> String? {
        let segments = jwt.split(separator: ".")
        guard segments.count == 3,
              let payloadData = Data(base64Encoded: String(segments[1]).paddingBase64()) else { return nil }

        if let json = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
           let userId = json["sub"] as? String {
            return userId
        }
        return nil
    }
}

extension String {
    func paddingBase64() -> String {
        let length = self.count
        let requiredPadding = (4 - (length % 4)) % 4
        return self + String(repeating: "=", count: requiredPadding)
    }
}
