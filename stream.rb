require './constants'

File.foreach(SEQUENCE_PATH) {|l|
  zxy = l.strip.split('/').map{|v| v.to_i}
  url = "#{SRC_BASE_URL}/#{l.strip}"
  tile_path = "#{TMP_DIR}/#{zxy.join('-')}.pbf"
  unless File.exist?(tile_path)
    system "curl --silent -o #{tile_path} #{url}"
  end
  `#{VT2GEOJSON_PATH} -gzipped=false -mvt #{tile_path} -summary`.split("\n").each {|l|
    /layer (.*?),/.match l
    system <<-EOS
#{VT2GEOJSON_PATH} -gzipped=false -layer #{$1} \
-mvt #{tile_path} -z #{zxy[0]} -x #{zxy[1]} -y #{zxy[2]} | \
tippecanoe --layer=#{$1} -o #{DST_DIR}/#{zxy.join('-')}-#{$1}.mbtiles \
--minimum-zoom=#{MINZOOM} --maximum-zoom=#{MAXZOOM} --force
    EOS
  }
  system "rm #{TMP_DIR}/#{zxy.join('-')}.pbf"
}

