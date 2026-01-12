
import SwiftUI

struct StyledDatePicker: View {
    var label: String
    @Binding var selection: Date
    
    var body: some View {
        DatePicker(label, selection: $selection, displayedComponents: .date)
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .padding()
            .background(Color(red: 66/255, green: 66/255, blue: 66/255))
            .cornerRadius(12)
            .colorScheme(.dark)
            .accentColor(.orange) 
    }
}

#Preview {
}
