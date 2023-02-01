///  Created by Roman Turov on 16/04/2019.

import ABUIComponents
import SnapKit

protocol OfficeChangingViewDelegate: AnyObject {
    func didTapOnConfirmationButton()
    func didTapUpdateButton()
}

class OfficeChangingView: UIView {
    weak var delegate: OfficeChangingViewDelegate?
    let appearance = Appearance()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = appearance.estimatedRowHeight
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never
        return tableView
    }()

    lazy var confirmationButton: MainButton<MainButtonStyle.Primary> = {
        let button = MainButton<MainButtonStyle.Primary>(isEnabled: false)
        button.setTitle("Confirm".localized() as String, for: .init())
        button.addTarget(self, action: #selector(didTapOnConfirmationButton), for: .touchUpInside)
        return button
    }()

    init(delegate: OfficeChangingViewDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func didTapOnConfirmationButton() {
        delegate?.didTapOnConfirmationButton()
    }
}

extension OfficeChangingView {
    struct Appearance: Grid {
        let estimatedRowHeight: CGFloat = gridUnitSize.height * 14
    }
}

private extension OfficeChangingView {
    func addSubviews() {
        addSubview(tableView)
        addSubview(confirmationButton)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        confirmationButton.snp.makeConstraints { make in
            make.bottom.equalTo(snp_safeArea).inset(appearance.xsSpace)
            make.left.right.equalToSuperview().inset(appearance.horizontalMargin)
            make.height.equalTo(appearance.xxlSpace)
        }
    }
}

// MARK: - ContentStateView

extension OfficeChangingView: ContentStateView {
    func styleForWaitingView() -> WaitingView.Style? {
        .lightWithBackground
    }

    func viewModelForAdditionalView(of state: ContentState) -> ContentStateViewModel? {
        switch state {
        case .empty:
            return ContentStateViewModel(
                image: UIImage(),
                title: "SomethingWentWrong".localized() as String,
                subtitle: nil,
                buttonTitle: "Refresh".localized() as String,
                buttonActionHandler: { [weak self] in
                    self?.delegate?.didTapUpdateButton()
                },
                isButtonHidden: false
            )
        case .default, .error, .waiting:
            return nil
        }
    }
}
