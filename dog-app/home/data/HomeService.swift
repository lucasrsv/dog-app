//
//  HomeService.swift
//  dog-app
//
//  Created by Lucas Rodrigues on 17/12/23.
//

import Foundation

struct HomeService {
    private let networkManager: NetworkManager

    init(baseURL: String) {
        self.networkManager = NetworkManager(baseURL: baseURL)
    }

    func fetchDogBreeds(completion: @escaping (Result<[String], DataError>) -> Void) {
        networkManager.performRequest(endpoint: "breeds/list/all", decodingType: BreedsModel.self) { (result: Result<BreedsModel, DataError>) in
            switch result {
            case .success(let breedsModel):
                let breeds = breedsModel.message.keys.map { $0 }
                completion(.success(breeds))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchDogImages(for breed: String, completion: @escaping (Result<[String], DataError>) -> Void) {
        let endpoint = "breed/\(breed)/images"
        networkManager.performRequest(endpoint: endpoint, decodingType: BreedImagesModel.self) { (result: Result<BreedImagesModel, DataError>) in
            switch result {
            case .success(let breedsModel):
                let breeds = breedsModel.message
                completion(.success(breeds))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
