import ABUIComponents
import TestAdditions

@testable import Installments

final class CancelViewTests: QuickSpec {
    override func spec() {
        typealias ButtonStyle = MainButton<MainButtonStyle.Custom<CancelView.CancelButtonStyle>>
        var view: CancelView!
        var receiver: NotificationsReceiver!
        var cancelButton: ButtonStyle!

        beforeEach {
            view = .init()
            receiver = .init()
            cancelButton = view.subviews[1] as? ButtonStyle
        }

        describe(".cancelButton touchUpInside") {
            it("should post notification") {
                // when
                cancelButton.sendActionsInTests(for: .touchUpInside)
                // then
                expect(receiver.actionWasCalled).to(beCalledOnce())
            }
        }
    }
}

private final class NotificationsReceiver: NSObject {
    private(set) var actionWasCalled: Int = 0

    override init() {
        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(action),
            name: InstalmentDetail.cancelNotificationName,
            object: nil
        )
    }

    @objc
    private func action() {
        actionWasCalled += 1
    }
}
