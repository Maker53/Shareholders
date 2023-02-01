import ABUIComponents
import TestAdditions
@testable import Installments

final class RoundedTableHeaderViewTests: QuickSpec {
    override func spec() {
        var view: RoundedTableHeaderView!
        var textView: TextView!

        beforeEach {
            view = RoundedTableHeaderView(reuseIdentifier: nil)
            textView = view["textView"]
        }

        describe(".configure") {
            it("should handle corners properly") {
                // when
                view.configure(with: TestData.viewModel)
                // then
                expect(textView.layer.cornerRadius).to(equal(TestData.viewModel.cornerRadius))
                expect(textView.layer.maskedCorners).to(equal(TestData.viewModel.maskedCorners))
            }
        }
    }
}

extension RoundedTableHeaderView: PropertyReflectable { }
private extension RoundedTableHeaderViewTests {
    enum TestData {
        static let viewModel = RoundedTableHeaderViewViewModel(
            textViewViewModel: TextView.ViewModel(
                leftTextViewModel: DefaultTextLabelViewModel(
                    text: "TextViewText",
                    typography: .headlineXSmall,
                    textColor: .black
                ),
                insets: UIEdgeInsets(uniform: 16)
            ),
            cornerRadius: 24,
            maskedCorners: [.layerMaxXMinYCorner, .layerMinXMinYCorner],
            colorBehindTheCorners: .gray,
            headerViewBackgroundColor: .white
        )
    }
}
