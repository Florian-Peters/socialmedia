//
//  View+Extansions.swift
//  LocalVibes
//
//  Created by Florian Peters on 17.10.23.
//

import SwiftUI

// MARK: View Extensions For UI Building
extension View{
    func closeKeyboard(){
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
// MARK: Disabling with Opacity
    func disableWithOpacity(_ condition: Bool)-> some View{
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    func hAlign(_ alignment: Alignment)-> some View{
        self
            .frame(maxWidth: .infinity,alignment: alignment)
        
    }
    
    func vAlgin(_ alignment: Alignment)-> some View{
        self.frame(maxHeight: .infinity,alignment: alignment)
    }
    
    //MARK: Custom Border View With Padding
    func border(_ width: CGFloat,_ color: Color)-> some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .stroke(color, lineWidth: width)
            }
        
        
    }
    //MARK: Custom FILL View With Padding
    func fillViwe(_  color: Color)-> some View{
        self
            .padding(.horizontal,15)
            .padding(.vertical,10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(color)
            }
        
        
    }
}
