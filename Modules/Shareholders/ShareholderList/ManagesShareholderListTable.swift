// Created by Станислав on 10.02.2023.

import ABUIComponents

protocol ShareholderListTableManagerProtocol: UITableViewDataSource {
    var rows: [ShareholderListCellViewModel] { get set }
}

final class ShareholderListTableManager: NSObject, ShareholderListTableManagerProtocol {
    var rows: [ShareholderListCellViewModel] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let viewModel = getViewModel(by: indexPath.row),
            let cell = tableView.makeConfiguratedCell(
                cellType: ContactCell.self,
                viewModel: viewModel
            ) else {
            return .init()
        }
        
        return cell
    }
}

// MARK: - Private

private extension ShareholderListTableManager {
    func getViewModel(by index: Int) -> ShareholderListCellViewModel? {
        guard let viewModel = rows[safe: index] else { return nil }
        return viewModel
    }
}
