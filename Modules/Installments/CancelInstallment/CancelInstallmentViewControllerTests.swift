//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import ABUIComponents
import OperationConfirmation
import ResultScreen
import SharedProtocolsAndModels
import TestAdditions

@testable import Installments

final class CancelInstallmentViewControllerTests: QuickSpec {
    override func spec() {
        var viewController: CancelInstallmentViewController<CancelInstallmentRoutesMock>!
        var analyticsMock: CancelInstallmentEventsMock!
        var contentViewMock: DisplaysCancelInstallmentViewMock!
        var interactorMock: CancelInstallmentBusinessLogicMock!
        var routesMock: CancelInstallmentRoutesMock.Type!
        var trackerMock: KeyboardObservableMock!

        beforeEach {
            analyticsMock = CancelInstallmentEventsMock()
            contentViewMock = DisplaysCancelInstallmentViewMock()
            interactorMock = CancelInstallmentBusinessLogicMock()
            routesMock = CancelInstallmentRoutesMock.self
            trackerMock = .init()
            viewController = CancelInstallmentViewController(
                analytics: analyticsMock,
                interactor: interactorMock
            )
            viewController.keyboardTracker = trackerMock
            viewController.contentView = contentViewMock
        }

        afterEach {
            routesMock.reset()
        }

        describe(".init") {
            it("should init properly") {
                // when
                viewController = CancelInstallmentViewController(
                    analytics: analyticsMock,
                    interactor: interactorMock
                )
                let tracker = viewController.keyboardTracker as? KeyboardTracker
                // then
                expect(tracker?.delegate).to(beIdenticalTo(viewController))
                expect(tracker?.viewController).to(beIdenticalTo(viewController))
                expect(viewController.state).to(equal(.loading))
            }
        }

        describe(".viewWillAppear") {
            it("should start tracker") {
                // when
                viewController.viewWillAppear(true)
                // then
                expect(trackerMock.startTrackingWasCalled).to(beCalledOnce())
            }
        }

        describe(".viewWillDisappear") {
            it("should stop tracker") {
                // when
                viewController.viewWillDisappear(true)
                // then
                expect(trackerMock.stopTrackingWasCalled).to(beCalledOnce())
            }
        }

        describe(".loadView") {
            it("should setup views") {
                // when
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
                expect(analyticsMock.trackScreenWasCalled).to(beCalledOnce())
                expect(contentViewMock).to(beWaitingState())
                expect(viewController.edgesForExtendedLayout).to(equal([.bottom]))
                expect(interactorMock.loadDataWasCalled).to(beCalledOnce())
                expect(contentViewMock.delegate).to(beIdenticalTo(viewController))
            }

            it("should create cancel button with dismiss action") {
                // when
                viewController.loadViewIfNeeded()
                let barButton = viewController.navigationItem.leftBarButtonItem!
                (barButton.target as? NSObject)?.performSelector(
                    onMainThread: barButton.action!,
                    with: nil,
                    waitUntilDone: true
                )
                // then
                expect(routesMock.dismissWasCalled).to(beCalledOnce())
            }
        }

        describe(".displayData") {
            it("should configure view") {
                // when
                viewController.displayData(TestData.viewModel)
                // then
                expect(contentViewMock.configureWasCalled).to(beCalledOnce())
                expect(contentViewMock.configureReceivedViewModel).to(equal(TestData.viewModel))
                expect(contentViewMock).to(beDefaultState())
                expect(viewController.state).to(equal(.displayData(TestData.viewModel)))
            }
        }

        describe(".displayDocument") {
            it("should route to pdf viewer") {
                // given
                let url = URL(fileURLWithPath: "")
                // when
                viewController.displayDocument(.init(url: url))
                // then
                expect(routesMock.openPDFLocalURLWasCalled).to(beCalledOnce())
                expect(routesMock.openPDFLocalURLReceivedLocalURL).to(equal(url))
                expect(contentViewMock).to(beDefaultState())
            }
        }

        describe(".displayDocumentError") {
            it("should set state and navigate to alert") {
                // when
                viewController.displayDocumentError(TestData.loadingErrorData)
                // then
                expect(contentViewMock).to(beDefaultState())
                expect(routesMock.errorAlertWithActionHandlerWasCalled).to(beCalledOnce())
                expect(routesMock.errorAlertWithActionHandlerReceivedArguments?.message)
                    .to(equal(TestData.loadingErrorData))
                expect(routesMock.errorAlertWithActionHandlerReceivedArguments?.actionHandler)
                    .to(beNil())
            }
        }

        describe(".selectDocument") {
            it("should route to pdf viewer") {
                // given
                viewController.state = .displayData(TestData.viewModel)
                // when
                viewController.selectDocument()
                // then
                viewController.state = TestData.expectedState
                expect(interactorMock.loadDocumentWasCalled).to(beCalledOnce())
                expect(interactorMock.loadDocumentReceivedRequest).to(equal(TestData.loadDocumentReceivedRequest))
                expect(contentViewMock).to(beWaitingState())
            }
        }

        describe(".keyboardWillShow") {
            it("should ask content view to update bottom offset") {
                // when
                viewController.keyboardWillShow(TestData.keyboardConfiguration)
                // then
                expect(contentViewMock.updateBottomOffsetWithWillShowWasCalled).to(beCalledOnce())
                expect(contentViewMock.updateBottomOffsetWithWillShowReceivedArguments?.offset)
                    .to(equal(TestData.keyboardConfiguration.contentBottomOffset))
                expect(contentViewMock.updateBottomOffsetWithWillShowReceivedArguments?.willShow).to(beTrue())
            }
        }

        describe(".keyboardWillHide") {
            it("should ask content view to update bottom offset") {
                // when
                viewController.keyboardWillHide(TestData.keyboardConfiguration)
                // then
                expect(contentViewMock.updateBottomOffsetWithWillShowWasCalled).to(beCalledOnce())
                expect(contentViewMock.updateBottomOffsetWithWillShowReceivedArguments?.offset)
                    .to(equal(TestData.keyboardConfiguration.contentBottomOffset))
                expect(contentViewMock.updateBottomOffsetWithWillShowReceivedArguments?.willShow).to(beFalse())
            }
        }

        describe(".textFieldDidEndEditing") {
            context("when state is .displayData") {
                it("should ask interactor to reload data") {
                    // given
                    viewController.state = .displayData(TestData.viewModel)
                    // when
                    viewController.textFieldDidEndEditing("text")
                    // then
                    expect(interactorMock.loadDataWasCalled).to(beCalledOnce())
                    expect(interactorMock.loadDataReceivedRequest)
                        .to(equal(TestData.expectedParameters))
                }
            }
            context("when state is not .displayData") {
                it("should not ask interactor to reload data") {
                    // given
                    viewController.state = .loading
                    // when
                    viewController.textFieldDidEndEditing("text")
                    // then
                    expect(interactorMock.loadDataWasCalled).toNot(beCalled())
                }
            }
        }

        describe(".display(_ viewModel:)") {
            context("when state is startLoading") {
                it("should ask contentView to show proper state") {
                    // when
                    viewController.display(.init(state: .startLoading))
                    // then
                    expect(contentViewMock).to(beWaitingState())
                }
            }
            context("when state is endLoading") {
                it("should ask contentView to show proper state") {
                    // when
                    viewController.display(.init(state: .endLoading))
                    // then
                    expect(contentViewMock).to(beDefaultState())
                }
            }
            context("when state is error") {
                it("should navigate to alert") {
                    // given
                    let message = "message"
                    // when
                    viewController.display(.init(state: .error(message: message)))
                    // then
                    expect(routesMock.errorAlertWithActionHandlerWasCalled).to(beCalledOnce())
                    expect(routesMock.errorAlertWithActionHandlerReceivedArguments?.message).to(equal(message))
                    expect(routesMock.errorAlertWithActionHandlerReceivedArguments?.actionHandler).to(beNil())

                    expect(contentViewMock).to(beDefaultState())
                }
            }
            context("when view model state is showConfirmation") {
                it("should navigate to operation confirmation") {
                    // given
                    analyticsMock.getConfirmationScreenNameStub = "screenName"
                    // when
                    viewController.display(TestData.showConfirmationViewModel)
                    // then
                    expect(routesMock.openOperationConfirmationWithWasCalled).to(beCalledOnce())
                    expect(routesMock.openOperationConfirmationWithWasCalled).to(beCalledOnce())
                    expect(routesMock.openOperationConfirmationWithReceivedConfiguration?.interactorConfiguration)
                        .to(equal(TestData.confirmationConfiguration.interactorConfiguration))
                    expect(routesMock.openOperationConfirmationWithReceivedConfiguration?.provider)
                        .to(beIdenticalTo(TestData.confirmationConfiguration.provider))
                    expect(routesMock.openOperationConfirmationWithReceivedConfiguration?.delegate)
                        .to(beIdenticalTo(TestData.confirmationConfiguration.delegate))
                    expect(routesMock.openOperationConfirmationWithReceivedConfiguration?.screenName)
                        .to(equal(analyticsMock.getConfirmationScreenNameStub))
                    expect(analyticsMock.getConfirmationScreenNameWasCalled).to(beCalledOnce())
                    expect(contentViewMock).to(beDefaultState())
                }
            }
        }

        describe(".displayResultScreen") {
            it("should navigate to result screen") {
                // when
                viewController.displayResultScreen(TestData.DisplayResultScreen.model)
                // then
                expect(routesMock.resultScreenModelWasCalled).to(beCalledOnce())
                expect(routesMock.resultScreenModelReceivedModel)
                    .to(equal(TestData.DisplayResultScreen.viewModel))
            }
            it("should pass correct action") {
                // given
                viewController.displayResultScreen(TestData.DisplayResultScreen.model)
                // when
                routesMock.resultScreenModelReceivedModel?.onDoneButtonTapped?()
                // then
                expect(routesMock.instalmentsListWasCalled).to(beCalledOnce())
            }

            it("should pass correct action") {
                // given
                viewController.displayResultScreen(TestData.DisplayResultScreen.model)
                // when
                routesMock.resultScreenModelReceivedModel?.onCloseButtonTapped?()
                // then
                expect(routesMock.instalmentsListWasCalled).to(beCalledOnce())
            }
        }

        describe(".nextButtonAction") {
            context("when state is not .displayData") {
                it("should do nothing") {
                    // given
                    viewController.state = .loading
                    // when
                    viewController.nextButtonAction()
                    // then
                    expect(interactorMock.cancelInstallmentWasCalled).toNot(beCalled())
                }
            }
            context("when has inputError") {
                it("should do nothing") {
                    // given
                    viewController.state = .displayData(TestData.NextButtonAction.incorrectViewModel)
                    // when
                    viewController.nextButtonAction()
                    // then
                    expect(interactorMock.cancelInstallmentWasCalled).toNot(beCalled())
                }
            }
            context("when has correct data") {
                it("should call interactor") {
                    // given
                    viewController.state = .displayData(TestData.NextButtonAction.viewModel)
                    // when
                    viewController.nextButtonAction()
                    // then
                    expect(interactorMock.cancelInstallmentWasCalled).to(beCalledOnce())
                    expect(interactorMock.cancelInstallmentReceivedRequest)
                        .to(equal(.init(parameters: TestData.NextButtonAction.parameters)))
                }
            }
        }

        describe(".displayEmptyState") {
            it("should display empty state") {
                // given
                viewController.state = .displayData(TestData.DisplayEmptyState.viewModel)
                // when
                viewController.displayEmptyState(TestData.DisplayEmptyState.emptyViewModel)
                // then
                expect(contentViewMock).to(beEmptyState())
                expect(contentViewMock.emptyViewReceivedModel).to(equal(TestData.DisplayEmptyState.emptyViewModel))
            }

            context("when there are parameters") {
                it("should pass action to interactor with parameters") {
                    // given
                    viewController.contentView = contentViewMock
                    viewController.state = .displayData(TestData.DisplayEmptyState.viewModel)
                    viewController.displayEmptyState(TestData.DisplayEmptyState.emptyViewModel)
                    // when
                    contentViewMock.emptyViewReceivedModel?.firstButtonViewModel?.buttonHandler?(ButtonWithActivityMock())
                    // then
                    expect(interactorMock.loadDataWasCalled).to(beCalledOnce())
                    expect(interactorMock.loadDataReceivedRequest).to(equal(TestData.DisplayEmptyState.viewModel.parameters))
                }
            }

            context("when there are no parameters") {
                it("should pass action to interactor with nil") {
                    // given
                    viewController.contentView = contentViewMock
                    viewController.state = .loading
                    viewController.displayEmptyState(TestData.DisplayEmptyState.emptyViewModel)
                    // when
                    contentViewMock.emptyViewReceivedModel?.firstButtonViewModel?.buttonHandler?(ButtonWithActivityMock())
                    // then
                    expect(interactorMock.loadDataWasCalled).to(beCalledOnce())
                    expect(interactorMock.loadDataReceivedRequest)
                        .to(equal(CancelInstallment.PresentModuleData.Request.none))
                }
            }
        }
    }
}

