//
//  SUT: OfficeChangingPresenter
//
//  Collaborators:
//  OfficeChangingViewController

import ABUIComponents
import AlfaFoundation
import TestAdditions

@testable import CardReissue

final class OfficeChangingPresenterTests: QuickSpec {
    override func spec() {
        var presenter: OfficeChangingPresenter!
        var viewControllerMock: OfficeChangingViewControllerMock!

        beforeEach {
            presenter = OfficeChangingPresenter()
            viewControllerMock = OfficeChangingViewControllerMock()
            presenter.viewController = viewControllerMock
        }

        describe(".presentCells") {
            context("placeholders") {
                it("should return city cell") {
                    // when
                    presenter.present(.init(items: [TestData.emptyCityItem], isConfirmationAvailable: false))
                    // then
                    expect(viewControllerMock.displayCellsArguments?.pickerViewModels)
                        .to(equal([TestData.emptyCityCell]))
                }

                it("should return metro cell") {
                    // when
                    presenter.present(.init(items: [TestData.emptyMetroItem], isConfirmationAvailable: false))
                    // then
                    expect(viewControllerMock.displayCellsArguments?.pickerViewModels)
                        .to(equal([TestData.emptyMetroCell]))
                }

                it("should return city cell") {
                    // when
                    presenter.present(.init(items: [TestData.emptyOfficeItem], isConfirmationAvailable: false))
                    // then
                    expect(viewControllerMock.displayCellsArguments?.pickerViewModels)
                        .to(equal([TestData.emptyOfficeCell]))
                }
            }

            context("when response includes model") {
                it("should return city cell") {
                    // when
                    presenter.present(.init(items: [TestData.cityItem], isConfirmationAvailable: false))
                    // then
                    expect(viewControllerMock.displayCellsArguments?.pickerViewModels)
                        .to(equal([TestData.cityCell]))
                }

                it("should return metro cell") {
                    // when
                    presenter.present(.init(items: [TestData.metroItem], isConfirmationAvailable: false))
                    // then
                    expect(viewControllerMock.displayCellsArguments?.pickerViewModels)
                        .to(equal([TestData.metroCell]))
                }

                it("should return city cell") {
                    // when
                    presenter.present(.init(items: [TestData.officeItem], isConfirmationAvailable: false))
                    // then
                    expect(viewControllerMock.displayCellsArguments?.pickerViewModels)
                        .to(equal([TestData.officeCell]))
                }
            }

            context("when response includes few models") {
                it("should return city, metro, empty office cell") {
                    // when
                    presenter.present(.init(
                        items: [TestData.cityItem, TestData.metroItem, TestData.emptyOfficeItem],
                        isConfirmationAvailable: true
                    ))
                    // then
                    expect(viewControllerMock.displayCellsArguments?.pickerViewModels)
                        .to(equal([TestData.cityCell, TestData.metroCell, TestData.emptyOfficeCell]))
                    expect(viewControllerMock.displayCellsArguments?.isConfirmationButtonActive)
                        .to(beTrue())
                }
            }
        }

        describe(".displayError") {
            it("should prepare error to present") {
                // when
                presenter.presentError(.emptyState)
                // then
                expect(viewControllerMock.displayErrorWasCalled).to(beCalledOnce())
                expect(viewControllerMock.displayErrorArgument).to(equal(OfficeChanging.ErrorType.emptyState))
            }
        }

        describe(".presentCitiesList") {
            it("should call viewController") {
                // when
                presenter.presentCitiesList(.init(itemsList: TestData.cities, selectedItemIndex: nil))
                // then
                expect(viewControllerMock.displayItemsListWasCalled).to(beCalledOnce())
            }

            it("should return viewModels") {
                // when
                presenter.presentCitiesList(.init(itemsList: TestData.cities, selectedItemIndex: nil))
                // then
                expect(viewControllerMock.displayItemsListArguments.viewModels).to(equal(TestData.citiesViewModels))
                expect(viewControllerMock.displayItemsListArguments.type).to(equal(.city))
                expect(viewControllerMock.displayItemsListArguments.index).to(beNil())
            }

            it("should return selected item index") {
                // when
                presenter.presentCitiesList(.init(itemsList: TestData.cities, selectedItemIndex: 0))
                // then
                expect(viewControllerMock.displayItemsListArguments.index).to(equal(0))
            }
        }

        describe(".presentMetroList") {
            it("should call viewController") {
                // when
                presenter.presentMetroList(.init(itemsList: TestData.metroList, selectedItemIndex: nil))
                // then
                expect(viewControllerMock.displayItemsListWasCalled).to(beCalledOnce())
            }

            it("should return viewModels") {
                // when
                presenter.presentMetroList(.init(itemsList: TestData.metroList, selectedItemIndex: nil))
                // then
                expect(viewControllerMock.displayItemsListArguments.viewModels).to(equal(TestData.metroViewModels))
                expect(viewControllerMock.displayItemsListArguments.type).to(equal(.metro))
                expect(viewControllerMock.displayItemsListArguments.index).to(beNil())
            }

            it("should return selected item index") {
                // when
                presenter.presentMetroList(.init(itemsList: TestData.metroList, selectedItemIndex: 0))
                // then
                expect(viewControllerMock.displayItemsListArguments.index).to(equal(0))
            }
        }

        describe(".presentOfficesList") {
            it("should call viewController") {
                // when
                presenter.presentOfficesList(.init(itemsList: TestData.officesList, selectedItemIndex: nil))
                // then
                expect(viewControllerMock.displayItemsListWasCalled).to(beCalledOnce())
            }

            it("should return viewModels") {
                // when
                presenter.presentOfficesList(.init(itemsList: TestData.officesList, selectedItemIndex: nil))
                // then
                expect(viewControllerMock.displayItemsListArguments.viewModels).to(equal(TestData.officesViewModels))
                expect(viewControllerMock.displayItemsListArguments.type).to(equal(.office))
                expect(viewControllerMock.displayItemsListArguments.index).to(beNil())
            }

            it("should return selected item index") {
                // when
                presenter.presentOfficesList(.init(itemsList: TestData.officesList, selectedItemIndex: 0))
                // then
                expect(viewControllerMock.displayItemsListArguments.index).to(equal(0))
            }
        }

        describe(".presentUpdatedReissuesOffice") {
            it("should call viewController") {
                // when
                presenter.presentUpdatedReissuesOffice()
                // then
                expect(viewControllerMock.displayUpdatedReissuesOfficeWasCalled).to(beCalledOnce())
            }
        }
    }
}

