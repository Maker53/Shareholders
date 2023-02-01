import Resources
import SharedPlatformExtensions
import SharedProtocolsAndModels

// swiftformat:disable organizeDeclarations

enum L10n {
    enum CancelInstallment {
        /// "Отменить рассрочку"
        static let buttonTitle = L10n.tr("Localizable", "CancelInstallment.buttonTitle")
        /// "Заявление на отмену рассрочки"
        static let cancelDocumentTitle = L10n.tr("Localizable", "CancelInstallment.cancelDocumentTitle")
        /// "После отмены рассрочки вернётся задолженность и старый льготный период по кредитке"
        static let cancelInfoText = L10n.tr("Localizable", "CancelInstallment.cancelInfoText")
        /// "После отмены рассрочки вернётся задолженность и старый льготный период по кредитке"
        static let cancelRedText = L10n.tr("Localizable", "CancelInstallment.cancelRedText")
        /// "Сегодня до 23:00 по московскому времени."
        static let cancelTimeText = L10n.tr("Localizable", "CancelInstallment.cancelTimeText")
        /// "Сегодня до 23:00 по московскому времени."
        static let cancelTimeTitle = L10n.tr("Localizable", "CancelInstallment.cancelTimeTitle")
        /// "Вернём комиссию"
        static let comissionText = L10n.tr("Localizable", "CancelInstallment.comissionText")
        /// "Документы"
        static let documentsTitle = L10n.tr("Localizable", "CancelInstallment.documentsTitle")
        /// "Рассрочку можно отменить"
        static let title = L10n.tr("Localizable", "CancelInstallment.title")
        enum EmptyState {
            /// "Попробовать ещё раз"
            static let buttonTitle = L10n.tr("Localizable", "CancelInstallment.EmptyState.buttonTitle")
            /// "Попробуйте ещё раз — скорее всего, всё уже заработало"
            static let subtitle = L10n.tr("Localizable", "CancelInstallment.EmptyState.subtitle")
            /// "Что-то сломалось"
            static let title = L10n.tr("Localizable", "CancelInstallment.EmptyState.title")
        }

        enum ResultScreen {
            /// "К списку рассрочек"
            static let buttonTitle = L10n.tr("Localizable", "CancelInstallment.ResultScreen.buttonTitle")
            /// "Комиссия за рассрочку вернётся обратно на счёт, а у кредитки активируется старый льготный период."
            static let text = L10n.tr("Localizable", "CancelInstallment.ResultScreen.text")
            /// "Рассрочка отменена"
            static let title = L10n.tr("Localizable", "CancelInstallment.ResultScreen.title")
        }
    }

    enum Common {
        /// "Ваш email"
        static let emailPlaceholer = L10n.tr("Localizable", "Common.emailPlaceholer")
        /// "Куда прислать документы?"
        static let emailTitle = L10n.tr("Localizable", "Common.emailTitle")
        /// "Что-то пошло не так"
        static let somethingWentWrong = L10n.tr("Localizable", "Common.SomethingWentWrong")
        enum EmailError {
            /// "Введите ваш email"
            static let emptyEmail = L10n.tr("Localizable", "Common.EmailError.emptyEmail")
            /// "Введён некорректный email"
            static let invalidEmail = L10n.tr("Localizable", "Common.EmailError.invalidEmail")
        }
    }

    enum Installment {
        /// "Следующий платёж"
        static let nextPayment = L10n.tr("Localizable", "Installment.NextPayment")
        /// "Дата покупки"
        static let purchaseDate = L10n.tr("Localizable", "Installment.PurchaseDate")
        /// "Сумма покупки"
        static let purchaseSum = L10n.tr("Localizable", "Installment.PurchaseSum")
        /// "Осталось погасить"
        static let remainingSum = L10n.tr("Localizable", "Installment.RemainingSum")
        /// "Срок рассрочки"
        static let termInMonth = L10n.tr("Localizable", "Installment.TermInMonth")
        /// "График платежей"
        static let title = L10n.tr("Localizable", "Installment.Title")
        enum Empty {
            /// "График платежей появится\nв течение пяти дней после первой\nпокупки."
            static let subtitle = L10n.tr("Localizable", "Installment.Empty.Subtitle")
            /// "Совершённых покупок нет"
            static let title = L10n.tr("Localizable", "Installment.Empty.Title")
        }
    }

