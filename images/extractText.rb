# file:    extractText.rb
# purpose: extract text from images
# usage:   extractText.rb <imageFile> <folderOfImages>
# input:   space separated list of files and folders on the command line
# output:  json to stdout with file name as keys to text content

# NOTICE: Windows Dependent
#####################################################################################################
# Helpful Link:  http://rubyonwindows.blogspot.com/2009/08/ocr-converting-images-to-text-with-modi.html
# Install MODI: http://support.microsoft.com/kb/982760
#####################################################################################################
# TODO: Reimplement to be platform agnostic

require 'win32ole'
require 'json'

data = {}
ARGV.each do |p|
  if File.directory?(p)
    files = Dir.entries(p).select { |s| !File.directory?(s) }
    files = files.collect { |c| File.join(p,c) }
  else
    files = [p]
  end

  doc = WIN32OLE.new('MODI.Document')
  files.each do |f|
    # TODO - balance image color

    doc.Create(f)
    begin
      doc.OCR()

      for image in doc.Images
        data[f] = image.Layout.Text
      end
    rescue Exception => e
      #data[f] = e.message
    end
  end
end
print JSON.pretty_generate(data)
