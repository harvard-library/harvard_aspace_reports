class ContainerProfiles < AbstractReport

  register_report(params: [])

  def query_string
    <<~SOME_SQL
          SELECT cp.id AS containerprofilerecordid ,
                 cp.name AS containerprofile,
                 cp.extent_dimension AS containerprofileextentdimension,
                 ev1.value AS containerprofiledimensionunits,
                 cp.height AS containerheight,
                 cp.width AS containerwidth,
                 cp.depth AS containerdepth,
                 cp.stacking_limit AS containerstackinglimit
            FROM container_profile cp
       LEFT JOIN enumeration_value ev1 ON cp.dimension_units_id = ev1.id
        ORDER BY cp.id
    SOME_SQL
  end
end
