// Created by Станислав on 16.02.2023.

import ABUIComponents
import SnapKit

protocol DisplaysShareholderDetailsView: UIView {
    func configure(_ viewModel: ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel)
}

final class ShareholderDetailsView: UIView {
    // MARK: - Views
    
    lazy var contactCellView = ContactCell()
    
    // MARK: - Private Properties
    
    private let appearance = Appearance()
    
    // MARK: - Initializers
    
    required init() {
        super.init(frame: .zero)
        
        backgroundColor = appearance.palette.backgroundPrimary
        addSubviews()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DisplaysShareholderDetailsView

extension ShareholderDetailsView: DisplaysShareholderDetailsView {
    func configure(_ viewModel: ShareholderDetailsDataFlow.PresentShareholderDetails.ViewModel) {
        contactCellView.configure(with: viewModel.shareholderDetails)
    }
}

// MARK: - Private

private extension ShareholderDetailsView {
    struct Appearance: Theme { }
    
    func addSubviews() {
        addSubview(contactCellView)
    }
    
    func makeConstraints() {
        contactCellView.snp.makeConstraints { make in
            make.topMargin.equalTo(10)
            make.leadingMargin.equalToSuperview()
            make.trailingMargin.equalToSuperview()
            make.height.equalTo(76)
        }
    }
}
