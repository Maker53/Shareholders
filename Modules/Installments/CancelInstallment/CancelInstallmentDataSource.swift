import ABUIComponents
import UIKit

protocol ManagesCancelInstallmentTable: UITableViewDataSource, UITableViewDelegate {
    var sections: [CancelInstallmentSection] { get set }
    var delegate: CancelInstallmentTableManagerDelegate? { get set }
}

protocol CancelInstallmentTableManagerDelegate: AnyObject {
    func textFieldDidEndEditing(_ text: String?)
    func didSelectDocument()
}

final class CancelInstallmentTableManager: NSObject, ManagesCancelInstallmentTable {
    typealias TextCellView = TextView
    typealias ComissionRefundView = OldDataView<IconViewStyle.SmallIcon, DataContentStyle.Default>
    typealias RedTextView = OldDataView<IconViewStyle.SmallIcon, DataContentStyle.Default.Multiline>
    typealias HeaderViewCustom = TableHeaderFooterTextView<TextViewStyle.Custom.Left<LabelStyle.HeadlineXSmall>>

    var sections: [CancelInstallmentSection] = []
    weak var delegate: CancelInstallmentTableManagerDelegate?

    private var appearance = Appearance(); struct Appearance: Grid, Theme {
        var heightForHeaderInSection: CGFloat { xxxsSpace * 13 }
        var docsHeaderInsets: UIEdgeInsets {
            UIEdgeInsets(top: mSpace, left: horizontalMargin, bottom: xxxsSpace, right: horizontalMargin)
        }
    }
}

// MARK: - UITableViewDataSource

extension CancelInstallmentTableManager: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        sections.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[safe: section]?.rows.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = sections[safe: indexPath.section]?.rows[safe: indexPath.row] else {
            return .init()
        }

        let cell: UITableViewCell?
        switch row {
        case let .comissionRefund(viewModel):
            cell = tableView.makeGenericConfiguratedCell(
                cellView: ComissionRefundView.self,
                viewModel: viewModel
            )
            cell?.selectionStyle = .none

        case let .textView(viewModel):
            cell = tableView.makeGenericConfiguratedCell(
                cellView: TextCellView.self,
                viewModel: viewModel
            )
            cell?.selectionStyle = .none

        case let .redText(viewModel):
            cell = tableView.makeGenericConfiguratedCell(
                cellView: RedTextView.self,
                viewModel: viewModel
            )
            cell?.selectionStyle = .none

        case let .document(viewModel):
            cell = tableView.makeGenericConfiguratedCell(
                cellView: OldDataView<IconViewStyle.SmallIcon, DataContentStyle.Default>.self,
                viewModel: viewModel
            )
            cell?.selectionStyle = .none

        case let .input(viewModel):
            let cell = tableView.makeGenericConfiguratedCell(
                cellView: TextField.self,
                viewModel: viewModel
            )
            cell?.cellView.delegate = self
            cell?.selectionStyle = .none

            return cell ?? .init()
        }

        return cell ?? .init()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard
            let title = sections[safe: section]?.header,
            let headerView = tableView.dequeueReusableHeaderFooterViewWithAutoregistration(HeaderViewCustom.self)
        else { return nil }

        headerView.configure(
            with: TextViewCustomLeftViewModel(leftText: title, insets: appearance.docsHeaderInsets)
        )
        return headerView
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard sections[safe: section]?.header != nil else { return 0 }
        return appearance.heightForHeaderInSection
    }
}

// MARK: - UITableViewDelegate

extension CancelInstallmentTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let row = sections[safe: indexPath.section]?.rows[safe: indexPath.row] else {
            return
        }

        switch row {
        case .document:
            delegate?.didSelectDocument()
        default:
            break
        }
    }
}

// MARK: - TextFieldDelegate

extension CancelInstallmentTableManager: TextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField.text)
    }
}
