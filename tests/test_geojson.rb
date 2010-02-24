require 'rubygems'
require 'test/unit'
require 'json'
require 'geojson'
require 'active_support' 

class GeojsonTest < Test::Unit::TestCase
  include GeoRuby::SimpleFeatures
  include ActiveSupport

  def check_geom(geojson, expected)
    geom=Geometry.from_geojson(geojson)
    assert_equal(expected, geom)
    assert_equal(geojson.gsub(/\s/, ""), geom.to_json.gsub(/\s/, ""))
  end

  def test_point_from_hash
    geom=Geometry.from_geojson(JSON::decode('{ "type": "Point", "coordinates": [100.0, 0.0] }'))
    assert_equal(Point.from_coordinates([100.0, 0.0]), geom)
  end

  def test_point
    check_geom('{ "type": "Point", "coordinates": [100.0, 0.0] }',
               Point.from_coordinates([100.0, 0.0])) 
  end

  def test_linestring
    check_geom('{ "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }',
               LineString.from_coordinates([ [100.0, 0.0], [101.0, 1.0] ]))
  end

  def test_polygon_no_hole
    check_geom('{ "type": "Polygon", "coordinates": [ [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ] ] }',
               Polygon.from_coordinates([ [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ] ]))
  end

  def test_polygon_with_hole
    check_geom('{ "type": "Polygon", "coordinates": [ [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ], [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ] ] }',
               Polygon.from_coordinates([ [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ], [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ] ]))
  end

  def test_multi_point
    check_geom('{ "type": "MultiPoint", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ] }',
               MultiPoint.from_coordinates([ [100.0, 0.0], [101.0, 1.0] ]))
  end

  def test_multi_linestring
    check_geom('{ "type": "MultiLineString", "coordinates": [ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ] }',
               MultiLineString.from_coordinates([ [ [100.0, 0.0], [101.0, 1.0] ], [ [102.0, 2.0], [103.0, 3.0] ] ]))
  end

  def test_multi_polygon_no_hole
    check_geom('{ "type": "MultiPolygon", "coordinates": [ [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]], [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]], [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]] ] }',
               MultiPolygon.from_coordinates([ [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]], [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]], [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]] ]))
  end

  def test_geometry_collection
    check_geom('{ "type": "GeometryCollection", "geometries": [ { "type": "Point", "coordinates": [100.0, 0.0] }, { "type": "LineString", "coordinates": [ [101.0, 0.0], [102.0, 1.0] ] } ] }', GeometryCollection.from_geometries([Point.from_coordinates([100.0, 0.0]),
               LineString.from_coordinates([ [101.0, 0.0], [102.0, 1.0] ])]))
  end

  def test_feature
    check_geom('{ "type": "Feature", "geometry": {"type": "Point", "coordinates": [102.0, 0.5]}, "properties": {"prop0": "value0"} }',
               Feature.new(Point.from_coordinates([102.0, 0.5]), {"prop0"=>"value0"}))
  end

  def test_feature_collection
    check_geom('{ "type": "FeatureCollection", "features": [{"type": "Feature", "geometry": {"type": "Point", "coordinates":[102.0, 0.5]}, "properties": {"prop0": "value0"}, "id": "toto"}, {"type": "Feature", "geometry": {"type": "LineString", "coordinates": [[102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0]]}, "properties": {"prop0": "value0", "prop1": 0.0}}]}',
               FeatureCollection.new([
                 Feature.new(Point.from_coordinates([102.0, 0.5]), {"prop0"=>"value0"}, "toto"),
                 Feature.new(LineString.from_coordinates([ [102.0, 0.0], [103.0, 1.0], [104.0, 0.0], [105.0, 1.0] ]), {"prop0"=>"value0", "prop1"=>0.0})
               ])
    )
  end

end
