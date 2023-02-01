//  Created by Lyudmila Danilchenko on 17/08/2020.

import ABUIComponents
import TestAdditions

@testable import Installments

final class InstalmentListViewTests: QuickSpec {
    override func spec() {
        var view: InstalmentListView!
        var delegateMock: InstalmentListViewDelegateMock!
        var stateView: InstalmentStateView!
        var tableViewMock: UITableViewMock!
        var tableManagerMock: ManagesInstalmentListTableMock!

        beforeEach {
            delegateMock = .init()
            view = InstalmentListView(delegate: delegateMock)
            stateView = InstalmentStateView()
            view.stateView = stateView
            tableViewMock = UITableViewMock()
            view.tableView = tableViewMock
            tableManagerMock = ManagesInstalmentListTableMock()
        }

        describe(".init") {
            context("with delegate") {
                it("should set delegate properly") {
                    // when
                    view = InstalmentListView(delegate: delegateMock)

                    // then
                    expect(view.delegate).to(beIdenticalTo(delegateMock))
                }
            }

            context("without delegate") {
                it("should set delegate properly") {
                    // when
                    view = InstalmentListView(delegate: nil)

                    // then
                    expect(view.delegate).to(beNil())
                }
            }
        }

        describe(".refreshControlAction") {
            it("should call delegate.pullToRefreshAction") {
                // when
                view.refreshControl.sendActionsInTests(for: .valueChanged)

                // then
                expect(delegateMock.pullToRefreshActionWasCalled)
                    .to(beCalledOnce())
            }
        }

        describe(".endRefreshing") {
            it("should call refreshControl.endRefreshing") {
                // given
                let refreshMock = UIRefreshControlMock()
                view.refreshControl = refreshMock

                // when
                view.endRefreshing()

                // then
                expect(refreshMock.endRefreshingWasCalled).to(beCalledOnce())
            }
        }

        describe(".configureTableView") {
            it("should configure table") {
                // when
                let refreshMock = UIRefreshControlMock()
                view.refreshControl = refreshMock
                view.configureTableView(with: tableManagerMock)

                // then
                expect(tableViewMock.delegate).to(beIdenticalTo(tableManagerMock))
                expect(tableViewMock.dataSource).to(beIdenticalTo(tableManagerMock))
                expect(tableViewMock.subviews).to(contain(refreshMock))
            }
        }

        describe(".styleForWaitingView") {
            it("should return lightWithBackground") {
                // when
                let result = stateView.styleForWaitingView()
                // then
                expect(result).to(equal(.lightWithBackground))
            }
        }

        describe(".reloadTableView") {
            beforeEach {
                view.tableView = tableViewMock
            }
            it("should reload tableView") {
                // when
                view.reloadTableView()
                // then
                expect(tableViewMock.reloadDataWasCalled).to(beCalledOnce())
            }
        }

        describe(".showState") {
            it("should show waiting state") {
                // given
                stateView.showState(.default)
                // when
                view.showState(.waiting)
                // then
                expect(stateView).to(beWaitingState())
                expect(stateView.isHidden).to(beFalse())
            }

            it("when show default state state view hidden") {
                // given
                stateView.showState(.waiting)
                // when
                view.showState(.default)
                // then
                expect(stateView.isHidden).to(beTrue())
            }
        }
    }
}
