//  Created by Lyudmila Danilchenko on 25/10/2020.

import ABUIComponents
import TestAdditions

@testable import Installments

final class InstalmentDetailViewTests: QuickSpec {
    override func spec() {
        var view: InstalmentDetailView!
        var delegateMock: DisplaysInstalmentDetailViewDelegateMock!
        var tableViewMock: UITableViewMock!
        var tableManagerMock: ManagesInstalmentDetailTableMock!

        beforeEach {
            delegateMock = .init()
            view = InstalmentDetailView(delegate: delegateMock)
            tableViewMock = .init()
            view.tableView = tableViewMock
            tableManagerMock = .init()
        }

        describe(".init") {
            it("should configure table") {
                // given
                let view = InstalmentDetailView(delegate: delegateMock)
                // then
                expect(view.tableView.backgroundColor).to(equal(TestData.Palette.backgroundPrimary))
                expect(view.tableView.separatorStyle).to(equal(UITableViewCell.SeparatorStyle.none))
                expect(view.tableView.allowsSelection).to(beTrue())
                expect(view.tableView.contentInset.bottom).to(equal(TestData.bottomContentInset))
            }
        }

        describe(".styleForWaitingView") {
            it("should return lightWithBackground") {
                // when
                let result = view.styleForWaitingView()
                // then
                expect(result).to(equal(.lightWithBackground))
            }
        }

        describe(".reloadTableView") {
            it("should reload tableView") {
                // when
                view.reloadTableView()
                // then
                expect(tableViewMock.reloadDataWasCalled).to(beCalledOnce())
            }
        }

        describe(".configureTableView") {
            it("should configure table") {
                // when
                view.configureTableView(with: tableManagerMock)
                // then
                expect(tableViewMock.delegate).to(beIdenticalTo(tableManagerMock))
                expect(tableViewMock.dataSource).to(beIdenticalTo(tableManagerMock))
            }
        }

        describe(".configure") {
            context("when should hide and should enable") {
                it("should set button state") {
                    // when
                    view.configure(.init(
                        sections: [],
                        shouldEnableRepayment: true,
                        shouldHideRepayment: true,
                        title: TestData.headerTitle
                    ))
                    // then
                    expect(view.repaymentButton.isHidden).to(beTrue())
                    expect(view.repaymentButton.isEnabled).to(beTrue())
                }
            }
            context("when should hide and should not enable") {
                it("should set button state") {
                    // when
                    view.configure(.init(
                        sections: [],
                        shouldEnableRepayment: false,
                        shouldHideRepayment: true,
                        title: TestData.headerTitle
                    ))
                    // then
                    expect(view.repaymentButton.isHidden).to(beTrue())
                    expect(view.repaymentButton.isEnabled).to(beFalse())
                }
            }
            context("when should not hide and should enable") {
                it("should set button state") {
                    // when
                    view.configure(.init(
                        sections: [],
                        shouldEnableRepayment: true,
                        shouldHideRepayment: false,
                        title: TestData.headerTitle
                    ))
                    // then
                    expect(view.repaymentButton.isHidden).to(beFalse())
                    expect(view.repaymentButton.isEnabled).to(beTrue())
                }
            }
            context("when should not hide and should not enable") {
                it("should set button state") {
                    // when
                    view.configure(.init(
                        sections: [],
                        shouldEnableRepayment: false,
                        shouldHideRepayment: false,
                        title: TestData.headerTitle
                    ))
                    // then
                    expect(view.repaymentButton.isHidden).to(beFalse())
                    expect(view.repaymentButton.isEnabled).to(beFalse())
                }
            }
        }

        describe(".repaymentButton touchUpInside") {
            it("should handle action") {
                // when
                view.repaymentButton.sendActionsInTests(for: .touchUpInside)
                // then
                expect(delegateMock.repaymentButtonClickedWasCalled).to(beCalledOnce())
            }
        }
    }
}

private extension InstalmentDetailViewTests {
    enum TestData: Theme {
        // MARK: Internal

        static let bottomContentInset: CGFloat = 72

        static let headerTitle = ""

        // MARK: Private

        private struct DefaultHeader: DefaultHeaderViewRepresentable {
            let title: String
        }
    }
}
