module ApplicationHelper
  def app_revision
    return @@revision if defined? @@revision

    revision_file = Rails.root.join("REVISION")
    @@revision = if File.readable?(revision_file)
                   logger.debug "Loading revision from file"
                   IO.read(revision_file).strip
                 else
                   logger.debug "No revision file, setting to 'unknown'"
                   "unknown"
                 end
  end
end
