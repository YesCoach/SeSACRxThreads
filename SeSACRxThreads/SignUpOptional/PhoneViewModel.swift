//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by 박태현 on 2023/11/01.
//

import Foundation
import RxSwift

final class PhoneViewModel {

    let phoneNumberInput: BehaviorSubject<String> = BehaviorSubject(value: "010")
    let isButtonValid: BehaviorSubject<Bool> = BehaviorSubject(value: false)

    private let disposeBag = DisposeBag()

    init() {
        bind()
    }

    private func bind() {
        phoneNumberInput
            .bind {
                print("phoneNumber: \($0)")
            }
            .disposed(by: disposeBag)
    }
}

