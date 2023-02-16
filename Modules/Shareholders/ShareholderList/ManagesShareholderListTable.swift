// Created by Станислав on 10.02.2023.

import ABUIComponents

protocol ShareholderListTableManagerProtocol: UITableViewDataSource {
    var shareholders: [Shareholder] { get set }
}

final class ShareholderListTableManager: NSObject, ShareholderListTableManagerProtocol {
    var shareholders: [Shareholder] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        return shareholders.count
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
    func getViewModel(by index: Int) -> ShareholderListViewModel? {
        guard let shareholder = shareholders[safe: index] else { return nil }
        let viewModel = ShareholderListViewModel(
            name: shareholder.name,
            phone: shareholder.company.rawValue,
            imageSource: .image(.assets.art_logoAlfa_color)
        )
        
        return viewModel
    }
}
