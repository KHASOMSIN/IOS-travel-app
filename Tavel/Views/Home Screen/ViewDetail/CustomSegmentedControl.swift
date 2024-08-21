//
//  CustomSegmentedControl.swift
//  Tavel
//
//  Created by user245540 on 8/2/24.
//

import UIKit
import SnapKit

class CustomSegmentedControl: UIControl {
    
    private var buttons: [UIButton] = []
    private var selector: UIView!
    private var segmentIndicator: UIView!
    public private(set) var selectedSegmentIndex = 0
    
    var buttonTitles: [String]!
    var textColor: UIColor = .black
    var selectorColor: UIColor = .red
    var selectorTextColor: UIColor = .red

    convenience init(frame: CGRect, buttonTitles: [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitles
        self.configureView()
    }
    
    private func configureView() {
        self.backgroundColor = .clear
        self.createButtons()
        self.configureSelector()
        self.configureStackView()
    }
    
    private func createButtons() {
        buttons = [UIButton]()
        buttons.removeAll()
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(textColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(button:)), for: .touchUpInside)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }
    
    private func configureSelector() {
        segmentIndicator = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = selectorColor
            return view
        }()
        self.addSubview(segmentIndicator)
        
        segmentIndicator.snp.makeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(3)
            make.height.equalTo(2)
            make.width.equalTo(15 + (buttons[0].titleLabel?.text?.count ?? 0) * 8)
            make.centerX.equalTo(self.snp.centerX).dividedBy(buttonTitles.count)
        }
    }
    
    private func configureStackView() {
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func buttonTapped(button: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == button {
                selectedSegmentIndex = buttonIndex
                let titleCount = CGFloat(button.titleLabel?.text?.count ?? 0)
                let numberOfSegments = CGFloat(buttons.count)
//                let selectorStartPosition = frame.width / numberOfSegments * CGFloat(buttonIndex)
//                let centerXMultiplier = 1 / numberOfSegments / 1.5
                
                segmentIndicator.snp.remakeConstraints { make in
                    make.top.equalTo(self.snp.bottom).offset(3)
                    make.height.equalTo(2)
                    make.width.equalTo(15 + titleCount * 8)
                    make.centerX.equalTo(self.snp.centerX).dividedBy(numberOfSegments / CGFloat(3.0 + CGFloat(Double(buttonIndex) - 1.0) * 2.0))
                }
                
                UIView.animate(withDuration: 0.4) {
                    self.layoutIfNeeded()
                    self.segmentIndicator.transform = CGAffineTransform(scaleX: 1.4, y: 1)
                } completion: { _ in
                    UIView.animate(withDuration: 0.3) {
                        self.segmentIndicator.transform = CGAffineTransform.identity
                    }
                }
                
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
        sendActions(for: .valueChanged)
    }
    
    func setIndex(index: Int) {
        buttons.forEach { $0.setTitleColor(textColor, for: .normal) }
        let button = buttons[index]
        selectedSegmentIndex = index
        let titleCount = CGFloat(button.titleLabel?.text?.count ?? 0)
        let numberOfSegments = CGFloat(buttons.count)
//        let selectorStartPosition = frame.width / numberOfSegments * CGFloat(index)
        
        segmentIndicator.snp.remakeConstraints { make in
            make.top.equalTo(self.snp.bottom).offset(3)
            make.height.equalTo(2)
            make.width.equalTo(15 + titleCount * 8)
            make.centerX.equalTo(self.snp.centerX).dividedBy(numberOfSegments / CGFloat(3.0 + CGFloat(Double(index) - 1.0) * 2.0))
        }
        
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
            self.segmentIndicator.transform = CGAffineTransform(scaleX: 1.4, y: 1)
        } completion: { _ in
            UIView.animate(withDuration: 0.4) {
                self.segmentIndicator.transform = CGAffineTransform.identity
            }
        }
        
        button.setTitleColor(selectorTextColor, for: .normal)
    }
}

