Pod::Spec.new do |s|
    s.name             = "ZamzamKit"
    s.version          = "0.2.8"
    s.summary          = "A Swift framework for rapidly developing iOS and WatchKit apps."
    s.description      = <<-DESC
                        ZamzamKit is a Swift framework for iOS and WatchKit to allow
                        developers to code rapidly for building mobile applications.
                        Focus on solutions by using our API that sits as an
                        abstraction layer on top of iOS, WatchKit, and Swift.
                        ZamzamKit provides you the latest patterns, techniques,
                        and libraries so you can begin building for the future.
                       DESC
    s.homepage     = "https://github.com/ZamzamInc/ZamzamKit"
    # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "Zamzam Inc." => "contact@zamzam.io" }
    s.social_media_url   = "https://twitter.com/zamzaminc"
    s.source           = { :git => "https://github.com/ZamzamInc/ZamzamKit.git", :tag => s.version }
    s.platform     = :ios, '8.3'
    s.requires_arc = true
    s.source_files = 'Pod/Classes/**/*'
    s.resource_bundles = {
        'ZamzamKit' => ['Pod/Assets/*.png']
    }
    s.dependency 'Timepiece'
    s.dependency 'SwiftyTimer'
end