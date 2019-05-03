class TopContainersInRepository < AbstractReport

  register_report(params: [])

  def query_string
    <<~SOME_SQL
          SELECT "Resource" AS collectiontype,
                 REPLACE (r.title,","," ") AS collectiontitle,
                 REPLACE (r.identifier,","," ") AS collectionidentifier,
                 r.ead_id AS eadid,
                 tc.id AS containerrecordid,
                 ev1.value AS containertype,
                 CONCAT("'",tc.indicator) AS containerindicator,
                 tc.barcode AS containerbarcode,
                 tc.ils_holding_id AS containerilsholdingid,
                 tc.ils_item_id AS containerilsitemid,
                 tc.exported_to_ils AS containerexportedtoils,
                 tch.status AS containerlocationstatus,
                 tch.start_date AS containerlocationstartdate,
                 tch.note AS containerlocationnote,
                 cp.id AS containerprofilerecordid,
                 cp.name AS containerprofile,
                 cp.extent_dimension AS containerprofileextentdimension,
                 ev2.value AS containerprofiledimensionunits,
                 cp.height AS containerheight,
                 cp.width AS containerwidth,
                 cp.depth AS containerdepth,
                 cp.stacking_limit AS containerstackinglimit,
                 l.id AS locationrecordid,
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
                 ev3.value AS locationprofiledimensionunits,
                 lp.height AS locationheight,
                 lp.width AS locationwidth,
                 lp.depth AS locationdepth
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
       LEFT JOIN location_profile_rlshp lpr ON l.id = lpr.location_id
       LEFT JOIN location_profile lp ON lpr.location_profile_id = lp.id
       LEFT JOIN enumeration_value ev3 ON lp.dimension_units_id = ev3.id
           WHERE tc.repo_id = #{db.literal(@repo_id)} AND tch.end_date IS NULL AND r.ead_id IS NOT NULL
       UNION
         SELECT 'Accession' AS collectiontype,
                REPLACE (a.title,","," ") AS collectiontitle,
                REPLACE (a.identifier,","," ") AS collectionidentifier,
                "None" AS eadid,
                tc.id AS containerrecordid,
                ev1.value AS containertype,
                CONCAT("'",tc.indicator) AS containerindicator,
                tc.barcode AS containerbarcode,
                tc.ils_holding_id AS containerilsholdingid,
                tc.ils_item_id AS containerilsitemid,
                tc.exported_to_ils AS containerexportedtoils,
                cp.id AS containerprofilerecordid ,
                cp.name AS containerprofile,
                cp.extent_dimension AS containerprofileextentdimension,
                ev2.value AS containerprofiledimensionunits,
                cp.height AS containerheight,
                cp.width AS containerwidth,
                cp.depth AS containerdepth,
                cp.stacking_limit AS containerstackinglimit,
                l.id AS locationrecordid,
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
                ev3.value AS locationprofiledimensionunits,
                lp.height AS locationheight,
                lp.width AS locationwidth,
                lp.depth AS locationdepth
           FROM top_container tc
      LEFT JOIN enumeration_value ev1 ON tc.type_id = ev1.id
      LEFT JOIN top_container_profile_rlshp tcpr ON tc.id = tcpr.top_container_id
      LEFT JOIN container_profile cp ON tcpr.container_profile_id = cp.id
      LEFT JOIN enumeration_value ev2 ON cp.dimension_units_id = ev2.id
      LEFT JOIN top_container_link_rlshp tcl ON tc.id = tcl.top_container_id
      LEFT JOIN sub_container sc ON tcl.sub_container_id = sc.id
      LEFT JOIN instance i ON sc.instance_id = i.id
      LEFT JOIN accession a ON i.accession_id = a.id
      LEFT JOIN top_container_housed_at_rlshp tch ON tc.id = tch.top_container_id
      LEFT JOIN location l ON tch.location_id = l.id
      LEFT JOIN location_profile_rlshp lpr ON l.id = lpr.location_id
      LEFT JOIN location_profile lp ON lpr.location_profile_id = lp.id
      LEFT JOIN enumeration_value ev3 ON lp.dimension_units_id = ev3.id
          WHERE tc.repo_id = #{db.literal(@repo_id)} AND tch.end_date IS NULL AND a.id IS NOT NULL
    SOME_SQL
  end

end
