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
      :geoLocation => [exif.gps.latitude,exif.gps.longitude],
      :imageSize => [exif.width, exif.height]
    }
  end
end
print data.to_json

