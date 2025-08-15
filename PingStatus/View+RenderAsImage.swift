import SwiftUI

// Extension to render a SwiftUI View into an NSImage
extension View {
    func renderAsImage() -> NSImage? {
        let view = NSHostingView(rootView: self.edgesIgnoringSafeArea(.all))
        view.setFrameSize(view.fittingSize)
        
        guard let bitmapRep = view.bitmapImageRepForCachingDisplay(in: view.bounds) else {
            return nil
        }
        
        bitmapRep.size = view.bounds.size
        view.cacheDisplay(in: view.bounds, to: bitmapRep)
        
        let image = NSImage(size: view.bounds.size)
        image.addRepresentation(bitmapRep)
        
        // removing the template so that colors can show
        image.isTemplate = false
        
        return image
    }
}
