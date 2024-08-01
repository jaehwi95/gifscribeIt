//
//  String+.swift
//  gifscribeIt
//
//  Created by Jaehwi Kim on 2024/08/01.
//

import Foundation

extension String {
    func attributedString() -> AttributedString {
        guard let nsAttributedString = try? NSAttributedString(data:  Data(self.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
            return AttributedString(stringLiteral: "")
        }
        
        guard let attributedString = try? AttributedString(nsAttributedString, including: \.uiKit) else {
            return AttributedString(stringLiteral: "")
        }
        
        return attributedString
    }
}
