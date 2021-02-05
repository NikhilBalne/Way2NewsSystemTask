//
//  String+JsonDate.swift
//  SystemTask
//
//  Created by Nikhil Balne on 29/10/20.
//

import UIKit

extension String {
    
    func convertToJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
}

