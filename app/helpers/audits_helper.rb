module AuditsHelper
  def auditable_name(audit)
    "#{audit.auditable_type} ##{audit.auditable_id}"
  end

  def audit_changes(audit)
    case audit.audit_type
    when 'create'
      'Created'
    when 'destroy'
      'Destroy'
    when 'update'
      render partial: 'audit_changes', locals: { changes: audit.audit_changes }
    end
  end
end
