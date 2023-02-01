//  Created by Lyudmila Danilchenko on 27.10.2020.

import ABUIComponents

final class InstalmentStateView: UIView, DisplaysContentStateTrait, DisplaysDefaultContentState {
    typealias EmptyStyle = EmptyViewStyle.FullPage.Primary

    public func styleForWaitingView() -> WaitingView.Style { .lightWithBackground }
}
