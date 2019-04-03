class ArchivalObjectsLackingTopContainers < AbstractReport

  register_report(params: [])

  def query_string
    <<~SOME_SQL
          SELECT REPLACE (r.title,","," ") AS resourcetitle,
                 REPLACE (r.identifier,","," ") AS resourceidentifier,
                 r.ead_id AS eadid,
                 ao.id AS archivalobjectrecordid,
                 ao.ref_id AS archivalobjectrefid,
                 concat("'",ao.component_id) AS archivalobjectidentifier,
                 REPLACE (ao.title,","," ") AS archivalobjecttitle,
                 ev.value AS archivalobjectlevel,
                 ao.other_level AS archivalobjectotherlevel,
                 (SELECT COUNT(*) FROM instance i
	               WHERE i.instance_type_id = '352' AND i.archival_object_id = ao.id) AS digitalobjectinstances
            FROM archival_object ao
       LEFT JOIN enumeration_value ev ON ao.level_id = ev.id
       LEFT JOIN resource r ON ao.root_record_id = r.id
       LEFT JOIN instance i ON ao.id = i.archival_object_id
           WHERE ao.repo_id = #{db.literal(@repo_id)} AND (i.instance_type_id = '352' OR i.id IS NULL)
    SOME_SQL
  end
end
