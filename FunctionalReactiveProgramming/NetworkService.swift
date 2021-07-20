//
//  NetworkService.swift
//  FunctionalReactiveProgramming
//
//  Created by 陸瑋恩 on 2020/10/25.
//

import RxSwift
import ReactiveSwift
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
        URLSession.shared.dataTask(with: url) { (data, response, error) in
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
        return Single.create { (observer) -> RxSwift.Disposable in
            URLSession.shared.dataTask(with: url) { (data, response, error) in
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
    
    // MARK: - ReactiveSwift
    func requestPlusOne_ReactiveSwift(input: Int) -> SignalProducer<Int, RequestError> {
        return SignalProducer<Int, RequestError> { (observer, lifetime) in
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let response = response as? HTTPURLResponse else { return }
                switch response.statusCode {
                case 200..<300:
                    observer.send(.value(input + 1))
                case 400..<500:
                    observer.send(.failed(.clientError))
                case 500..<600:
                    observer.send(.failed(.serverError))
                default:
                    observer.send(.failed(.unexpected))
                }
            }
        }
    }
    
    // MARK: - Combine
    func requestPlusOne_Combine(input: Int) -> Future<Int, RequestError> {
        return Future { (promise) in
            URLSession.shared.dataTask(with: url) { (data, response, error) in
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
