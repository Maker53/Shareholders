//  Created by Vitaliy Ramazanov on 10/02/2021.

import ABUIComponents
import SharedProtocolsAndModels

protocol BuildsSkinImageSource: AnyObject {
    func buildSkinImageSource(skinURI: String?, placeholder: UIImage) -> ImageSource
}

class SkinImageSourceBuilder: BuildsSkinImageSource {
    /// Убирает параметр width из url query параметров
    func buildSkinImageSource(skinURI: String?, placeholder: UIImage) -> ImageSource {
        let unparametrizedURI = skinURI?
            .replacingOccurrences(of: "&width=%d", with: "")
            .replacingOccurrences(of: "width=%d&", with: "") ?? .empty

        let skinURL = URL(string: unparametrizedURI)

        return ImageSource(
            url: skinURL,
            placeholder: placeholder
        )
    }
}
