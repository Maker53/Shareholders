//  Created by Roman Turov on 19/04/2019.

import ABUIComponents

final class OfficeChangingPickerDataSource: ScrollablePickerViewControllerDataSource {
    typealias SelectionHandler = (Int) -> Void

    private let viewModels: [OfficeChangingCellViewModel]
    private let selectionHandler: SelectionHandler

    init(viewModels: [OfficeChangingCellViewModel], selectionHandler: @escaping SelectionHandler) {
        self.viewModels = viewModels
        self.selectionHandler = selectionHandler
    }

    func scrollablePickerItemsCount(_: ScrollablePickerViewController) -> Int {
        viewModels.count
    }

    func scrollablePicker(
        _: ScrollablePickerViewController,
        tableView: UITableView,
        cellForItemAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard
            let viewModel = viewModels[safe: indexPath.row],
            let cell = tableView.dequeueReusableCellWithAutoregistration(
                ActionCell.self
            )
        else { return UITableViewCell() }
        cell.cellView.titleLabel.numberOfLines = 0
        cell.configure(with: viewModel)
        return cell
    }

    func scrollablePicker(_: ScrollablePickerViewController, didSelectItemAt indexPath: IndexPath) {
        selectionHandler(indexPath.row)
    }
}
