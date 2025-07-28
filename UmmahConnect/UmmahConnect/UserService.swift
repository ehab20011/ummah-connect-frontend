import Foundation

struct UserService {
    private static var baseURL: String { Secrets.apiURL }

    /// Fetch the authenticated user's profile using the provided JWT access token.
    static func fetchCurrentUser(token: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/me") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error)); return
            }
            guard let http = response as? HTTPURLResponse, let data = data else {
                completion(.failure(URLError(.badServerResponse))); return
            }

            if (200..<300).contains(http.statusCode) {
                do {
                    let profile = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(profile))
                } catch {
                    completion(.failure(error))
                }
            } else {
                let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
                completion(.failure(NSError(domain: "UserService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])))
            }
        }.resume()
    }
} 