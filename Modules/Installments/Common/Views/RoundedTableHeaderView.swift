import ABUIComponents
import PropertyWrappers

struct RoundedTableHeaderViewViewModel: Equatable {
    let textViewViewModel: TextView.ViewModel
    let cornerRadius: CGFloat
    let maskedCorners: CACornerMask

    @Semantic
    var colorBehindTheCorners: UIColor
    @Semantic
    var headerViewBackgroundColor: UIColor
}

final class RoundedTableHeaderView: UITableViewHeaderFooterView {
    private let appearance = Appearance(); struct Appearance: Grid, Theme { }
    private let textView = TextView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ViewModelConfigurable

extension RoundedTableHeaderView: ViewModelConfigurable {
    func configure(with viewModel: RoundedTableHeaderViewViewModel) {
        textView.configure(with: viewModel.textViewViewModel)

        contentView.backgroundColor = viewModel.colorBehindTheCorners
        textView.backgroundColor = viewModel.headerViewBackgroundColor
        textView.layer.cornerRadius = viewModel.cornerRadius
        textView.layer.maskedCorners = viewModel.maskedCorners
    }
}

private extension RoundedTableHeaderView {
    func addSubviews() {
        contentView.addSubview(textView)
    }

    func makeConstraints() {
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
