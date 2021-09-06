while gets
  zxy = $_.strip.split(',')[0].split('/').map {|v| v.to_i}
  next unless zxy[0] == 15
  print "#{zxy.join('/')}.pbf\n"
end

