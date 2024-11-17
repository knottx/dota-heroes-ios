//
//  ApiClient.swift
//  DotaHeroes
//
//  Created by Visarut Tippun on 13/08/2025.
//

import RxSwift
import Alamofire
import Foundation

protocol ApiClient {
    func requestDecodable<T: Decodable>(_ path: String,
                                        method: HTTPMethod,
                                        params: [String: Any]?) -> Single<T>
}
