require 'json'

geoJson = { :type => "FeatureCollection", :features => [] }
ARGV.each do |p|
  if File.directory?(p)
    files = Dir.entries(p).select { |s| !File.directory?(s) }
    files = files.collect { |c| File.join(p,c) }
  else
    files = [p]
  end

  files.each do |f|
    data = JSON.parse(IO.read(f))
    data.each do |key, value|
      next if value["geoLocation"].nil?

      geoJson[:features] << {
        :type => "Feature",
        :geometry => {
          :type => "Point",
          :coordinates => value["geoLocation"]
        },
        :properties => {
          :name => "N/A",
          :description => "N/A"
        }
      }
    end
  end
end
print JSON.pretty_generate(geoJson)

