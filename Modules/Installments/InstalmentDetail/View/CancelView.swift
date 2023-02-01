//  Created by Lyudmila Danilchenko on 30.08.2021.

import ABUIComponents

final class CancelView: UIView {
    enum CancelButtonStyle: CustomMainButtonStyle, Theme {
        static var titleColor: UIColor { Palette.textPrimary }
        static var backgroundColor: UIColor { Palette.specialbgTertiaryGrouped }
    }

    private let appearance = Appearance(); struct Appearance: Grid, Theme {
        var textViewInsets: UIEdgeInsets {
            UIEdgeInsets(top: sSpace, left: extendedHorizontalMargin, bottom: sSpace, right: extendedHorizontalMargin)
        }
    }

    private lazy var textView: TextView = {
        let view = TextView()
        view.configure(
            with: TextView.ViewModel(
                leftTextViewModel: DefaultTextLabelViewModel(
                    text: L10n.Installments.InstalmentDetail.CancelBanner.text,
                    typography: .paragraphPrimarySmall,
                    textColor: appearance.palette.textPrimary,
                    textAlignment: .left,
                    numberOfLines: 0
                ),
                insets: appearance.textViewInsets
            )
        )
        return view
    }()

    private lazy var cancelButton: MainButton<MainButtonStyle.Custom<CancelButtonStyle>> = {
        let button = MainButton<MainButtonStyle.Custom<CancelButtonStyle>>(sizeType: .medium)
        button.setTitle(L10n.Installments.InstalmentDetail.CancelBanner.buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()

    @objc
    private func cancelButtonAction() {
        NotificationCenter.default.post(name: InstalmentDetail.cancelNotificationName, object: nil)
    }

    public init() {
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension CancelView {
    func addSubviews() {
        addSubview(textView)
        addSubview(cancelButton)
    }

    func makeConstraints() {
        textView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(appearance.xxxlSpace)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(textView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview().inset(appearance.horizontalMargin)
            make.bottom.equalToSuperview().inset(appearance.sSpace)
        }
    }
}
