//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    
    private let viewModel = PhoneViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        phoneTextField.keyboardType = .numberPad

        configureLayout()
        bind()

        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }

    
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    private func bind() {
        // MARK: Output

        viewModel.phoneNumberInput
            .bind(to: phoneTextField.rx.text)
            .disposed(by: disposeBag)

        viewModel.isButtonValid
            .bind(with: self) { owner, isValid in
                owner.nextButton.backgroundColor = isValid ? .systemGreen : .systemRed
                owner.nextButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)

        //MARK: - Input

        phoneTextField.rx.text
            .orEmpty
            .subscribe(with: self) { owner, value in
                let formattedValue = value.formated(by: "###-####-####")
                owner.viewModel.phoneNumberInput.onNext(formattedValue)
            }
            .disposed(by: disposeBag)

        phoneTextField.rx.text
            .orEmpty
            .map { $0.count > 11 }
            .subscribe(with: self) { owner, value in
                owner.viewModel.isButtonValid.onNext(value)
            }
            .disposed(by: disposeBag)
    }

}
