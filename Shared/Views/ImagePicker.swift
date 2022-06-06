//
//  ImagePicker.swift
//  CocktailBucket
//
//  Created by Mrabti Idriss on 06.06.22.
//

import SwiftUI
import CropViewController

struct ImagePicker: UIViewControllerRepresentable {
    
    private let pictureArea: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 10.0
        view.layer.shadowOpacity = 0.9
        view.layer.shadowOffset = CGSize.zero
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else {
                parent.presentationMode.wrappedValue.dismiss()
                return
            }
            
            let cropController = CropViewController(croppingStyle: CropViewCroppingStyle.default, image: image)
            cropController.delegate = self
            cropController.aspectRatioPreset = .presetSquare
            cropController.aspectRatioLockEnabled = true
            picker.pushViewController(cropController, animated: true)
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            parent.image = image
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        
        if sourceType == .camera {
            picker.cameraOverlayView = pictureArea
            DispatchQueue.main.async {
                NSLayoutConstraint.activate([
                    pictureArea.centerXAnchor.constraint(equalTo: picker.view.centerXAnchor),
                    pictureArea.centerYAnchor.constraint(equalTo: picker.view.centerYAnchor),
                    pictureArea.widthAnchor.constraint(equalToConstant: 280),
                    pictureArea.heightAnchor.constraint(equalToConstant: 280)
                ])
            }
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}
