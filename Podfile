# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'My Wall' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for My Wall
    pod "UPCarouselFlowLayout"
    pod 'Cards'     
    pod 'INSPhotoGallery'
    pod 'INSNibLoading'
    pod 'UIScrollView-InfiniteScroll', '~> 1.0.0'
    pod 'SwiftyJSON'
    pod 'AlamofireImage', '~> 3.3'
    pod 'SVProgressHUD'
    pod 'PopupDialog', '~> 0.7'
    pod 'Ambience'
    pod 'Eureka'
    pod 'Appodeal', '~> 2.1.7'
    pod 'SwiftyOnboard'
    
    pod 'Armchair', '>= 0.3'
    
    #Add the following in order to automatically set debug flags for armchair in debug builds
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            if target.name == 'Armchair'
                target.build_configurations.each do |config|
                    if config.name == 'Debug'
                        config.build_settings['OTHER_SWIFT_FLAGS'] = '-DDebug'
                        else
                        config.build_settings['OTHER_SWIFT_FLAGS'] = ''
                    end
                end
            end
        end
    end
   
 target 'My WallTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'My WallUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
