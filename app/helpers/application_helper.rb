module ApplicationHelper
  def app_revision
    revision_file = Rails.root.join("REVISION")
    if File.readable?(revision_file)
      IO.read(revision_file)
    else
      "unknown"
    end
  end
end
