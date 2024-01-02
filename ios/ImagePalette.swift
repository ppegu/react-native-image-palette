
import Foundation
import UIKit
 
@objc(ImagePalette)
class ImagePalette: NSObject {

  @objc(multiply:withB:withResolver:withRejecter:)
  func multiply(a: Float, b: Float, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    resolve(a*b)
  }

    public enum QUALITY {
        static let LOWEST = "lowest";
        static let LOW = "low";
        static let HIGH = "high";
        static let HIGHEST = "highest";
    }

    public func getQuality(qualityOption: String) -> UIImageColorsQuality {
        switch qualityOption {
        case QUALITY.LOWEST:
            return UIImageColorsQuality.lowest
        case QUALITY.LOW:
            return UIImageColorsQuality.low
        case QUALITY.HIGH:
            return UIImageColorsQuality.high
        case QUALITY.HIGHEST:
            return UIImageColorsQuality.highest
        default:
            return UIImageColorsQuality.low
        }
    }


    public func toHexString(color: UIColor) -> String {

        let comp = color.cgColor.components
        
        let r: CGFloat = comp![0]
        let g: CGFloat = comp![1]
        let b: CGFloat = comp![2]
        
        let rgb: Int = (Int)(r * 255) << 16 | (Int)(g * 255) << 8 | (Int)(b * 255) << 0

        let colorHex = String(format: "#%06X", rgb)
              
        return colorHex
    }
    
 
    @objc class ImagePaletteConfig: NSObject {
        var quality: String = QUALITY.LOW
        var fallback: String = "#000000"
        var headers: NSDictionary? = nil
        
        
        init(config: NSDictionary) {
            
            if let propsValue = config.value(forKey: "quality") as? String {
                 self.quality = propsValue
            }
            if let propsValue = config.value(forKey: "fallback") as? String {
                 self.fallback = propsValue
            }
            if let propsValue = config.value(forKey: "headers") as? NSDictionary {
                 self.headers = propsValue
            }
             
        }
    }
    
  
    @objc(getColors:config:resolver:rejecter:)
    func getColors(imageURI: String, configProps: NSDictionary, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
        
        
        let config = ImagePaletteConfig(config: configProps)
        
 
        guard let imageURL = URL(string: imageURI) else {
            rejecter("INVALID_URL", "Invalid image URL" + imageURI, nil)
            return
        }
        

         // Asynchronously load the image
        URLSession.shared.dataTask(with: imageURL) {[unowned self] (data, response, error) in 
      
            if let error = error {
                rejecter("FAILED", "Failed to load image: \(error.localizedDescription)", nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                rejecter("FAILED", "Failed to convert data to image", nil)
                return
            }

        
            
            let quality = getQuality(qualityOption: config.quality)

            image.getColors(quality: quality) { colors in
 
                  var colorsDictionary: Dictionary<String, String> = ["platform": "ios"]
                  
                  if let background = colors?.background {
                      colorsDictionary["background"] = self.toHexString(color: background)
                  } else {colorsDictionary["background"] = config.fallback}
                  
                  if let primary = colors?.primary {
                      colorsDictionary["primary"] = self.toHexString(color: primary)
                  } else {colorsDictionary["primary"] = config.fallback}
                  
                  if let secondary = colors?.secondary {
                      colorsDictionary["secondary"] = self.toHexString(color: secondary)
                  } else {colorsDictionary["secondary"] = config.fallback}

                  if let detail = colors?.detail {
                      colorsDictionary["detail"] = self.toHexString(color: detail)
                  } else {colorsDictionary["detail"] = config.fallback}

                  
                resolver(colorsDictionary)
                
                
           }
    
        }.resume()

       
    }

    
} 
