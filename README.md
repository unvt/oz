# oz
Server-side over-zooming

# Purpose
Create vector tiles in bigger zoom levels to relieve ArcGIS API for JavaScript.

# Requirements
- Ruby
- vt2geojson
- tippecanoe

# Install
FIXME  
(Windows)
vt2geojson does not work on powershell. It works on docker.

```console
git clone https://github.com/unvt/oz
cd oz
docker run -it --rm -v ${PWD}:/data unvt/nanban
cd /data
npm install -g @mapbox/vt2geojson
```

# Use
1. update `constants.rb`
2. create/update `mokuroku.sequence`
3. `rake`
