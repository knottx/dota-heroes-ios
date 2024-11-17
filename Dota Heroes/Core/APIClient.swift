//
//  APIClient.swift
//  Dota Heroes
//
//  Created by Visarut Tippun on 17/11/2024.
//

import Alamofire
import Foundation
import RxAlamofire
import RxSwift

enum APIResponseMiddleware {
    static func inject(responseJSON response: DataResponse<Any, AFError>) {
        #if DEBUG
        if let statusCode = response.response?.statusCode {
            AppLogger.response.log("Status Code: \(statusCode)")
        }
        if let response = response.data?.asString() {
            AppLogger.response.log(response)
        }
        if let headers = try? response.response?.allHeaderFields.data().asString() {
            AppLogger.response.log(headers)
        }
        #endif
    }
}

final class APIClient {
    static let shared = APIClient()
    private let bag = DisposeBag()
    let manager: Session

    init(background: Bool = false) {
        let configuration: URLSessionConfiguration = background ? .background(withIdentifier: "background") : .default
        configuration.timeoutIntervalForRequest = 45
        self.manager = Session(configuration: configuration)
    }

    func request<T: Decodable>(path: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil) -> Single<T> {
        let url = AppConstants.baseUrl + path
        return self.manager.rx.data(method, url, parameters: parameters)
            .do(onNext: { data in
                #if DEBUG
                let responseData = try? JSONSerialization.jsonObject(with: data, options: [])
                AppLogger.response.log("Response Data: \(responseData ?? "No response data")")
                #endif
            })
            .map { data -> T in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(T.self, from: data)
                return result
            }.asSingle()
    }
}
