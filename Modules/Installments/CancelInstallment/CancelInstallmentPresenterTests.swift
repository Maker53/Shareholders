//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import ABUIComponents
import ResultScreen
import TestAdditions

@testable import Installments

final class CancelInstallmentPresenterTests: QuickSpec {
    override func spec() {
        var presenter: CancelInstallmentPresenter!
        var viewControllerMock: CancelInstallmentDisplayLogicMock!

        beforeEach {
            presenter = CancelInstallmentPresenter()
            viewControllerMock = CancelInstallmentDisplayLogicMock()
            presenter.viewController = viewControllerMock
        }

        describe(".presentData") {
            it("should pass correct view model to view controller") {
                // when
                presenter.presentData(TestData.response)
                // then
                expect(viewControllerMock.displayDataWasCalled).to(beCalledOnce())
                expect(viewControllerMock.displayDataReceivedViewModel).to(equal(TestData.viewModel))
            }
        }

        describe(".presentDocument") {
            it("should ask view controller to present document") {
                // given
                let response = CancelInstallment.PresentDocument.Response(url: URL(fileURLWithPath: ""))
                // when
                presenter.presentDocument(response)
                // then
                expect(viewControllerMock.displayDocumentWasCalled).to(beCalledOnce())
                expect(viewControllerMock.displayDocumentReceivedViewModel).to(equal(response))
            }
        }

        describe(".presentError") {
            context("when documentLoadingError") {
                it("should ask viewController to display the error alert") {
                    // given
                    let error = CancelInstallment.ErrorType.documentLoadingError(TestData.PresentError.loadingErrorSubtitle)
                    // when
                    presenter.presentError(error)
                    // then
                    expect(viewControllerMock.displayDocumentErrorWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayDocumentErrorReceivedData)
                        .to(equal(TestData.PresentError.loadingErrorSubtitle))
                }
            }

            context("when loadingFailed") {
                it("should ask viewController to display empty state") {
                    // when
                    presenter.presentError(.loadingFailed(.empty))
                    // then
                    expect(viewControllerMock.displayEmptyStateWasCalled).to(beCalledOnce())
                    expect(viewControllerMock.displayEmptyStateReceivedViewModel).to(equal(TestData.PresentError.emptyStateViewModel))
                }
            }
        }

        describe(".presentResultScreen") {
            it("should ask view controller to present result screen") {
                // when
                presenter.presentResultScreen(.init(isSuccess: TestData.PresentResultScreen.isSuccess))
                // then
                expect(viewControllerMock.displayResultScreenWasCalled).to(beCalledOnce())
                expect(viewControllerMock.displayResultScreenReceivedViewModel).to(equal(TestData.PresentResultScreen.model))
            }
        }

        describe(".presentEmptyState") {
            it("should ask viewController to display empty state") {
                // when
                presenter.presentEmptyState()
                // then
                expect(viewControllerMock.displayEmptyStateWasCalled).to(beCalledOnce())
                expect(viewControllerMock.displayEmptyStateReceivedViewModel).to(equal(TestData.PresentEmptyState.emptyStateViewModel))
            }
        }
    }
}

private extension CancelInstallmentPresenterTests {
    enum TestData {
        enum PresentEmptyState {
            static let emptyStateViewModel = DefaultEmptyViewModel(
                icon: .init(icon: .image(UIImage.assets.glyph_repearTool_m.withRenderingMode(.alwaysTemplate))),
                title: L10n.CancelInstallment.EmptyState.title,
                subtitle: L10n.CancelInstallment.EmptyState.subtitle,
                firstButtonViewModel: EmptyViewButtonViewModel(title: L10n.CancelInstallment.EmptyState.buttonTitle)
            )
        }

        enum PresentError {
            static let loadingErrorSubtitle = "loadingErrorSubtitle"
            static let emptyStateViewModel = DefaultEmptyViewModel(
                icon: .init(icon: .image(UIImage.assets.glyph_repearTool_m.withRenderingMode(.alwaysTemplate))),
                title: L10n.CancelInstallment.EmptyState.title,
                subtitle: L10n.CancelInstallment.EmptyState.subtitle,
                firstButtonViewModel: EmptyViewButtonViewModel(title: L10n.CancelInstallment.EmptyState.buttonTitle)
            )
        }

        enum PresentResultScreen {
            static let isSuccess = true
            static let iconViewModel = IconViewViewModel(
                icon: .image(UIImage.assets.glyph_checkmark_m).with(tintColor: appearance.palette.staticGraphicLight),
                backgroundColor: appearance.palette.graphicPositive,
                titleColor: appearance.palette.staticGraphicLight,
                state: .default
            )
            static let model = CancelInstallment.Cancel.ViewModel(model: .init(
                icon: iconViewModel,
                status: L10n.CancelInstallment.ResultScreen.title,
                info: L10n.CancelInstallment.ResultScreen.text,
                doneButtonTitle: L10n.CancelInstallment.ResultScreen.buttonTitle
            )
            )
        }

        static let sections = [
            CancelInstallmentSection(
                header: nil,
                rows: [
                    .textView(CancelInstallment.Seeds.textViewRowViewModel),
                    .comissionRefund(
                        .init(
                            dataContent: .init(
                                title: L10n.CancelInstallment.comissionText,
                                value: "\(money: installment.paymentInfo.payment.commissionAmount)"
                            ),
                            icon: .init(icon: .image(UIImage.assets.glyph_bigArrowLeftLine_m))
                        )
                    ),
                    .redText(
                        .init(
                            dataContent: .init(
                                title: L10n.CancelInstallment.cancelRedText,
                                titleColor: appearance.palette.textAccent
                            ),
                            icon: .init(icon: .image(UIImage.assets.glyph_alertCircle_m_negative))
                        )
                    ),
                ]
            ),
            CancelInstallmentSection(
                header: L10n.CancelInstallment.documentsTitle,
                rows: [
                    .document(
                        .init(
                            dataContent: .init(
                                title: L10n.CancelInstallment.cancelDocumentTitle
                            ),
                            icon: .init(
                                icon: .image(UIImage.assets.glyph_document_m.with(tintColor: appearance.palette.graphicSecondary)),
                                backgroundColor: appearance.palette.specialbgNulled
                            )
                        )
                    ),
                ]
            ),
            CancelInstallmentSection(
                header: nil,
                rows: [
                    .input(
                        .init(
                            errorMessage: response.parameters.inputError?.errorMessage,
                            formatter: CommonTextFieldFormatter(),
                            hint: nil,
                            isEnabled: true,
                            keyboardType: .emailAddress,
                            placeholder: L10n.Common.emailPlaceholer,
                            showClearButton: false,
                            text: TestData.parameters.email,
                            title: L10n.Common.emailTitle
                        )
                    ),
                ]
            ),
        ]
        static let viewModel = CancelInstallment.PresentModuleData.ViewModel(
            titleViewModel: CancelInstallment.Seeds.titleViewModel,
            buttonTitle: L10n.CancelInstallment.buttonTitle,
            sections: sections,
            parameters: parameters
        )
        static let parameters = CancelInstallment.Parameters(
            email: "email",
            inputError: .incorrect,
            agreementNumber: "123",
            installmentNumber: "123"
        )
        static let installment = Instalment.Seeds.valueCancellationAvailable
        static let response = CancelInstallment.PresentModuleData.Response(
            installment: Instalment.Seeds.valueCancellationAvailable, parameters: parameters
        )

        static let appearance = Appearance(); struct Appearance: Grid, Theme { }
    }
}
