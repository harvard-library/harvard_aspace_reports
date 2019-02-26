class LocationProfilesLocations < AbstractReport
  # Locations with location profiles

  register_report(
    params: []
  )


  def query_string
    <<~SOME_SQL
      SELECT lp.name,
             l.id as locationrecordid,
             l.building as locationbuilding,
             l.floor as locationfloor,
             l.room as locationroom,
             l.area as locationarea,
             l.coordinate_1_label as coordinate1label,
             l.coordinate_1_indicator as coordinate1indicator,
             l.coordinate_2_label as coordinate2label,
             l.coordinate_2_indicator as coordinate2indicator,
             l.coordinate_3_label as coordinate3label,
             l.coordinate_3_indicator as coordinate3indicator
      FROM location l
      JOIN location_profile_rlshp lpr ON l.id = lpr.location_id
      JOIN location_profile lp ON lpr.location_profile_id = lp.id
    SOME_SQL
  end
end
