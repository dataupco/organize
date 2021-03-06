# file:    extractMetadata.rb
# purpose: extract metadata from images
# usage:   extractMetadata.rb <imageFile> <folderOfImages> 
# input:   space separated list of files and folders on the command line
# output:  json to stdout with filename as keys to a hash of the following properties
#          [ cameraMake, cameraModel, timestamp, geoLocation, imageSize ]

require 'exifr'
require 'json'

data = {}
ARGV.each do |p|
  if File.directory?(p)
    files = Dir.entries(p).select { |s| !File.directory?(s) }
    files = files.collect { |c| File.join(p,c) }
  else
    files = [p]
  end

  files.each do |f|
    exif = EXIFR::JPEG.new(f)
    data[f] = { 
      :cameraMake => exif.make,
      :cameraModel => exif.model,
      :timestamp => exif.date_time_original,
      :geoLocation => exif.gps.nil? ? nil : [exif.gps.longitude, exif.gps.latitude, exif.gps.altitude],
      :imageSize => [exif.width, exif.height]
    }
  end
end
print JSON.pretty_generate(data)

