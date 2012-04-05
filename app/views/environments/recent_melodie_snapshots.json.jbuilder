json.recent_melodie_snapshots @recent_melodie_snapshots.all do |json, melodie_snapshot|
  #json.(melodie_snapshot , :id,
  #                         :environment_id,
  #                         :host,
  #                         :system_information,
  #                         :system_details)
  #json.melodie_snapshot do |json|
    json.id                 melodie_snapshot.id
    json.environment_id     melodie_snapshot.environment_id
    json.host               melodie_snapshot.host
    json.system_information melodie_snapshot.system_information
    json.system_details     melodie_snapshot.system_details
    #json.java_memory_used   java_memory_used_with_updated_at_title(melodie_snapshot.environment_id)
    json.java_memory_used   environment.java_memory_used_with_updated_at_title
    json.java               latest_melodie_stat_or_error(melodie_snapshot.environment_id, :system_details, :java)
  #end
end
