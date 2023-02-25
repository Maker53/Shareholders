// Created by Станислав on 10.02.2023.

import AlfaFoundation
import ABUIComponents

protocol ShareholderListTableManagerDelegate: AnyObject {
    func didSelectShareholder(_ uid: UniqueIdentifier)
}

protocol ShareholderListTableManagerProtocol: UITableViewDataSource, UITableViewDelegate {
    var rows: [ShareholderCellViewModel] { get set }
}

final class ShareholderListTableManager: NSObject, ShareholderListTableManagerProtocol {
    // MARK: - Properties
    
    var rows: [ShareholderCellViewModel] = []
    weak var delegate: ShareholderListTableManagerDelegate?
    
    // MARK: - Initializer
    
    required init(delegate: ShareholderListTableManagerDelegate?) {
        self.delegate = delegate
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else { return 0 }
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let viewModel = rows[safe: indexPath.row],
            let cell = tableView.makeConfiguratedCell(
                cellType: ContactCell.self,
                viewModel: viewModel
            ) else {
            return .init()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let row = rows[safe: indexPath.row] else { return }
        delegate?.didSelectShareholder(row.uid)
    }
}