private extension CancelInstallmentViewControllerTests {
    enum TestData {
        enum DisplayEmptyState {
            static let emptyViewModel = DefaultEmptyViewModel(
                icon: .init(icon: .image(UIImage.assets.glyph_repearTool_m.withRenderingMode(.alwaysTemplate))),
                title: L10n.CancelInstallment.EmptyState.title,
                subtitle: L10n.CancelInstallment.EmptyState.subtitle,
                firstButtonViewModel: EmptyViewButtonViewModel(title: L10n.CancelInstallment.EmptyState.buttonTitle)
            )
            static let viewModel = CancelInstallment.PresentModuleData.ViewModel(
                titleViewModel: CancelInstallment.Seeds.emptyTitleViewModel,
                buttonTitle: .empty,
                sections: [],
                parameters: .init(email: nil, inputError: nil, agreementNumber: .empty, installmentNumber: .empty)
            )
        }

        enum DisplayResultScreen {
            static let isSuccess = true
            static let iconViewModel = IconViewViewModel(
                size: .l,
                shape: .superEllipse,
                icon: .image(UIImage.assets.glyph_checkmark_m).with(tintColor: appearance.palette.staticGraphicLight),
                backgroundColor: appearance.palette.graphicPositive,
                titleColor: appearance.palette.staticGraphicLight,
                state: .default
            )
            static let model = CancelInstallment.Cancel.ViewModel(model: viewModel)
            static let viewModel = ResultScreenModel(
                icon: iconViewModel,
                status: L10n.CancelInstallment.ResultScreen.title,
                info: L10n.CancelInstallment.ResultScreen.text,
                doneButtonTitle: L10n.CancelInstallment.ResultScreen.buttonTitle
            )
        }

