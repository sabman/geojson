require File.join('utils', 'mars_helper.rb')
require File.join('utils', 'sdo_geometry.rb')
require File.join('active_record_for_mars', 'schema_dev.rb')
include GeoRuby::SimpleFeatures

#ProdDb.connection.execute("ALTER SESSION set NLS_DATE_FORMAT ='DD-MON-FXYYYY'")

params =  { 
  :eno=>455129,
  :sampleid=>'GA2476/006CAM002',
  :geom_original => nil,
  :start_lat=>-28.36372,
  :start_long=>112.88068,
  :start_depth=>906,
  :end_lat=>-28.34687,
  :end_long=>112.86782,
  :end_depth=>1866,
  :acquiredate=>'02-NOV-2008',
  :ano=>84,
  :activity_code=>'A',
  :access_code =>'A',
  :sample_type=>'UNDER WATER CAMERA',
  :origno => 641
}

@params = MarsHelper.convert_params_spatial_values_to_georuby(params)
pp @params
pp @params[:geom_original].as_sdo_geometry
