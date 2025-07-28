import Foundation

struct Token: Codable{
    let access_token: String
}

struct SignupPayload: Codable {
    let email: String
    let username: String
    let password: String
    let is_masjid: Bool
    let display_name: String?
    let phone_number: String
    let profile_pic_url: String?
    let address: String?
    let city: String?
    let state: String?
    let country: String?
    let ein: String?
}

struct UserProfile: Codable, Identifiable {
    let id: String
    let phone_number: String
    let email: String
    let username: String
    let display_name: String?
    let profile_pic_url: String?
    let is_masjid: Bool
    let last_active_at: String?
    let address: String?
    let city: String?
    let state: String?
    let country: String?
    let ein: String?
}
