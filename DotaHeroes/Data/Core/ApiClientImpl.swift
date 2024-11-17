//
//  ApiClientImpl.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import Alamofire
import Foundation
import RxAlamofire
import RxSwift

final class ApiClientImpl: ApiClient  {
    
    private let session: Session

    init(background: Bool = false) {
        let configuration: URLSessionConfiguration = background
            ? .background(withIdentifier: "background")
            : .default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 45
        configuration.timeoutIntervalForResource = 60
        self.session = Session(configuration: configuration)
    }

    func requestDecodable<T: Decodable>(_ path: String,
                                        method: HTTPMethod = .get,
                                        params: [String: Any]? = nil) -> Single<T> {
        let url = AppConstants.baseUrl + path
        return self.session.rx.request(method, url, parameters: params)
            .responseData()
            .map { _, data in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                return result
            }.asSingle()
    }
}
