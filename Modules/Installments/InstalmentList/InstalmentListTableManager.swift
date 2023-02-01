//  Created by Lyudmila Danilchenko on 11.09.2020.

import ABUIComponents

protocol InstalmentListTableManagerDelegate: AnyObject {
    func didSelectInstalment(_ instalment: Instalment, type: InstallmentType)
}

protocol ManagesInstalmentListTable: UITableViewDataSource, UITableViewDelegate {
    var sections: [InstallmentListSection] { get set }
    var delegate: InstalmentListTableManagerDelegate? { get set }
}

final class InstalmentListTableManager: NSObject, ManagesInstalmentListTable {
    var sections: [InstallmentListSection] = []
    weak var delegate: InstalmentListTableManagerDelegate?

    func numberOfSections(in _: UITableView) -> Int {
        sections.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[safe: section]?.cells.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = sections[safe: indexPath.section]?.cells[safe: indexPath.row] else {
            return UITableViewCell()
        }

        switch row {
        case let .debitInstallment(viewModel), let .installment(viewModel):
            return tableView.makeConfiguratedCell(cellType: InstalmentListCell.self, viewModel: viewModel) ?? .init()
        case let .amount(viewModel):
            return tableView.makeGenericConfiguratedCell(
                cellView: OldDataView<IconViewStyle.NoIcon, DataContentStyle.Revert>.self,
                viewModel: viewModel
            ) ?? .init()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let row = sections[safe: indexPath.section]?.cells[safe: indexPath.row] else { return }

        switch row {
        case let .installment(viewModel):
            delegate?.didSelectInstalment(viewModel.instalment, type: .credit)
        case let .debitInstallment(viewModel):
            delegate?.didSelectInstalment(viewModel.instalment, type: .debit)
        case .amount:
            return
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = sections[safe: section],
              let title = section.title
        else {
            return .init()
        }

        let view = tableView.dequeueReusableHeaderFooterViewWithAutoregistration(
            TableSectionHeaderView<HeaderViewStyle.Heading4>.self
        )

        let headerViewModel = DefaultHeaderViewViewModel(title: title)
        view?.configure(with: headerViewModel)
        return view
    }
}
