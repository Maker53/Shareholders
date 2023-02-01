//  Created by Рамазанов Виталий Глебович on 27/08/2021.

import ABUIComponents
import TestAdditions

@testable import Installments

final class CancelInstallmentViewTests: QuickSpec {
    override func spec() {
        var view: CancelInstallmentView!
        var tableViewMock: UITableViewMock!
        var tableManager: CancelInstallmentTableManager!
        var nextButton: PrimaryMainButton!
        var delegateMock: CancelInstallmentViewDelegateMock!

        beforeEach {
            tableViewMock = .init()
            view = CancelInstallmentView()
            delegateMock = .init()
            view.delegate = delegateMock
            tableManager = view["tableManager"]
            nextButton = view.subviews[1].subviews[0] as? PrimaryMainButton
        }

        describe(".styleForWaitingView") {
            it("should return lightWithBackground") {
                // when
                let result = view.styleForWaitingView()
                // then
                expect(result).to(equal(.light))
            }
        }

        describe(".init") {
            it("should set keyboard dismissing mode") {
                // then
                expect(view.tableView.keyboardDismissMode).to(equal(UIScrollView.KeyboardDismissMode.onDrag))
                expect(tableManager.delegate).to(beIdenticalTo(view))
                expect(view.tableView.contentInset.bottom).to(equal(TestData.UpdateBottomOffset.expectedInsetWithoutKeyboard))
            }
        }

        describe(".tableManager") {
            it("should create correct manager and configure table view") {
                // when
                let manager: CancelInstallmentTableManager? = view["tableManager"]
                // then
                expect(view.tableView.dataSource).to(beIdenticalTo(manager))
                expect(view.tableView.delegate).to(beIdenticalTo(manager))
            }
        }

        describe(".configure") {
            it("should ask table view to reload data") {
                // given
                view.tableView = tableViewMock
                // when
                view.configure(
                    .init(
                        titleViewModel: CancelInstallment.Seeds.emptyTitleViewModel,
                        buttonTitle: .empty,
                        sections: [],
                        parameters: .init(email: .empty, inputError: nil, agreementNumber: "123", installmentNumber: "123")
                    )
                )
                // then
                expect(tableViewMock.reloadDataWasCalled).to(beCalledOnce())
                expect(tableManager.sections).to(beEmpty())
            }
        }

        describe(".nextButton touchUpInside") {
            it("should call delegate's method") {
                // when
                nextButton.sendActionsInTests(for: .touchUpInside)
                // then
                expect(delegateMock.nextButtonActionWasCalled).to(beCalledOnce())
            }
        }

        describe(".updateBottomOffset") {
            it("should update tableView's bottom inset") {
                // when
                view.updateBottomOffset(with: TestData.UpdateBottomOffset.argument, willShow: true)
                // then
                expect(view.tableView.contentInset.bottom).to(equal(TestData.UpdateBottomOffset.expectedInset))
            }

            it("should update tableView's bottom inset") {
                // when
                view.updateBottomOffset(with: TestData.UpdateBottomOffset.argument, willShow: false)
                // then
                expect(view.tableView.contentInset.bottom).to(equal(TestData.UpdateBottomOffset.expectedInsetWithoutKeyboard))
            }
        }

        describe(".textFieldDidEndEditing") {
            it("should call delegate's method") {
                // when
                view.textFieldDidEndEditing("text")
                // then
                expect(delegateMock.textFieldDidEndEditingWasCalled).to(beCalledOnce())
                expect(delegateMock.textFieldDidEndEditingReceivedText).to(equal("text"))
            }
        }

        describe(".didSelectDocument") {
            it("should call delegate's method") {
                // when
                view.didSelectDocument()
                // then
                expect(delegateMock.selectDocumentWasCalled).to(beCalledOnce())
            }
        }
    }
}

extension CancelInstallmentView: PropertyReflectable { }

private extension CancelInstallmentViewTests {
    enum TestData {
        enum UpdateBottomOffset {
            static let argument: CGFloat = 666
            static let expectedInset: CGFloat = 678
            static let expectedInsetWithoutKeyboard: CGFloat = 100
        }
    }
}