    enum Installments {
        enum InstalmentDetail {
            /// "Куда вносить платёж"
            static let cardAccountTitle = L10n.tr("Localizable", "Installments.InstalmentDetail.CardAccountTitle")
            /// "Долг по кредитной карте"
            static let cardDebt = L10n.tr("Localizable", "Installments.InstalmentDetail.CardDebt")
            /// "Чтобы внести досрочный платёж,  погасите весь долг по кредитной карте"
            static let earlyPaymentBannerDebt = L10n.tr("Localizable", "Installments.InstalmentDetail.EarlyPaymentBannerDebt")
            /// "Не хватает денег на кредитном счёте, чтобы списать досрочный платёж"
            static let earlyPaymentBannerNoFunds = L10n.tr("Localizable", "Installments.InstalmentDetail.EarlyPaymentBannerNoFunds")
            /// "Ваш платёж будет обработан в течение дня — после этого сможете внести новый"
            static let earlyPaymentBannerProcessing = L10n.tr("Localizable", "Installments.InstalmentDetail.EarlyPaymentBannerProcessing")
            /// "Как внести досрочный платёж"
            static let earlyPaymentInfo = L10n.tr("Localizable", "Installments.InstalmentDetail.EarlyPaymentInfo")
            /// "Дата окончания рассрочки"
            static let lastPaymentDate = L10n.tr("Localizable", "Installments.InstalmentDetail.LastPaymentDate")
            /// "Погасить досрочно"
            static let payEarlyButton = L10n.tr("Localizable", "Installments.InstalmentDetail.PayEarlyButton")
            /// "Сумма платежа"
            static let paymentAmount = L10n.tr("Localizable", "Installments.InstalmentDetail.PaymentAmount")
            /// "Внесите платёж до"
            static let paymentDate = L10n.tr("Localizable", "Installments.InstalmentDetail.PaymentDate")
            /// "Рассрочка"
            static let title = L10n.tr("Localizable", "Installments.InstalmentDetail.Title")
            enum CancelBanner {
                /// "Отменить рассрочку"
                static let buttonTitle = L10n.tr("Localizable", "Installments.InstalmentDetail.CancelBanner.buttonTitle")
                /// "Если передумали — бесплатно отмените рассрочку сегодня до 23:00 (МСК)"
                static let text = L10n.tr("Localizable", "Installments.InstalmentDetail.CancelBanner.text")
            }

            enum DebitDialog {
                /// "Погасить"
                static let buttonTitle = L10n.tr("Localizable", "Installments.InstalmentDetail.DebitDialog.buttonTitle")
                /// "Переведите сумму погашения на счёт дебетовой рассрочки.\nЕсли у вас две рассрочки с ежемесячными платежами — сумма погасит тот, что больше."
                static let severalInstallmentsSubtitle = L10n.tr("Localizable", "Installments.InstalmentDetail.DebitDialog.severalInstallmentsSubtitle")
                /// "Просто переведите на счёт дебетовой рассрочки сумму, необходимую для погашения."
                static let subtitle = L10n.tr("Localizable", "Installments.InstalmentDetail.DebitDialog.subtitle")
                /// "Как погасить рассрочку раньше"
                static let title = L10n.tr("Localizable", "Installments.InstalmentDetail.DebitDialog.title")
            }

            enum InfoDialog {
                /// "Погасить"
                static let primaryButtonTitle = L10n.tr("Localizable", "Installments.InstalmentDetail.InfoDialog.PrimaryButtonTitle")
                /// "Закрыть"
                static let secondaryButtonTitle = L10n.tr("Localizable", "Installments.InstalmentDetail.InfoDialog.SecondaryButtonTitle")
                /// "1. Сначала погасите всю задолженность по кредитной карте.\n\n2. Затем пополните карту на сумму, которой хотите погасить рассрочку.\n\n3. После этого зайдите в рассрочку и нажмите «Погасить досрочно»."
                static let subtitle = L10n.tr("Localizable", "Installments.InstalmentDetail.InfoDialog.Subtitle")
                /// "Как внести досрочный платёж"
                static let title = L10n.tr("Localizable", "Installments.InstalmentDetail.InfoDialog.Title")
            }
        }
    }

    enum InstalmentList {
        /// "Следующий платёж"
        static let nextPayment = L10n.tr("Localizable", "InstalmentList.NextPayment")
        /// "9 месяцев"
        static let nineMonth = L10n.tr("Localizable", "InstalmentList.nineMonth")
        /// "9 мес."
        static let nineMonthShort = L10n.tr("Localizable", "InstalmentList.nineMonthShort")
        /// "1 год"
        static let oneYear = L10n.tr("Localizable", "InstalmentList.oneYear")
        /// "Осталось выплатить"
        static let remainsToPay = L10n.tr("Localizable", "InstalmentList.RemainsToPay")
        /// "6 месяцев"
        static let sixMonth = L10n.tr("Localizable", "InstalmentList.sixMonth")
        /// "6 мес."
        static let sixMonthShort = L10n.tr("Localizable", "InstalmentList.sixMonthShort")
        /// "3 месяца"
        static let threeMonth = L10n.tr("Localizable", "InstalmentList.threeMonth")
        /// "3 мес."
        static let threeMonthShort = L10n.tr("Localizable", "InstalmentList.threeMonthShort")
        /// "3 года"
        static let threeYears = L10n.tr("Localizable", "InstalmentList.threeYears")
        /// "Рассрочки"
        static let title = L10n.tr("Localizable", "InstalmentList.Title")
        /// "2 года"
        static let twoYears = L10n.tr("Localizable", "InstalmentList.twoYears")
        enum Accessibility {
            /// "Новая рассрочка"
            static let newInstalment = L10n.tr("Localizable", "InstalmentList.Accessibility.NewInstalment")
        }

