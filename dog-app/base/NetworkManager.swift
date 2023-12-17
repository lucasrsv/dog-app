//
//  NetworkManager.swift
//  dog-app
//
//  Created by Lucas Rodrigues on 17/12/23.
//

import Foundation

class NetworkManager {
    private let baseURL: String

    init(baseURL: String) {
        self.baseURL = baseURL
    }

    func performRequest<T: Decodable>(endpoint: String, decodingType: T.Type, completion: @escaping (Result<T, DataError>) -> Void) {
        let fullURL = baseURL + endpoint
        let url = URL(filePath: fullURL)

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, 200 ... 299 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(decodingType, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(.message(error)))
            }
        }.resume()
    }
}

enum DataError: Error {
    case invalidData
    case invalidResponse
    case message(_ error: Error?)
}
