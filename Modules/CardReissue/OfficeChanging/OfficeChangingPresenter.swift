///  Created by Roman Turov on 16/04/2019.

import ABUIComponents
import AlfaFoundation

protocol OfficeChangingDisplayLogic: AnyObject {
    func display(_ viewModel: OfficeChanging.PresentCells.ViewModel)
    func displayItemsList(_ viewModel: OfficeChanging.OpenItemsList.ViewModel)
    func displayUpdatedReissuesOffice()
    func displayError(_ error: OfficeChanging.ErrorType)
}

class OfficeChangingPresenter: OfficeChangingPresentationLogic {
    let configuration = Configuration()
    weak var viewController: OfficeChangingDisplayLogic?

    func presentError(_ error: OfficeChanging.ErrorType) {
        viewController?.displayError(error)
    }

    func present(_ response: OfficeChanging.PresentCells.Response) {
        let viewModels = response.items.map { item -> OfficeChangingViewModel in
            switch item {
            case let .city(city):
                let placeholder = configuration.cityCellPlaceholder as String
                return OfficeChangingViewModel(
                    pickerViewModel: viewModel(title: configuration.cityCellTitle, placeholder: placeholder, value: city?.name),
                    row: .city
                )
            case let .metro(metro):
                let placeholder = configuration.metroCellPlaceholder
                return OfficeChangingViewModel(
                    pickerViewModel: viewModel(title: configuration.metroCellTitle, placeholder: placeholder, value: metro?.name),
                    row: .metro
                )
            case let .office(office):
                let placeholder = configuration.officeCellPlaceholder
                let value = office.map { convertedHTMLString($0.address) }
                return OfficeChangingViewModel(
                    pickerViewModel: viewModel(title: configuration.officeCellTitle, placeholder: placeholder, value: value),
                    row: .office
                )
            }
        }
        viewController?.display(OfficeChanging.PresentCells.ViewModel(
            pickerViewModels: viewModels,
            isConfirmationButtonActive: response.isConfirmationAvailable
        ))
    }

    func presentCitiesList(_ response: OfficeChanging.OpenCitiesList.Response) {
        viewController?.displayItemsList(.init(
            cells: response.itemsList.map { OfficeChangingCellViewModel(title: $0.name) },
            presentedCellType: .city,
            selectedItemIndex: response.selectedItemIndex
        ))
    }

    func presentMetroList(_ response: OfficeChanging.OpenMetroList.Response) {
        viewController?.displayItemsList(.init(
            cells: response.itemsList.map { OfficeChangingCellViewModel(title: $0.name) },
            presentedCellType: .metro,
            selectedItemIndex: response.selectedItemIndex
        ))
    }

    func presentOfficesList(_ response: OfficeChanging.OpenOfficesList.Response) {
        viewController?.displayItemsList(.init(
            cells: response.itemsList.map {
                OfficeChangingCellViewModel(title: convertedHTMLString($0.address), subtitle: convertedHTMLString($0.name))
            },
            presentedCellType: .office,
            selectedItemIndex: response.selectedItemIndex
        ))
    }

    func presentUpdatedReissuesOffice() {
        viewController?.displayUpdatedReissuesOffice()
    }

    private func convertedHTMLString(_ string: String) -> String {
        let convertedString = NSMutableAttributedString.attributedStringFromHTML(
            htmlString: string,
            font: UIFont.systemFontOfSize17,
            textColor: UIColor.darkIndigo
        )?.string
        return convertedString.map { $0.isEmpty ? string : $0 } ?? string
    }

    private func viewModel(title: String, placeholder: String, value: String?) -> PickerCellViewModel {
        let title = value != nil ? title : placeholder
        return PickerCellViewModel(title: title, value: value)
    }
}

extension OfficeChangingPresenter {
    struct Configuration {
        let cityCellPlaceholder = "CardReissue.OfficeChanging.CityCellPlaceholder".localized() as String
        let metroCellPlaceholder = "CardReissue.OfficeChanging.MetroCellPlaceholder".localized() as String
        let officeCellPlaceholder = "CardReissue.OfficeChanging.OfficeCellPlaceholder".localized() as String
        let cityCellTitle = "CardReissue.OfficeChanging.CityCellTitle".localized() as String
        let metroCellTitle = "CardReissue.OfficeChanging.MetroCellTitle".localized() as String
        let officeCellTitle = "CardReissue.OfficeChanging.OfficeCellTitle".localized() as String
    }
}