        enum CreditSection {
            /// "Рассрочки кредитных карт"
            static let title = L10n.tr("Localizable", "InstalmentList.CreditSection.title")
        }

        enum DebitSection {
            /// "Деньги в рассрочку"
            static let title = L10n.tr("Localizable", "InstalmentList.DebitSection.title")
        }

        enum EmptyState {
            /// "Подключить"
            static let newInstalmentButtonTitle = L10n.tr("Localizable", "InstalmentList.EmptyState.NewInstalmentButtonTitle")
            /// "Понятно"
            static let understandButtonTitle = L10n.tr("Localizable", "InstalmentList.EmptyState.UnderstandButtonTitle")
            enum Subtitles {
                /// "Чтобы обновить льготный период по кредитной карте или получить деньги на любые траты без процентов"
                static let creditAndDebitOffers = L10n.tr("Localizable", "InstalmentList.EmptyState.Subtitles.CreditAndDebitOffers")
                /// "Льготный период по кредитной карте начнётся заново, и никаких процентов"
                static let onlyCreditOffer = L10n.tr("Localizable", "InstalmentList.EmptyState.Subtitles.OnlyCreditOffer")
                /// "Деньги сразу придут на карту — сможете потратить на что угодно, а возвращать без процентов"
                static let onlyDebitOffer = L10n.tr("Localizable", "InstalmentList.EmptyState.Subtitles.OnlyDebitOffer")
                /// "Пришлём пуш-уведомление или смс, когда появятся выгодные предложения по рассрочке"
                static let withoutOffers = L10n.tr("Localizable", "InstalmentList.EmptyState.Subtitles.WithoutOffers")
            }

            enum Titles {
                /// "Подключите рассрочку"
                static let withAnyOffer = L10n.tr("Localizable", "InstalmentList.EmptyState.Titles.WithAnyOffer")
                /// "Пока нет предложений для вас"
                static let withoutOffers = L10n.tr("Localizable", "InstalmentList.EmptyState.Titles.WithoutOffers")
            }
        }

        enum Error {
            enum Network {
                /// "Кажется, у вас нет сети"
                static let subtitle = L10n.tr("Localizable", "InstalmentList.Error.Network.Subtitle")
                /// "Ошибка соединения"
                static let title = L10n.tr("Localizable", "InstalmentList.Error.Network.Title")
            }
        }

        enum NextPayment {
            /// "До %@, %@"
            static func before(_ p1: Any, _ p2: Any) -> String {
                L10n.tr("Localizable", "InstalmentList.NextPayment.Before", String(describing: p1), String(describing: p2))
            }
        }

        enum PaymentSum {
            /// "Сумма платежей в месяц"
            static let title = L10n.tr("Localizable", "InstalmentList.PaymentSum.title")
        }

        enum SelectNewInstallmentType {
            /// "Отмена"
            static let cancelAction = L10n.tr("Localizable", "InstalmentList.SelectNewInstallmentType.CancelAction")
            /// "Рассрочка кредитной карты"
            static let creditInstallmentAction = L10n.tr("Localizable", "InstalmentList.SelectNewInstallmentType.CreditInstallmentAction")
            /// "Деньги в рассрочку"
            static let debitInstallmentAction = L10n.tr("Localizable", "InstalmentList.SelectNewInstallmentType.DebitInstallmentAction")
        }
    }
}

// MARK: - Private

private extension L10n {
    final class LocalizationDummy: NSObject { }

    static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let aClass = L10n.LocalizationDummy.self
        let bundle = Bundle.resourcesBundle(for: aClass, bundleName: .bundleName) ?? Bundle(for: aClass)
        let format = LocalizationString(key, table: table, bundle: bundle).localized()
        assert(key != format, "Failed to localize string for key: \(key)")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// MARK: - String

internal extension String {
    static let bundleName = "InstallmentsResources"

    func localized() -> String {
        let tables = [Tables.localizable, Tables.resources]
        let result = LocalizationString(self, tables: tables, bundles: bundles()).setAllowedTables([Tables.localizable]).localized()
        assert(self != result, "Failed to localize string: \(self)")
        return result
    }
}

private extension String {
    enum Tables {
        static let localizable = "Localizable"
        static let resources = "Resources"
    }

    func bundles() -> [Bundle] {
        let bundleForClass = Bundle(for: L10n.LocalizationDummy.self)

        guard
            let moduleBundle = Bundle.resourcesBundle(for: L10n.LocalizationDummy.self, bundleName: .bundleName),
            let mainResourcesBundle = Bundle.resourcesBundle(for: Resources.LocalizationDummy.self, bundleName: "Resources")
        else { assertionFailure("Bundle with resources not found"); return [] }
        return [moduleBundle, bundleForClass, mainResourcesBundle]
    }
}
