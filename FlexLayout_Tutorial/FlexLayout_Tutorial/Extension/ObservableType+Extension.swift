//
//  ObservableType+Extension.swift
//  FlexLayout_tutorial
//
//  Created by 송형욱 on 2021/12/22.
//
import Foundation
import RxCocoa
import RxSwift

extension ObservableType {

    func catchErrorJustComplete() -> Observable<Element> {
//        return `catch` { _ in
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in // error in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