        enum NextButtonAction {
            static let viewModel = CancelInstallment.PresentModuleData.ViewModel(
                titleViewModel: CancelInstallment.Seeds.titleViewModel,
                buttonTitle: L10n.CancelInstallment.buttonTitle,
                sections: [],
                parameters: parameters
            )
            static let parameters = CancelInstallment.Parameters(
                email: "mis1@alfabank.ru",
                inputError: nil,
                agreementNumber: "123",
                installmentNumber: "123"
            )
            static let incorrectViewModel = CancelInstallment.PresentModuleData.ViewModel(
                titleViewModel: CancelInstallment.Seeds.titleViewModel,
                buttonTitle: L10n.CancelInstallment.buttonTitle,
                sections: [],
                parameters: incorrectParameters
            )
            static let incorrectParameters = CancelInstallment.Parameters(
                email: nil,
                inputError: .incorrect,
                agreementNumber: "123",
                installmentNumber: "123"
            )
        }

        static let keyboardConfiguration = KeyboardTracker.KeyboardConfigurations(
            animationDuration: 1,
            animationOptions: [],
            contentBottomOffset: 0,
            frame: .zero
        )
        static let viewModel = CancelInstallment.PresentModuleData.ViewModel(
            titleViewModel: CancelInstallment.Seeds.titleViewModel,
            buttonTitle: L10n.CancelInstallment.buttonTitle,
            sections: [],
            parameters: parameters
        )
        static let parameters = CancelInstallment.Parameters(
            email: .empty,
            inputError: nil,
            agreementNumber: "123",
            installmentNumber: "123"
        )
        static let expectedParameters = CancelInstallment.Parameters(
            email: "text",
            inputError: TestData.viewModel.parameters.inputError,
            agreementNumber: "123",
            installmentNumber: "123"
        )
        static let loadingErrorData = "Some error description"
        static let loadDocumentReceivedRequest = CancelInstallment.PresentDocument.Request(parameters: parameters)
        static let expectedState = CancelInstallmentViewController<CancelInstallmentRoutesMock>
            .State.displayData(viewModel)
        static let showConfirmationViewModel: Confirmation.OperationConfirm.ViewModel = .init(
            state: .showConfirmation(configuration: confirmationConfiguration)
        )
        static let operationConfirmationDelegateDummy = OperationConfirmationDelegateDummy()

        static let confirmationConfiguration: OperationConfirmationPartialConfiguration = {
            let confirmatInteractorConfiguration = OperationConfirmationInteractor.Configuration(
                passwordLength: 4
            )
            return (
                delegate: operationConfirmationDelegateDummy,
                provider: operationConfirmationDelegateDummy,
                interactorConfiguration: confirmatInteractorConfiguration,
                screenName: nil
            )
        }()

        static let appearance = Appearance(); struct Appearance: Grid, Theme { }
    }
}
