///  Created by Roman Turov on 16/04/2019.

import ABUIComponents

protocol OfficeChangingTableDelegate: AnyObject {
    func didSelectRow(_ row: OfficeChangingRowType)
}

class OfficeChangingTableManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    var viewModels: [OfficeChangingViewModel] = []
    weak var delegate: OfficeChangingTableDelegate?
    init(delegate: OfficeChangingTableDelegate? = nil) {
        self.delegate = delegate
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let viewModel = viewModels[safe: indexPath.row],
            let cell = tableView.dequeueReusableCellWithAutoregistration(PickerCell.self)
        else { return UITableViewCell() }
        cell.configure(with: viewModel.pickerViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModels[safe: indexPath.row] else { return }
        delegate?.didSelectRow(viewModel.row)
    }
}
