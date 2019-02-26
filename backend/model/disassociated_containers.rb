class DissociatedContainers < AbstractReport
  # Containers not associated with anything

  register_report(
    params: []
  )

  def query_string
    <<~SOME_SQL
      SELECT tc.id, tc.indicator, tc.barcode, tc.ils_holding_id as holding_id, tc.ils_item_id as item_id
      FROM top_container tc
      LEFT OUTER JOIN top_container_link_rlshp tclr ON tclr.top_container_id = tc.id
      WHERE tclr.id IS NULL AND tc.repo_id = #{db.literal(@repo_id)}
    SOME_SQL
  end

end
