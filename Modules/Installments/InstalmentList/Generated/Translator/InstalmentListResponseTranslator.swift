//
// InstalmentListResponse Translator
// Generated on 17/09/2020 by gen v0.4.0
//

import AlfaFoundation

struct InstalmentListResponseTranslator: Translator {
    let instalmentTranslator: AnyTranslator<Instalment>

    init(
        instalmentTranslator: AnyTranslator<Instalment> = .init(InstalmentTranslator())
    ) {
        self.instalmentTranslator = instalmentTranslator
    }

    func translateFrom(dictionary json: [String: Any]) throws -> InstalmentListResponse {
        let instalments = try instalmentTranslator.translateFrom(array: json.get(DTOKeys.instalments))
        return InstalmentListResponse(
            instalments: instalments
        )
    }
}

extension InstalmentListResponseTranslator {
    enum DTOKeys: String {
        case instalments
    }
}
