class ContainerProfileTopContainers < AbstractReport
  # Containers not associated with anything

  register_report(
    params: [['profile_name', String, 'Container profile to retrieve containers for']]
  )

  def initialize(params, job, db)
    super

    @profile_name = params.fetch('profile_name')
  end

  def query_string
    <<~SOME_SQL
      SELECT DISTINCT cp.name AS containerprofile,
                      tc.id as topcontainerrecordid,
                      ev1.value AS topcontainertype,
                      tc.barcode AS topcontainerbarcode,
                      CONCAT("'",tc.indicator) AS topcontainerindicator,
                      REPLACE (r.title,","," ") AS resourcetitle,
                      REPLACE (r.identifier,","," ") AS resourceidentifier,
                      r.ead_id AS eadid
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
                WHERE tc.repo_id = #{db.literal(@repo_id)} AND cp.name = #{db.literal(@profile_name)}
    SOME_SQL
  end

end
