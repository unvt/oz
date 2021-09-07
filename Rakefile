require './constants'

desc 'create tiles'
task :tiles do
  sh "shuf mokuroku.sequence | ruby stream.rb"
end

desc 'craete mokuroku'
task :mokuroku do
  sh "zcat mokuroku.csv.gz | ruby mokuroku.rb > mokuroku.sequence"
end

