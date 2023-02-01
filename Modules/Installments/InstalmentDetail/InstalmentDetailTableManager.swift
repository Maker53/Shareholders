//  Created by Lyudmila Danilchenko on 11.09.2020.

import ABUIComponents

protocol InstalmentDetailTableManagerDelegate: AnyObject {
    func didTapRepaymentInfo()
    func didTapCancelBanner()
}

protocol ManagesInstalmentDetailTable: UITableViewDataSource, UITableViewDelegate {
    var delegate: InstalmentDetailTableManagerDelegate? { get set }
    var sections: [DetailInfoSection] { get set }
}

final class InstalmentDetailTableManager: NSObject, ManagesInstalmentDetailTable {
    typealias RightIconCell = GenericTableCell<
        OldRightIconWrapper<
            OldDataView<IconViewStyle.NoIcon, DataContentStyle.Default>,
            InstalmentDetailPopUpViewModel,
            RightIconWrapperStyle.Default,
            IconViewStyle.Icon
        >
    >

    weak var delegate: InstalmentDetailTableManagerDelegate?
    var sections: [DetailInfoSection] = []
    private let appearance = Appearance()
    struct Appearance: Grid, Theme { }

    override init() {
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(cancelButtonAction),
            name: InstalmentDetail.cancelNotificationName,
            object: nil
        )
    }

    @objc
    private func cancelButtonAction() {
        delegate?.didTapCancelBanner()
    }

    func numberOfSections(in _: UITableView) -> Int {
        sections.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[safe: section]?.cells.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = sections[safe: indexPath.section]?.cells[safe: indexPath.row]
        else { return .init() }

        switch row {
        case let .amountProgress(viewModel):
            let cell = tableView.makeGenericConfiguratedCell(
                cellView: AmountProgressView.self,
                viewModel: viewModel
            )
            cell?.selectionStyle = .none
            return cell ?? .init()

        case let .dataViews(viewModel):
            let cell = tableView.makeGenericConfiguratedCell(
                cellView: OldDataView<IconViewStyle.NoIcon, DataContentStyle.Revert>.self,
                viewModel: viewModel
            )
            cell?.selectionStyle = .none
            return cell ?? .init()

        case let .cards(viewModel):
            let cell = tableView.makeGenericConfiguratedCell(
                cellView: CardView<CardViewStyle.RightMeduimExtended, CardIconViewStyle.Small, CardContentStyle.Revert>.self,
                viewModel: (icon: viewModel, content: viewModel)
            )
            return cell ?? .init()

        case let .cancelBanner(viewModel):
            let cell = tableView.makeGenericConfiguratedCell(cellView: BannerWrapper.self, viewModel: viewModel)
            cell?.cellView.setContent(ofType: CancelView.self)
            cell?.selectionStyle = .none
            return cell ?? .init()

        case .separator:
            let cell = tableView.makeGenericConfiguratedCellWithInsets(
                cellView: SeparatorView.self,
                viewModel: (),
                insets: UIEdgeInsets(
                    top: appearance.mSpace,
                    left: appearance.horizontalMargin,
                    bottom: appearance.mSpace,
                    right: appearance.horizontalMargin
                )
            )

            cell?.selectionStyle = .none
            return cell ?? .init()

        case let .banner(viewModel):
            let cell = tableView.makeConfiguratedCell(
                cellType: BannerTextViewCell<BannerTextViewStyle.Warning>.self,
                viewModel: viewModel
            )
            cell?.selectionStyle = .none
            return cell ?? .init()

        case let .rightIconDataView(viewModel):
            let cell = tableView.makeConfiguratedCell(
                cellType: RightIconCell.self,
                viewModel: viewModel
            )
            return cell ?? .init()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let row = sections[safe: indexPath.section]?.cells[safe: indexPath.row] else {
            return
        }

        switch row {
        case .rightIconDataView:
            delegate?.didTapRepaymentInfo()
        default:
            break
        }
    }
}
