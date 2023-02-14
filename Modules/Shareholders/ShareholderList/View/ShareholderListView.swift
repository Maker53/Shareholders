// Created by Станислав on 07.02.2023.

import ABUIComponents
import SnapKit

protocol DisplayShareholderListView: UIView { }

protocol ShareholderListViewDelegate: AnyObject { }

final class ShareholderListView: UIView {
    // MARK: - Internal Properties
    
    weak var delegate: ShareholderListViewDelegate?
    
    // MARK: - Initializers
    
    required init(delegate: ShareholderListViewDelegate?) {
        self.delegate = delegate
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DisplayShareholderListView

extension ShareholderListView: DisplayShareholderListView { }
