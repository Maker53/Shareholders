//  Created by Lyudmila Danilchenko on 23.09.2020.

import ABUIComponents

final class InstalmentListCell: UITableViewCell, ViewModelConfigurable {
    private let appearance = Appearance(); struct Appearance: Grid, Theme { }

    private let view = ProgressWidgetView<DefaultProgressWidgetStyle>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(with viewModel: InstalmentListCellViewModel) {
        view.configure(with: viewModel)
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        view.backgroundColor = highlighted ? appearance.palette.backgroundTertiary : appearance.palette.backgroundSecondary
    }

    private func setupView() {
        contentView.backgroundColor = appearance.palette.backgroundPrimary
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(appearance.xsSpace)
            make.leading.trailing.equalToSuperview().inset(appearance.horizontalMargin)
            make.bottom.equalToSuperview()
        }
    }
}
