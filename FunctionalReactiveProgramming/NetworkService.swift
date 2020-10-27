//
//  NetworkService.swift
//  FunctionalReactiveProgramming
//
//  Created by 陸瑋恩 on 2020/10/25.
//

import Foundation
import RxSwift
import Combine

struct NetworkService {
    
    enum RequestError: String, Error {
        case clientError
        case serverError
        case unexpected
    }
    
    private let url = URL(string: "https://google.com")!
    
    // MARK: - Native
    func requestPlusOne_Native(input: Int, completion: @escaping (Result<Int, RequestError>) -> Void) {
        URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else { return }
            switch response.statusCode {
            case 200..<300:
                completion(.success(input + 1))
            case 400..<500:
                completion(.failure(.clientError))
            case 500..<600:
                completion(.failure(.serverError))
            default:
                completion(.failure(.unexpected))
            }
        }.resume()
    }
    
    // MARK: - RxSwift
    func requestPlusOne_RxSwift(input: Int) -> Single<Int> {
        return Single.create { (observer) -> Disposable in
            URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                guard let response = response as? HTTPURLResponse else { return }
                switch response.statusCode {
                case 200..<300:
                    observer(.success(input + 1))
                case 400..<500:
                    observer(.error(RequestError.clientError))
                case 500..<600:
                    observer(.error(RequestError.serverError))
                default:
                    observer(.error(RequestError.unexpected))
                }
            }.resume()
            return Disposables.create()
        }
    }
    
    // MARK: - Combine
    func requestPlusOne_Combine(input: Int) -> Future<Int, RequestError> {
        return Future { (promise) in
            URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                guard let response = response as? HTTPURLResponse else { return }
                switch response.statusCode {
                case 200..<300:
                    promise(.success(input + 1))
                case 400..<500:
                    promise(.failure(.clientError))
                case 500..<600:
                    promise(.failure(.serverError))
                default:
                    promise(.failure(.unexpected))
                }
            }.resume()
        }
    }
}
