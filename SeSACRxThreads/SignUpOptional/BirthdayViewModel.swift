//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by 박태현 on 2023/11/01.
//

import Foundation
import RxSwift

final class BirthdayViewModel {

    let yearData: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    let monthData: BehaviorSubject<Int> = BehaviorSubject(value: 0)
    let dayData: BehaviorSubject<Int> = BehaviorSubject(value: 0)

    let birthDayDate: BehaviorSubject<Date> = BehaviorSubject(value: .now)

    private let disposeBag = DisposeBag()

    init() {
        bind()
    }

    private func bind() {
        birthDayDate
            .map {
                Calendar.current
                    .dateComponents(
                        [.year, .month, .day],
                        from: $0
                    )
            }
            .subscribe(with: self) { owner, value in
                guard let year = value.year,
                      let month = value.month,
                      let day = value.day
                else { return }
                owner.yearData.onNext(year)
                owner.monthData.onNext(month)
                owner.dayData.onNext(day)
            }
            .disposed(by: disposeBag)
    }
}
