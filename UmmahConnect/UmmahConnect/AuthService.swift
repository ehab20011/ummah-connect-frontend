import Foundation

struct AuthService {
    private static var baseURL: String { Secrets.apiURL }    
    
    /*************************************
        LOGIN AUTH LOGIC
     ************************************/
    static func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/login") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let esc = CharacterSet.urlQueryAllowed
        let bodyParams = "username=\(email.addingPercentEncoding(withAllowedCharacters: esc) ?? "")&password=\(password.addingPercentEncoding(withAllowedCharacters: esc) ?? "")"
        request.httpBody = bodyParams.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            handleTokenResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    /******************************
      SIGNUP AUTH LOGIC [JSON BODY]
     *********************************************/
    static func signup(payload: SignupPayload, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/auth/signup") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(payload)
        } catch {
            completion(.failure(error))
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            handleTokenResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    /************************
        RESPONSE HANDLER
     ************************************/
    private static func handleTokenResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<String, Error>) -> Void) {
        if let error = error {
            completion(.failure(error)); return
        }
        guard let http = response as? HTTPURLResponse, let data = data else {
            completion(.failure(URLError(.badServerResponse))); return
        }

        if (200..<300).contains(http.statusCode) {
            do {
                let token = try JSONDecoder().decode(Token.self, from: data)
                completion(.success(token.access_token))
            } catch {
                completion(.failure(error))
            }
        } else {
            let msg = String(data: data, encoding: .utf8) ?? "Unknown error"
            completion(.failure(NSError(domain: "AuthService", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg])))
        }
    }
}
