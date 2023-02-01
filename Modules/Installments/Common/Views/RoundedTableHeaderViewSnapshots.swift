import ABUIComponents
import TestAdditions

@testable import Installments

final class RoundedTableHeaderViewSnapshots: QuickSpec {
    override func spec() {
        var view: RoundedTableHeaderView!

        beforeEach {
            view = RoundedTableHeaderView(reuseIdentifier: nil)
        }

        describe(".configure") {
            it("should configure properly") {
                // when
                view.configure(with: TestData.viewModel)
                // then
                expect(view).to(beEqualSnapshot("RoundedTableHeaderView_configure"), layout: TestData.layout)
            }
        }
    }
}

private extension RoundedTableHeaderViewSnapshots {
    enum TestData: Theme {
        static let layout = SnapshotLayout.frameForFullWidthScreen(height: 120)

        static let viewModel = RoundedTableHeaderViewViewModel(
            textViewViewModel: TextView.ViewModel(
                leftTextViewModel: DefaultTextLabelViewModel(
                    text: "TextViewText",
                    typography: .headlineXSmall,
                    textColor: TestData.Palette.textPrimary
                ),
                insets: UIEdgeInsets(uniform: 16)
            ),
            cornerRadius: 24,
            maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner],
            colorBehindTheCorners: TestData.Palette.backgroundSecondary,
            headerViewBackgroundColor: TestData.Palette.backgroundPrimary
        )
    }
}
