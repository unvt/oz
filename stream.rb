require './constants'

def tgc
  Time.now.to_i / 1800
end

hooks = Hash.new

LAYERS.each {|layer|
  system "rm #{FIFO_DIR}/#{layer}" if File.exist?("#{FIFO_DIR}/#{layer}")
  system "mkfifo #{FIFO_DIR}/#{layer}"
  hooks[layer] = File.open("#{FIFO_DIR}/#{layer}", 'w+')
  system "tippecanoe --layer=#{layer} -o #{DST_DIR}/#{layer}.mbtiles \
--minimum-zoom=#{MINZOOM} --maximum-zoom=#{MAXZOOM} --force < #{FIFO_DIR}/#{layer} &"
}

count = 0
while gets
  count += 1
  zxy = $_.strip.split('/').map{|v| v.to_i}
  url = "#{SRC_BASE_URL}/#{$_.strip}"
  tile_path = "#{TMP_DIR}/#{zxy.join('-')}.pbf"
  system "curl --silent -o #{tile_path} #{url}"
  type = `file --brief #{tile_path}`.strip
  print "#{tgc} #{count} (#{sprintf('%.4f', 100.0 * count / SEQUENCE_LENGTH)}%): #{$_.strip}: #{type}\n"

  LAYERS.each {|layer|
    system <<-EOS
#{VT2GEOJSON_PATH} -gzipped=false -layer #{layer} \
-mvt #{tile_path} -z #{zxy[0]} -x #{zxy[1]} -y #{zxy[2]} > #{FIFO_DIR}/#{layer} 
    EOS
  } unless type == 'HTML document, UTF-8 Unicode text'
  system "rm #{TMP_DIR}/#{zxy.join('-')}.pbf"
end

LAYERS.each {|layer|
  hooks[layer].close
  system "rm #{FIFO_DIR}/#{layer}"
}

