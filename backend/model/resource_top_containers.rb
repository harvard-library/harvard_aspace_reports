class ResourceTopContainers < AbstractReport
  # Containers not associated with anything

  register_report(
    params: [['eadid', String, 'EADID of a resource to get containers for']]
  )

  def initialize(params, job, db)
    super

    @eadid = params.fetch('eadid')
  end

  def query_string
    <<~SOME_SQL
          SELECT REPLACE(r.title,","," ") AS resourcetitle,
               REPLACE (r.identifier,","," ") AS resourceidentifier,
               r.ead_id AS eadid,
               ev1.value AS containertype,
               tc.barcode AS containerbarcode,
               CONCAT("'",tc.indicator) AS containerindicator,
               cp.name AS containerprofile,
               cp.extent_dimension as extentdimension,
               ev2.value as dimensionunits,
               cp.height as containerheight,
               cp.width as containerwidth,
               cp.depth as containerdepth,
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
          FROM top_container tc
     LEFT JOIN enumeration_value ev1 ON tc.type_id = ev1.id
     LEFT JOIN top_container_profile_rlshp tcpr ON tc.id = tcpr.top_container_id
     LEFT JOIN container_profile cp ON tcpr.container_profile_id = cp.id
     LEFT JOIN enumeration_value ev2 ON cp.dimension_units_id = ev2.id
     LEFT JOIN top_container_link_rlshp tcl ON tc.id = tcl.top_container_id
     LEFT JOIN sub_container sc ON tcl.sub_container_id = sc.id
     LEFT JOIN instance i ON sc.instance_id = i.id
     LEFT JOIN archival_object ao ON i.archival_object_id = ao.id
     LEFT JOIN resource r ON ao.root_record_id = r.id
     LEFT JOIN top_container_housed_at_rlshp tch ON tc.id = tch.top_container_id
     LEFT JOIN location l ON tch.location_id = l.id
         WHERE eadid = #{db.literal(@eadid)} AND tch.end_date IS NULL AND tc.repo_id = #{db.literal(@repo_id)}
        UNION
        SELECT REPLACE (r.title,","," ") AS resourcetitle,
               REPLACE (r.identifier,","," ") AS resourceidentifier,
               r.ead_id AS eadid,
               ev1.value AS containertype,
               tc.barcode AS containerbarcode,
               CONCAT("'",tc.indicator) AS containerindicator,
               cp.name AS containerprofile,
               cp.extent_dimension as extentdimension,
               ev2.value as dimensionunits,
               cp.height as containerheight,
               cp.width as containerwidth,
               cp.depth as containerdepth,
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
          FROM top_container tc
     LEFT JOIN enumeration_value ev1 ON tc.type_id = ev1.id
     LEFT JOIN top_container_profile_rlshp tcpr ON tc.id = tcpr.top_container_id
     LEFT JOIN container_profile cp ON tcpr.container_profile_id = cp.id
     LEFT JOIN enumeration_value ev2 ON cp.dimension_units_id = ev2.id
     LEFT JOIN top_container_link_rlshp tcl ON tc.id = tcl.top_container_id
     LEFT JOIN sub_container sc ON tcl.sub_container_id = sc.id
     LEFT JOIN instance i ON sc.instance_id = i.id
     LEFT JOIN resource r ON i.resource_id = r.id
     LEFT JOIN top_container_housed_at_rlshp tch ON tc.id = tch.top_container_id
     LEFT JOIN location l ON tch.location_id = l.id
         WHERE eadid = #{db.literal(@eadid)} AND tch.end_date IS NULL AND tc.repo_id = #{db.literal(@repo_id)}
    SOME_SQL
  end

end
