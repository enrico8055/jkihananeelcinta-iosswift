import SwiftUI
import PhotosUI

struct ProfileImagePicker: View {
    @Binding var image: UIImage?
    @State private var showPicker = false
    
    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.orange, lineWidth: 3))
                    .shadow(radius: 4)
                    .onTapGesture {
                        showPicker = true
                    }
            } else {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 120, height: 120)
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.white)
                }
                .onTapGesture {
                    showPicker = true
                }
            }
            
            Text("Tap untuk pilih foto")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .photosPicker(isPresented: $showPicker, selection: $image) 
    }
}

extension View {
    func photosPicker(isPresented: Binding<Bool>, selection: Binding<UIImage?>) -> some View {
        self.background(
            PhotosPickerWrapper(isPresented: isPresented, image: selection)
        )
    }
}


import PhotosUI

struct PhotosPickerWrapper: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented && context.coordinator.picker == nil {
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            uiViewController.present(picker, animated: true)
            context.coordinator.picker = picker
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotosPickerWrapper
        var picker: PHPickerViewController?
        
        init(_ parent: PhotosPickerWrapper) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isPresented = false
            self.picker?.dismiss(animated: true)
            self.picker = nil
            
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}

#Preview {
}
