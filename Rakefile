# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'


require "bundler"
Bundler.require :default

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'webview_shell'
  app.device_family = :ipad
  app.interface_orientations = [:landscape_left, :landscape_right]

  app.files.unshift(Dir.glob("./lib/**/*.rb"))

  app.icons = ["webview_icon.jpeg"]
  # app.info_plist['UIMainStoryboardFile'] = 'MainStoryboard'

  app.pods do
    pod "ZipKit"
    pod "AQGridView"
    pod "NanoStore"
  end
end
