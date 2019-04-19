class LocationsWithProfileAndRepo < AbstractReport

  register_report(params: [])

  def query_string
    <<~SOME_SQL

      SELECT DISTINCT
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
                lp.depth AS locationdepth,
                r.collectiontype,
                REPLACE (r.title,","," ") AS collectiontitle,
                REPLACE (r.identifier,","," ") AS collectionidentifier,
                r.eadid,
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
                cp.stacking_limit AS containerstackinglimit
      FROM      location l
      LEFT JOIN location_profile_rlshp lpr ON l.id = lpr.location_id
      LEFT JOIN location_profile lp ON lpr.location_profile_id = lp.id
      LEFT JOIN enumeration_value ev3 ON lp.dimension_units_id = ev3.id
      LEFT JOIN top_container_housed_at_rlshp tch ON l.id = tch.location_id
      LEFT JOIN top_container tc ON tch.top_container_id = tc.id
      LEFT JOIN enumeration_value ev1 ON tc.type_id = ev1.id
      LEFT JOIN top_container_profile_rlshp tcpr ON tc.id = tcpr.top_container_id
      LEFT JOIN container_profile cp ON tcpr.container_profile_id = cp.id
      LEFT JOIN enumeration_value ev2 ON cp.dimension_units_id = ev2.id
      LEFT JOIN top_container_link_rlshp tcl ON tc.id = tcl.top_container_id
      LEFT JOIN sub_container sc ON tcl.sub_container_id = sc.id
      LEFT JOIN (SELECT      i.*,
                             COALESCE(r1.ead_id, r2.ead_id, acc.ead_id) AS eadid,
                             COALESCE(r1.title, r2.title, acc.title) AS title,
                             COALESCE(r1.identifier, r2.identifier, acc.identifier) AS identifier,
                             COALESCE(r1.collectiontype, r2.collectiontype, acc.collectiontype) AS collectiontype
                 FROM      instance i
                 LEFT JOIN archival_object ao
                        ON i.archival_object_id = ao.id
                 LEFT JOIN (SELECT id, title, identifier, ead_id, 'archival_object' as collectiontype FROM resource) r1
                        ON ao.root_record_id = r1.id
                 LEFT JOIN (SELECT id, title, identifier, ead_id, 'resource' as collectiontype FROM resource) r2
                        ON i.resource_id = r2.id
                 LEFT JOIN (SELECT id, title, identifier, 'None' as ead_id, 'accession' as collectiontype FROM accession) acc
                        ON i.accession_id = acc.id) r
             ON sc.instance_id = r.id
      WHERE     tc.repo_id = #{db.literal(@repo_id)} AND tch.end_date IS NULL;

    SOME_SQL
  end
end
