//
//  ComplexViewController.swift
//  FunctionalReactiveProgramming
//
//  Created by 陸瑋恩 on 2020/10/28.
//

import UIKit
import RxSwift
import Combine
import PromiseKit

class ComplexViewController: UIViewController {
    
    private let networkService = NetworkService()
    
    private let disposeBag = DisposeBag()
    private var cancellableSet = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Native
        networkService.requestPlusOne_Native(input: 1) { (result) in
            switch result {
            case .success(let output):
                self.networkService.requestPlusOne_Native(input: output) { (result) in
                    switch result {
                    case .success(let output):
                        self.networkService.requestPlusOne_Native(input: output) { (result) in
                            switch result {
                            case .success(let output):
                                self.networkService.requestPlusOne_Native(input: output) { (result) in
                                    switch result {
                                    case .success(let output):
                                        print("Native: \(output)")
                                    case .failure(let requestError):
                                        print("Native Error: \(requestError.rawValue)")
                                    }
                                }
                            case .failure(let requestError):
                                print("Native Error: \(requestError.rawValue)")
                            }
                        }
                    case .failure(let requestError):
                        print("Native Error: \(requestError.rawValue)")
                    }
                }
            case .failure(let requestError):
                print("Native Error: \(requestError.rawValue)")
            }
        }
        
        // MARK: - RxSwift
        networkService.requestPlusOne_RxSwift(input: 1)
            .flatMap { self.networkService.requestPlusOne_RxSwift(input: $0) }
            .flatMap { self.networkService.requestPlusOne_RxSwift(input: $0) }
            .flatMap { self.networkService.requestPlusOne_RxSwift(input: $0) }
            .retry(3)
            .subscribe { (event) in
                switch event {
                case .success(let output):
                    print("RxSwift: \(output)")
                case .error(let error):
                    guard let requestError = error as? NetworkService.RequestError else { return }
                    print("RxSwift Error: \(requestError.rawValue)")
                }
            }
            .disposed(by: disposeBag)
        
        // MARK: - ReactiveSwift
        networkService.requestPlusOne_ReactiveSwift(input: 1)
            .flatMap(.latest) { self.networkService.requestPlusOne_ReactiveSwift(input: $0) }
            .flatMap(.latest) { self.networkService.requestPlusOne_ReactiveSwift(input: $0) }
            .flatMap(.latest) { self.networkService.requestPlusOne_ReactiveSwift(input: $0) }
            .retry(upTo: 3)
            .startWithResult { (result) in
                switch result {
                case .success(let output):
                    print("ReactiveSwift: \(output)")
                case .failure(let requestError):
                    print("ReactiveSwift Error: \(requestError.rawValue)")
                }
            }
        
        // MARK: - Combine
        networkService.requestPlusOne_Combine(input: 1)
            .flatMap { self.networkService.requestPlusOne_Combine(input: $0) }
            .flatMap { self.networkService.requestPlusOne_Combine(input: $0) }
            .flatMap { self.networkService.requestPlusOne_Combine(input: $0) }
            .retry(3)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let requestError):
                    print("Combine Error: \(requestError.rawValue)")
                }
            }, receiveValue: { (output) in
                print("Combine: \(output)")
            })
            .store(in: &cancellableSet)
        
        // MARK: - Promise
        firstly {
            networkService.requestPlusOne_Promise(input: 1)
        }.then {
            self.networkService.requestPlusOne_Promise(input: $0)
        }.then {
            self.networkService.requestPlusOne_Promise(input: $0)
        }.then {
            self.networkService.requestPlusOne_Promise(input: $0)
        }.done {
            print("Promise: \($0)")
        }.catch {
            guard let requestError = $0 as? NetworkService.RequestError else { return }
            print("Promise Error: \(requestError.rawValue)")
        }
    }
}