// swiftlint:disable non_localized_cyrillic_strings

private extension OfficeChangingPresenterTests {
    enum TestData {
        static let city = City.Seeds.defaultModel
        static let metro = Metro.Seeds.defaultModel
        static let office = Office.Seeds.defaultModel
        static let configuration = OfficeChangingPresenter.Configuration()
        static let emptyCityCell = OfficeChangingViewModel(
            pickerViewModel: PickerCellViewModel(title: configuration.cityCellPlaceholder as String, value: nil),
            row: .city
        )
        static let emptyMetroCell = OfficeChangingViewModel(
            pickerViewModel: PickerCellViewModel(title: configuration.metroCellPlaceholder as String, value: nil),
            row: .metro
        )
        static let emptyOfficeCell = OfficeChangingViewModel(
            pickerViewModel: PickerCellViewModel(title: configuration.officeCellPlaceholder as String, value: nil),
            row: .office
        )
        static let cityCell = OfficeChangingViewModel(
            pickerViewModel: PickerCellViewModel(title: configuration.cityCellTitle as String, value: city.name),
            row: .city
        )
        static let metroCell = OfficeChangingViewModel(
            pickerViewModel: PickerCellViewModel(title: configuration.metroCellTitle as String, value: metro.name),
            row: .metro
        )
        static let officeCell = OfficeChangingViewModel(
            pickerViewModel: PickerCellViewModel(title: configuration.officeCellTitle as String, value: office.address),
            row: .office
        )

        static let emptyCityItem: OfficeChanging.PresentedCellType = .city(nil)
        static let cityItem: OfficeChanging.PresentedCellType = .city(city)
        static let emptyMetroItem: OfficeChanging.PresentedCellType = .metro(nil)
        static let metroItem: OfficeChanging.PresentedCellType = .metro(metro)
        static let emptyOfficeItem: OfficeChanging.PresentedCellType = .office(nil)
        static let officeItem: OfficeChanging.PresentedCellType = .office(office)

        static let cities = [city, city, city]
        static let citiesViewModel = OfficeChangingCellViewModel(title: city.name)
        static let citiesViewModels = [citiesViewModel, citiesViewModel, citiesViewModel]
        static let metroList = [metro, metro, metro]
        static let metroViewModel = OfficeChangingCellViewModel(title: metro.name)
        static let metroViewModels = [metroViewModel, metroViewModel, metroViewModel]
        static let htmlOffice = Office(
            uid: "10",
            name: "Владимирский централ",
            address: "ул.&nbsp;Кузнецкий Мост д.&nbsp;9/10 либо ул.&nbsp;Неглинная, д.&nbsp;10",
            number: "2222"
        )
        static let convertedAddress = "ул.\u{00A0}Кузнецкий Мост д.\u{00A0}9/10 либо ул.\u{00A0}Неглинная, д.\u{00A0}10"
        static let officesList = [office, office, htmlOffice]
        static let officeViewModel = OfficeChangingCellViewModel(title: office.address, subtitle: office.name)
        static let officeHTMLViewModel = OfficeChangingCellViewModel(title: convertedAddress, subtitle: htmlOffice.name)
        static let officesViewModels = [officeViewModel, officeViewModel, officeHTMLViewModel]
    }
}

private class OfficeChangingViewControllerMock: OfficeChangingDisplayLogic {
    var displayItemsListWasCalled = 0
    var displayItemsListArguments: (
        viewModels: [OfficeChangingCellViewModel],
        index: Int?,
        type: OfficeChangingRowType
    ) = ([], nil, .city)
    func displayItemsList(_ viewModel: OfficeChanging.OpenItemsList.ViewModel) {
        displayItemsListWasCalled += 1
        displayItemsListArguments = (
            viewModels: viewModel.cells,
            index: viewModel.selectedItemIndex,
            type: viewModel.presentedCellType
        )
    }

    var displayCellsWasCalled = 0
    var displayCellsArguments: OfficeChanging.PresentCells.ViewModel?
    var displayErrorWasCalled = 0
    var displayErrorArgument: OfficeChanging.ErrorType?
    var displayUpdatedReissuesOfficeWasCalled = 0

    func display(_ viewModel: OfficeChanging.PresentCells.ViewModel) {
        displayCellsWasCalled += 1
        displayCellsArguments = viewModel
    }

    func displayError(_ error: OfficeChanging.ErrorType) {
        displayErrorWasCalled += 1
        displayErrorArgument = error
    }

    func displayUpdatedReissuesOffice() {
        displayUpdatedReissuesOfficeWasCalled += 1
    }
}
