//  Created by Lyudmila Danilchenko on 17/08/2020.

import ABUIComponents
import Resources
import SharedProtocolsAndModels
import SharedRouter
import TestAdditions

@testable import Installments

final class InstalmentListViewControllerTests: QuickSpec {
    override func spec() {
        var viewController: InstalmentListViewController<InstalmentListRoutesMock>!
        var analyticsMock: InstalmentListEventsMock!
        var contentViewMock: DisplaysInstalmentListViewMock!
        var interactorMock: InstalmentListBusinessLogicMock!
        var routesMock: InstalmentListRoutesMock.Type!
        var tableManagerMock: ManagesInstalmentListTableMock!
        var stateView: InstalmentStateView!
        var contentView: InstalmentListView!

        beforeEach {
            analyticsMock = InstalmentListEventsMock()
            contentViewMock = DisplaysInstalmentListViewMock()
            interactorMock = InstalmentListBusinessLogicMock()
            routesMock = InstalmentListRoutesMock.self
            tableManagerMock = .init()
            viewController = InstalmentListViewController(
                analytics: analyticsMock,
                interactor: interactorMock,
                tableManager: tableManagerMock
            )
            contentView = InstalmentListView(delegate: viewController)
            stateView = InstalmentStateView()
            contentView.stateView = stateView
            contentViewMock.stateView = stateView
            viewController.contentView = contentView
        }

        afterEach {
            routesMock.backWasCalled = 0
            routesMock.dismissWasCalled = 0
        }

        describe(".loadView") {
            it("should setup views") {
                // when
                viewController.contentView = contentViewMock
                viewController.loadView()
                // then
                expect(viewController.view).to(beIdenticalTo(contentViewMock))
            }
        }

        describe(".viewDidLoad") {
            it("should setup module") {
                // when
                viewController.loadViewIfNeeded()
                // then
                expect(stateView).to(beWaitingState())
                expect(viewController.edgesForExtendedLayout).to(equal([.bottom]))
                expect(viewController.navigationItem.leftBarButtonItem?.accessibilityLabel)
                    .to(equal(TestData.expectedBackLabel))
            }

            it("should ask interactor to fetch data") {
                // when
                viewController.loadViewIfNeeded()
                // then
                expect(interactorMock.loadDataWasCalled)
                    .to(beCalledOnce())
                expect(
                    interactorMock.loadDataReceivedRequest
                ).to(equal(TestData.loadDataRequest))
                expect(stateView).to(beWaitingState())
            }
        }

        describe(".pullToRefreshAction") {
            it("should call interactor.loadData with proper argument") {
                // when
                viewController.pullToRefreshAction()

                // then
                expect(interactorMock.loadDataWasCalled)
                    .to(beCalledOnce())
                expect(
                    interactorMock.loadDataReceivedRequest
                ).to(equal(TestData.loadDataRefreshRequest))
            }
        }

        describe(".displayInstalments") {
            it("should be default state") {
                // when
                viewController.displayInstalments(TestData.viewModel)
                // then
                expect(stateView).to(beDefaultState())
                expect(tableManagerMock.sections).to(equal(TestData.viewModel.sections))
                expect(analyticsMock.trackScreenWasCalled).to(beCalledOnce())
            }
        }

        describe(".displayError") {
            it("should be empty state with error") {
                // when
                viewController.displayError(TestData.error)
                // then
                expect(stateView).to(beEmptyState())
                expect(analyticsMock.trackErrorWasCalled).to(beCalledOnce())
                expect(analyticsMock.trackErrorReceivedText).to(equal(TestData.error.description))
            }
        }

        describe(".displayPlusButton") {
            context("when isHidden is true") {
                it("should remove button") {
                    // when
                    viewController.displayPlusButton(.init(shouldPresentButton: false))

                    // then
                    expect(viewController.navigationItem.rightBarButtonItem).to(beNil())
                }
            }
        }

        describe(".displayEmptyView") {
            it("should be empty state") {
                // when
                viewController.contentView = contentViewMock
                viewController.displayEmptyView(.init(emptyViewViewModel: TestData.stateViewModel))

                var emptyViewModel: DefaultEmptyViewRepresentable?
                if case let .empty(viewModel) = contentViewMock.showStateReceivedState {
                    emptyViewModel = viewModel
                }

                expect(emptyViewModel).toNot(beNil())
                expect(emptyViewModel?.firstButtonViewModel?.buttonHandler).toNot(beNil())
            }
        }

        describe(".plusTapped") {
            it("should ask interactor open new instalment") {
                // when
                viewController.plusTapped()
                // then
                expect(interactorMock.openNewInstalmentWasCalled).to(beCalledOnce())
            }
        }

        describe(".backButtonPressed") {
            it("should dismiss") {
                // when
                viewController.backButtonPressed()
                // then
                expect(routesMock.backWasCalled).to(beCalledOnce())
            }
        }

        describe(".configureNavigationBar") {
            it("should create cancel button with dismiss action") {
                // when
                viewController.configureNavigationBar()
                let barButton = viewController.navigationItem.leftBarButtonItem!
                barButton.sendActionsInTests()
                // then
                expect(routesMock.backWasCalled).to(beCalledOnce())
            }
        }

        describe(".newInstalmentButtonPressed") {
            it("should") {
                // when
                viewController.newInstalmentButtonPressed()

                // then
                expect(interactorMock.openNewInstalmentWasCalled).to(beCalledOnce())
            }
        }

        describe(".didSelectInstalment") {
            it("should call route") {
                // given
                let expectedRequest = InstalmentList.PresentInstallmentDetails.Request(
                    installment: TestData.instalment,
                    installmentType: .credit
                )
                // when
                viewController.didSelectInstalment(TestData.instalment, type: .credit)
                // then
                expect(interactorMock.openInstallmentDetailsWasCalled).to(beCalledOnce())
                expect(interactorMock.openInstallmentDetailsReceivedRequest).to(equal(expectedRequest))
            }
        }

        describe(".displayNewInstallmentSelection") {
            it("should call route") {
                // when
                viewController.displayNewInstallmentSelection(TestData.selectionViewModel)
                // then
                expect(routesMock.alertTextActionsStyleWasCalled).to(beCalledOnce())
                expect(routesMock.alertTextActionsStyleReceivedArguments?.text).to(equal(TestData.alertText))
                expect(routesMock.alertTextActionsStyleReceivedArguments?.actions).to(equal(TestData.alertActions))
            }
        }

        describe(".displayInstallmentDetails") {
            it("should call route") {
                // given
                let model = InstallmentDetailsContext.full(InstallmentDetailsModel(
                    installment: Instalment.Seeds.value,
                    installmentType: .credit,
                    isSeveralInstallments: false
                ))
                // when
                viewController.displayInstallmentDetails(model)
                // then
                expect(routesMock.instalmentDetailsWithWasCalled).to(beCalledOnce())
                expect(routesMock.instalmentDetailsWithReceivedContext).to(equal(model))
            }
        }

        describe(".dismiss") {
            it("should call routes") {
                // when
                viewController.dismiss()
                // then
                expect(routesMock.backWasCalled).to(beCalledOnce())
            }
        }
    }
}

