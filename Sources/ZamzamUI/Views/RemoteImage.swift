//
//  RemoteImage.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-10-01.
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI

/// Image the asynchronously loads its resource from a URL.
@available(OSX 11, iOS 14, tvOS 14, watchOS 7, *)
public struct RemoteImage: View {
    @StateObject private var service: Service
    private let placeholderImage: Image
    private let failureImage: Image

    public var body: some View {
        makeImage()
            .resizable()
            .scaledToFit()
    }

    public init(
        url: URL?,
        placeholderImage: Image = Image(systemName: "photo"),
        failureImage: Image = Image(systemName: "multiply.circle")
    ) {
        self._service = StateObject(wrappedValue: Service(url: url))
        self.placeholderImage = placeholderImage
        self.failureImage = failureImage
    }
}

@available(OSX 11, iOS 14, tvOS 14, watchOS 7, *)
private extension RemoteImage {

    func makeImage() -> Image {
        switch service.status {
        case .loading:
            return placeholderImage
        case let .success(data):
            guard let image = PlatformImage(data: data) else {
                return failureImage
            }

            return Image(platformImage: image)
        case .failure:
            return failureImage
        }
    }
}

@available(OSX 11, iOS 14, tvOS 14, watchOS 7, *)
private extension RemoteImage {

    enum Status {
        case loading
        case success(Data)
        case failure
    }

    class Service: ObservableObject {
        @Published private(set) var status: Status = .loading

        init(url: URL?) {
            guard let url = url else { return }

            #warning("Implement image caching here using disk-based caching or NSCache")
            URLSession.shared.dataTask(with: url) { data, _, error in
                DispatchQueue.main.async {
                    if let data = data, !data.isEmpty, error == nil {
                        self.status = .success(data)
                    } else {
                        self.status = .failure
                    }
                }
            }.resume()
        }
    }
}
#endif
