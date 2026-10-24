//
//  CameraPicker.swift
//  Cookbook
//
//  Created by Vu Hai Nam Nguyen on 2026-10-24.
//

import SwiftUI
import UIKit

struct CameraPicker: UIViewControllerRepresentable {
	@Binding var image: UIImage?
	@Environment(\.dismiss) private var dismiss

	// Create the camera
	func makeUIViewController(context: Context) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.sourceType = .camera
		picker.delegate = context.coordinator
		return picker
	}

	// Required by the protocol, nothing to update
	func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

	// Tells SwiftUI to create our Coordinator class
	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	// Receives the camera's callbacks
	final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		let parent: CameraPicker
		init(_ parent: CameraPicker) { self.parent = parent }

		func imagePickerController(
			_ picker: UIImagePickerController,
			didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
		) {
			if let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage {
				parent.image = image
			}
			parent.dismiss()
		}

		func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
			parent.dismiss()
		}
	}
}

extension UIImage {
	func squareJPEGData(side: CGFloat = 1200, quality: CGFloat = 0.8) -> Data? {
		let shortest = min(size.width, size.height)
		let target = min(side, shortest)          // never upscale
		let scale = target / shortest

		// scale so the SHORT edge fits exactly, long edge overflows
		let drawSize = CGSize(width: size.width * scale, height: size.height * scale)

		// shift the overflow equally on both sides = center crop
		let origin = CGPoint(x: (target - drawSize.width) / 2,
							 y: (target - drawSize.height) / 2)

		let format = UIGraphicsImageRendererFormat.default()
		format.scale = 1

		let renderer = UIGraphicsImageRenderer(size: CGSize(width: target, height: target),
											   format: format)
		let squared = renderer.image { _ in
			self.draw(in: CGRect(origin: origin, size: drawSize))
		}
		return squared.jpegData(compressionQuality: quality)
	}
}