// swiftlint:disable non_localized_cyrillic_strings
private extension InstalmentListViewControllerTests {
    enum TestData {
        static let expectedBackLabel = "Назад"
        static let loadDataRequest = InstalmentList.PresentModuleData.Request(shouldRefreshInstalments: false)
        static let loadDataRefreshRequest = InstalmentList.PresentModuleData.Request(shouldRefreshInstalments: true)
        static let viewModel = InstalmentList.PresentModuleData.ViewModel(sections: [InstallmentListSection.Seeds.value])
        static let emptyViewModel = DefaultEmptyViewModel(icon: .init(), title: "title", subtitle: "subtitle")
        static let error = InstalmentList.LoadingError.ViewModel(model: emptyViewModel, description: emptyViewModel.subtitle)
        static let newCreditInstalmentViewModel = InstalmentList.PresentNewInstalmentData.ViewModel(
            offers: .init(instalmentOffers: [InstalmentOffer.Seeds.value], shouldShowLanding: false),
            installmentType: .credit
        )
        static let buttonViewModel = EmptyViewButtonViewModel(title: L10n.InstalmentList.EmptyState.newInstalmentButtonTitle)
        static let stateViewModel = DefaultEmptyViewModel(
            icon: .init(icon: .image(UIImage.assets.glyph_creditCard_m.withRenderingMode(.alwaysTemplate))),
            title: L10n.InstalmentList.EmptyState.Titles.withAnyOffer,
            subtitle: L10n.InstalmentList.EmptyState.Subtitles.onlyCreditOffer,
            firstButtonViewModel: buttonViewModel
        )
        static let instalment = Instalment.Seeds.value
        static let selectionAction = UIAlertAction(title: "Title", style: .default, handler: nil)
        static let selectionViewModel = InstalmentList.PresentNewInstalmentSelection.ViewModel(
            actions: alertActions
        )
        static let alertActions = [selectionAction]
        static let alertText = UIAlertText.standard(title: nil, message: nil)
    }
}
