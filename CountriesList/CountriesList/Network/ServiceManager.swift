//
//  CountriesListService.swift
//  CountriesList
//
//  Created by Vijay Thota on 5/17/23.
//

import Foundation

class ServiceManager {
    public func getCountries(completion: @escaping (Result<[Country], Error>) -> ()) {
        let url = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json")!
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode([Country].self, from: data)
                    completion(.success(result))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
