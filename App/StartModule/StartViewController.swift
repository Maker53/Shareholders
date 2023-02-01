//
//  StartVC.swift
//  AlfaOnboarding
//
//  Created by Vasily Ponomarev on 06/12/2019.
//  Copyright © 2019 Alfa-Bank. All rights reserved.
//
import SharedRouter
import SnapKit
import UIKit

final class StartViewController: UIViewController, Navigates {
    private let routes: StartRoutes.Type
    private lazy var startButton: UIButton = {
        let b = UIButton(
            title: "Start your module",
            font: .boldAppFontOfSize17,
            target: self,
            action: #selector(startButtonDidTapped)
        )
        b.contentEdgeInsets = .init(vertical: 10, horizontal: 16)
        b.layer.borderWidth = 3
        b.layer.cornerRadius = 10
        b.layer.borderColor = UIColor.white.cgColor
        return b
    }()

    init(routes: StartRoutes.Type) {
        self.routes = routes
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsAndConstraints()
    }

    @objc
    func startButtonDidTapped() {
        navigate(to: routes.shareholdersList())
    }

    private func setupViewsAndConstraints() {
        view.backgroundColor = .red
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
