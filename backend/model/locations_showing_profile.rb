class LocationsShowingProfile < AbstractReport

  register_report(params: [])

  def query_string
    <<~SOME_SQL
          SELECT l.id AS locationrecordid,
                 l.building AS locationbuilding,
                 l.floor AS locationfloor,
                 l.room AS locationroom,
                 l.area AS locationarea,
                 l.barcode AS locationbarcode,
                 l.classification AS locationclassification,
                 l.coordinate_1_label AS coordinate1label,
                 l.coordinate_1_indicator AS coordinate1indicator,
                 l.coordinate_2_label AS coordinate2label,
                 l.coordinate_2_indicator AS coordinate2indicator,
                 l.coordinate_3_label AS coordinate3label,
                 l.coordinate_3_indicator AS coordinate3indicator,
                 l.temporary_id AS locationistemporary,
                 lp.id AS locationprofilerecordid,
                 lp.name AS locationprofile,
                 ev1.value AS locationprofiledimensionunits,
                 lp.height AS locationheight,
                 lp.width AS locationwidth,
                 lp.depth AS locationdepth
            FROM location l
       LEFT JOIN location_profile_rlshp lpr ON l.id = lpr.location_id
       LEFT JOIN location_profile lp ON lpr.location_profile_id = lp.id
       LEFT JOIN enumeration_value ev1 ON lp.dimension_units_id = ev1.id
        ORDER BY l.id
    SOME_SQL
  end
end
