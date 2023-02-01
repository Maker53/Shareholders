//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import ABUIComponents
import SnapKit

protocol CancelInstallmentViewDelegate: AnyObject {
    func nextButtonAction()
    func textFieldDidEndEditing(_ text: String?)
    func selectDocument()
}

protocol DisplaysCancelInstallmentView: DisplaysDefaultContentState {
    func configure(_ viewModel: CancelInstallment.PresentModuleData.ViewModel)
    func updateBottomOffset(with offset: CGFloat, willShow: Bool)

    var delegate: CancelInstallmentViewDelegate? { get set }
}

final class CancelInstallmentView: UIView {
    // MARK: - Properties

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = tableManager
        tableView.dataSource = tableManager
        tableView.backgroundColor = appearance.palette.backgroundPrimary
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = nextButton.intrinsicContentSize.height + appearance.bottomContentInset
        return tableView
    }()

    private lazy var nextButton: PrimaryMainButton = {
        let button = PrimaryMainButton()
        button.setTitle(L10n.CancelInstallment.buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
        return button
    }()

    private let buttonContainer = UIView(backgroundColor: .clear)

    weak var delegate: CancelInstallmentViewDelegate?

    private let appearance = Appearance()
    private let tableManager: ManagesCancelInstallmentTable = CancelInstallmentTableManager()

    // MARK: - Lifecycle

    required init() {
        super.init(frame: .zero)

        tableManager.delegate = self
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    @objc
    private func nextButtonAction() {
        delegate?.nextButtonAction()
    }
}

// MARK: - DisplaysContentStateTrait

extension CancelInstallmentView: DisplaysContentStateTrait {
    func styleForWaitingView() -> WaitingView.Style { .light }
}

// MARK: - DisplaysCancelInstallmentView

extension CancelInstallmentView: DisplaysCancelInstallmentView {
    func configure(_ viewModel: CancelInstallment.PresentModuleData.ViewModel) {
        setupHeader(viewModel.titleViewModel)
        tableManager.sections = viewModel.sections
        tableView.reloadData()
    }

    func updateBottomOffset(with offset: CGFloat, willShow: Bool) {
        let bottomInset = willShow
            ? offset + appearance.xsSpace
            : nextButton.intrinsicContentSize.height + appearance.bottomContentInset
        tableView.contentInset.bottom = bottomInset
    }
}

// MARK: - Private

private extension CancelInstallmentView {
    struct Appearance: Grid, Theme {
        let headerHeight: CGFloat = 101
        var bottomContentInset: CGFloat { xxlSpace }
    }

    func addSubviews() {
        add(subviews: [tableView, buttonContainer])
        buttonContainer.addSubview(nextButton)
    }

    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        buttonContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }

        nextButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(appearance.horizontalMargin)
            $0.top.bottom.equalToSuperview().inset(appearance.sSpace)
        }
    }

    func setupHeader(_ viewModel: TextView.ViewModel) {
        let view = TextView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: frame.size.width,
                height: appearance.headerHeight
            )
        )
        view.configure(with: viewModel)
        tableView.tableHeaderView = view
    }
}

// MARK: - CancelInstallmentTableManagerDelegate

extension CancelInstallmentView: CancelInstallmentTableManagerDelegate {
    func didSelectDocument() {
        delegate?.selectDocument()
    }

    func textFieldDidEndEditing(_ text: String?) {
        delegate?.textFieldDidEndEditing(text)
    }
}
